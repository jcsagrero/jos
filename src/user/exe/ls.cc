#include "jos.h"

#include "stdio.h"
#include "unistd.h"

int main(int argc, char** argv) {
  printf("ls argc: %d\n", argc);
  for (int i = 0; i < argc; i++) {
    printf("ls argv[%d] (%p): \"%s\"\n", i, argv[i], argv[i]);
  }
  exit(0);
}
