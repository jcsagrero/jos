#ifndef PROC_H_
#define PROC_H_

#include "stdint.h"
#include "page.h"
#include "elf.h"
#include "stdint.h"
#include "kernel/ipc.h"
#include "semaphore_handler.h"
#include "kernel/vfs/filepath.h"
#include "shared/jmap.h"
#include "shared/clone.h"
#include "shared/jqueue.h"
#include "syscall.h"

#define MAX_FDS 4096

namespace proc {

typedef stdj::Map<int, ipc::Pipe*, ((ipc::Pipe*)0)> FdMap;

class ProcContext;
struct ZombieContext {
  ProcContext* proc;
  int exit_status;
};

class ProcContext {
 public:
  // hardware context
  // TODO add floating point state
  uint64_t rax;
  uint64_t rbx;
  uint64_t rcx;
  uint64_t rdx;
  uint64_t rdi;
  uint64_t rsi;
  uint64_t r8;
  uint64_t r9;
  uint64_t r10;
  uint64_t r11;
  uint64_t r12;
  uint64_t r13;
  uint64_t r14;
  uint64_t r15;
  uint64_t rbp;
  uint64_t rsp;     // interrupt stack frame rsp+24
  uint64_t rip;     // interrupt stack frame rsp+0
  uint64_t rflags;  // interrupt stack frame rsp+16
  // TODO should _s registers be uint16_t instead?
  //      with endianness i feel like they might not work correctly
  uint64_t cs;  // interrupt stack frame rsp+8
  uint64_t ss;  // interrupt stack frame rsp+32
  // can i ignore these segment registers? what are they even for? how do i
  // access them?
  uint64_t ds;
  uint64_t es;
  uint64_t fs;
  uint64_t gs;

  uint64_t cr3;

  // software context
  int is_blocked;
  uint64_t pid;
  uint64_t bottom_of_stack;

  FdMap fd_map_;
  SemaphoreMap open_semaphores_;

  void PrintValues();
  int GetNewFd();

  vfs::Filepath working_directory_;

  // wait() state
  ProcContext* parent;
  stdj::Array<ZombieContext> zombie_queue;
  BlockedQueue* wait_for_zombie = 0;
  SyscallWaitParams* wait_params = 0;
};

void Init();  // initializes proc system, only call once

void Run();  // starts threading system, runs all threads to completion and
             // returns

typedef void (*KthreadFunction)(void*);
ProcContext* CreateKthread(KthreadFunction entry_point, void* arg);

void Reschedule();
void Yield();
void YieldNoNesting();
void Exit();
bool IsRunning();  // returns 1 if threading system is running, else 0

ProcContext* Clone(SyscallCloneParams* clone_options);

class BlockedQueue {
 public:
  BlockedQueue();
  ~BlockedQueue();

  // Unblocks one process from the ProcQueue,
  // moving it back to the scheduler.
  // Called by interrupt handler?
  // Returns unblocked proc
  ProcContext* UnblockHead();

  // Unblocks all processes from the ProcQueue,
  // moving them all back to the scheduler.
  // Called by interrupt handler?
  void UnblockAll();

  // Blocks the current process.
  // Called by system call handler.
  // void ProcBlockOn(struct ProcQueue* queue, int enable_ints);
  void BlockCurrentProcNoNesting();

  int Size();

 private:
  stdj::Queue<ProcContext*> queue_;
};

// TODO shouldn't these be private?
uint64_t* GetStackSaveState();
void RestoreState(ProcContext* proc);
void SaveState(ProcContext* proc);

void Print();
bool IsKernel();

// Loads a program from memory to replace the current process's program
void ExecProc(proc::ProcContext* proc,
              ELFInfo elf_info,
              uint8_t* file_data,
              char** argv);

uint64_t GetCurrentPid();

// Loads register values put on stack by irq_syscall
// This is called once every time an interrupt happens
void SaveStateToCurrentProc();

// Returns new fd allocated for current proc
int AddPipeToProc(ProcContext* proc, ipc::Pipe* pipe);

ipc::Pipe* GetPipeForFdFromCurrentProc(int fd);

ProcContext* GetCurrentProc();

// switches procs for preemptive multitasking
void PreemptProc();

// required for new blocking
void EndOfSyscallReschedule();

void TryFinishWaiting(ProcContext* proc);

}  // namespace proc

#endif  // PROC_H_
