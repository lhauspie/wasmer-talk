#include "fibo.h"
#include <stdio.h>
#include <inttypes.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  int n = atoi(argv[1]);
  printf("F(%d) = %" PRIu32 "\n", n, fibo(n));
  return 0;
}
