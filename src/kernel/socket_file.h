#ifndef KERNEL_SOCKET_FILE_H_
#define KERNEL_SOCKET_FILE_H_

#include "ipc.h"
#include "proc.h"
#include "jarray.h"
#include "jbuffer.h"

class SocketFile : public ipc::File {
 public:
  SocketFile();

  ipc::Pipe* Open(ipc::Mode mode) override;
  int Close(ipc::Pipe* pipe) override;
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
  stdj::Array<ipc::Pipe*> pipes_;
};

class SocketPipe : public ipc::Pipe {
 public:
  SocketPipe(ipc::File* file, ipc::Mode mode);
};

#endif  // KERNEL_SOCKET_FILE_H_