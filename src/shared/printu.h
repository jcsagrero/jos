#ifndef PRINTU_H_
#define PRINTU_H_

#include <stdarg.h>

int printu(const char* fmt, ...) __attribute__ ((format (printf, 1, 2)));

#endif  // PRINTU_H_
