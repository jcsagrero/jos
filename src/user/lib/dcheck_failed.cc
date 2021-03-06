#include "dcheck.h"

#include "stdio.h"
#include "getc.h"
#include "vprintf.h"

void DCHECKFailed(const char* file, int line, const char* condition) {
  printu("%s:%d DCHECK failed: %s\n", file, line, condition);
}

void DCHECKFailedMessage(const char* condition, const char* format, ...) {
  printu("DCHECK failed: %s\n  ", condition);

  // TODO why is this calling vprint directly?
  va_list list;
  va_start(list, format);
  vprintf(format, list, Putc, Puts);
  va_end(list);

  printu("\n");
}
