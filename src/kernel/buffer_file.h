#ifndef BUFFER_FILE_H_
#define BUFFER_FILE_H_

#include "ipc.h"
#include "kernel/proc.h"
#include "shared/jbuffer.h"
#include "shared/jarray.h"

class BufferFile : public ipc::File {
 public:
  BufferFile();

  BufferFile(const BufferFile& other) = delete;
  BufferFile& operator=(const BufferFile& other) = delete;
  BufferFile(BufferFile&& other) = delete;
  BufferFile& operator=(BufferFile&& other) = delete;

  ipc::Pipe* Open(ipc::Mode mode) override;
  void Close(ipc::Pipe* pipe) override;
  int GetNumPipes() override;

  void Write(ipc::Pipe* pipe,
             const uint8_t* source_buffer,
             int write_size,
             int* size_writeback) override;
  void Read(ipc::Pipe* pipe,
            uint8_t* dest_buffer,
            int read_size,
            int* size_writeback) override;

 private:
  struct RdWrRequest {
    ipc::Pipe* pipe;
    uint8_t* buffer;
    int size;
    // TODO make this a weak_ptr in case it gets deleted?
    proc::ProcContext* proc;
    int* size_writeback;
  };

  stdj::Array<ipc::Pipe*> pipes_;
  stdj::Buffer<uint8_t> buffer_;

  proc::BlockedQueue write_blocked_queue_;
  stdj::Queue<RdWrRequest> write_request_queue_;

  proc::BlockedQueue read_blocked_queue_;
  stdj::Queue<RdWrRequest> read_request_queue_;
};

#endif  // BUFFER_FILE_H_
