#include "clone_handler.h"

#include "syscall.h"
#include "clone.h"
#include "proc.h"
#include "syscall_handler.h"
#include "page.h"

static void HandleSyscallClone(uint64_t interrupt_number,
                               uint64_t options_ptr,
                               uint64_t param_2,
                               uint64_t param_3) {
  // TODO security this
  SyscallCloneParams* clone_options = (SyscallCloneParams*)options_ptr;
  proc::Clone(clone_options);
}

void InitClone() {
  SetSyscallHandler(SYSCALL_CLONE, HandleSyscallClone);
}
