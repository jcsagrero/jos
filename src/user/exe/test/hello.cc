#include "jos.h"

#include "stdio.h"
#include "unistd.h"

int main() {
  printf("hello from hello.cc\n");
  printf("hello.cc calling exit()...\n");
  exit();
  return 0;
}
