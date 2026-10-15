#include <stdint.h>

int64_t warmup(int64_t n) {
  // an uninteresting function to use as warmup work, to force the processor out of
  // a low-power state before doing stuff we care about
  return n + 1;
}

int64_t polynomial3(int64_t x, int64_t a, int64_t b, int64_t c, int64_t d) {
  return a * x * x * x + b * x * x + c * x + d;
}

uint64_t is_odd3(uint64_t n) { return n % 2; }

uint64_t mul3(uint64_t n) { return 65537 * n; }
