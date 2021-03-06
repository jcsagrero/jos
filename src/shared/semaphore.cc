#include "semaphore.h"

#include "syscall.h"

int sem_wait(sem_t* semaphore) {
  SyscallSemaphoreRequest request;
  request.type = SEM_WAIT;
  request.semaphore = semaphore;
  request.status_writeback = -2;
  Syscall(SYSCALL_SEMAPHORE, (uint64_t)&request);
  return request.status_writeback;
}

int sem_post(sem_t* semaphore) {
  SyscallSemaphoreRequest request;
  request.type = SEM_POST;
  request.semaphore = semaphore;
  request.status_writeback = -2;
  Syscall(SYSCALL_SEMAPHORE, (uint64_t)&request);
  return request.status_writeback;
}

void sem_open(sem_t* semaphore, const char* name) {
  memcpy(semaphore->name, name, SEMAPHORE_MAX_NAME_LENGTH);
  semaphore->name[SEMAPHORE_MAX_NAME_LENGTH - 1] = 0;

  SyscallSemaphoreRequest request;
  request.type = SEM_OPEN;
  request.semaphore = semaphore;
  request.status_writeback = -2;
  Syscall(SYSCALL_SEMAPHORE, (uint64_t)&request);
}
