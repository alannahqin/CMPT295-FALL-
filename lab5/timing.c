// Get modern behaviour out of time.h, per https://stackoverflow.com/a/40515669
#define _POSIX_C_SOURCE 199309L
#include "lab5.h"
#include <stdint.h>
#include <stdio.h>
#include <time.h>

#define REPS 20000000

#define CODE_TEST(CODE)                                                                            \
  do {                                                                                             \
    int64_t total = 0;                                                                             \
    elapsed = 0;                                                                                   \
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start);                                               \
    for (int i = 0; i < REPS; i++) {                                                               \
      total += CODE + CODE + CODE + CODE + CODE + CODE + CODE + CODE + CODE + CODE;                \
    }                                                                                              \
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);                                                 \
    elapsed += (end.tv_sec - start.tv_sec) * 1e3 + (end.tv_nsec - start.tv_nsec) / 1e6;            \
    printf("%23s calculated %18ld in %7.1f ms\n", #CODE, total, elapsed - overhead);               \
  } while (0)

int main() {
  double elapsed, overhead = 0;
  struct timespec start, end;

  // Some fibonacci tests to avoid needing another .c program for this lab...
  printf("%ld %ld %ld %ld %ld %ld %ld %ld %ld %ld\n", fibonacci(0), fibonacci(1), fibonacci(2),
         fibonacci(3), fibonacci(4), fibonacci(5), fibonacci(6), fibonacci(7), fibonacci(8),
         fibonacci(9));
  printf("fibonacci(35) == 9227465 == %ld\n", fibonacci(35));

  // Do some meaningless work to wake up the processor (we hope)...
  CODE_TEST(warmup(1));
  CODE_TEST(warmup(2));
  CODE_TEST(warmup(3));
  CODE_TEST(warmup(4));
  CODE_TEST(warmup(5));
  /*
  Count that last run time as the overhead needed to just call the functions
  that many times and do the accounting. Subtract that off subsequent runs, to
  try to approximate the time to run the operations themselves.
  */
  // update: no, things get weird if we do that
  // overhead = elapsed;

  CODE_TEST(polynomial1(3, 2, 7, -1, 2));
  CODE_TEST(polynomial2(3, 2, 7, -1, 2));
  CODE_TEST(polynomial3(3, 2, 7, -1, 2));

  CODE_TEST(is_odd1(7) + is_odd1(8));
  CODE_TEST(is_odd2(7) + is_odd2(8));
  CODE_TEST(is_odd3(7) + is_odd3(8));

  CODE_TEST(mul1(123));
  CODE_TEST(mul2(123));
  CODE_TEST(mul3(123));

  return 0;
}
