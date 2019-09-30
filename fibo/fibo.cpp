#include <cstdio>
#include <cstdint>

static uint64_t fibo(uint64_t n) {
  if (n <= 1) return 1;
  return fibo(n - 1) + fibo(n - 2);
}

int main() {
  printf("%lu \n", fibo(46));
}

