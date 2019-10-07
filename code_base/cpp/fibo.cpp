#include "fibo.h"

uint32_t fibo(uint32_t n) {
  if (n <= 1) return 1;
  return fibo(n - 1) + fibo(n - 2);
}
