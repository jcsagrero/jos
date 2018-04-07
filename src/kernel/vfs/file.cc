#include "kernel/vfs/file.h"

#include "kernel/vfs/inode.h"
#include "kernel/vfs/superblock.h"

namespace vfs {

File::File(Inode* inode) : inode_(inode), offset_(0) {}

struct ReadReadClusterArg {
  File* file;
  uint8_t* dest;
  uint64_t length;
  uint64_t length_remaining;
  uint64_t offset_into_block;
  uint64_t cluster;
  void (*callback)();
  uint8_t* buffer;
};
// static
void File::ReadReadCluster(void* void_arg) {
  ReadReadClusterArg* arg = (ReadReadClusterArg*)void_arg;

  int bytes_to_copy = 512 - arg->offset_into_block;
  if (arg->length_remaining < bytes_to_copy) {
    bytes_to_copy = arg->length_remaining;
  }
  memcpy(arg->dest, arg->buffer + arg->offset_into_block, bytes_to_copy);

  arg->dest += bytes_to_copy;
  arg->length_remaining -= bytes_to_copy;
  arg->offset_into_block = 0;

  arg->cluster =
      arg->file->inode_->GetSuperblock()->GetNextCluster(arg->cluster);

  if (arg->length_remaining > 0) {
    arg->file->inode_->GetSuperblock()->ReadCluster(arg->cluster, arg->buffer,
                                                    ReadReadCluster, arg);
  } else {
    arg->file->offset_ += arg->length;
    arg->callback();
    kfree(arg->buffer);
    delete arg;
  }
}

int File::Read(uint8_t* dest, uint64_t length, void (*callback)()) {
  if (offset_ + length > inode_->GetSize()) {
    callback();
    return 1;
  }

  uint64_t cluster = inode_->GetCluster();
  uint64_t offset_remaining = offset_;
  while (offset_remaining > 512) {
    cluster = inode_->GetSuperblock()->GetNextCluster(cluster);
    offset_remaining -= 512;
  }

  if (length) {
    ReadReadClusterArg* arg = new ReadReadClusterArg();
    arg->file = this;
    arg->dest = dest;
    arg->length = length;
    arg->length_remaining = length;
    arg->offset_into_block = offset_remaining;
    arg->cluster = cluster;
    arg->callback = callback;
    arg->buffer = (uint8_t*)kmalloc(512);
    inode_->GetSuperblock()->ReadCluster(arg->cluster, arg->buffer,
                                         ReadReadCluster, arg);
  } else {
    callback();
  }
  return 0;
}

int File::Write(uint8_t* src, uint64_t length, void (*callback)()) {
  // TODO
  return 1;
}

int File::Seek(uint64_t offset) {
  if (offset >= inode_->GetSize()) {
    return 1;
  }
  offset_ = offset;
  return 0;
}

int File::Close() {
  // TODO what should be done here
  return 0;
}

uint64_t File::GetSize() {
  return inode_->GetSize();
}

}  // namespace vfs
