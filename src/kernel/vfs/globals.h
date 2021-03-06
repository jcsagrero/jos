#ifndef KERNEL_VFS_GLOBALS_H_
#define KERNEL_VFS_GLOBALS_H_

#include "inode.h"

namespace vfs {

Inode* GetRootDirectory();
void SetRootDirectory(Inode* root_directory);

}  // namespace vfs

#endif  // KERNEL_VFS_GLOBALS_H_
