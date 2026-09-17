#include "array_sum.h"
#include <stdint.h>

int32_t array_sum(int32_t *arr, uint32_t n) {
  int32_t sum = 0;

  for (uint32_t i = 0; i < n; i++) {
    sum += arr[i];
  }

  return sum;
}
