
#define _POSIX_C_SOURCE 199309L
#include "lab10.h"
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void sin_stdlib(double *input, double *output, uint64_t length) {
  for (uint64_t i = 0; i < length; i++) {
    output[i] = sin(input[i]);
  }
}

static double measure(void (*func)(double *, double *, uint64_t), double *input, double *output,
                      uint64_t length) {
  struct timespec start, end;
  clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start);
  func(input, output, length);
  clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);
  return (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_nsec - start.tv_nsec) / 1000000.0;
}

int main(void) {
  uint64_t length = 2000000;
  double *input = malloc(length * sizeof(double));
  double *out_x87 = malloc(length * sizeof(double));
  double *out_c = malloc(length * sizeof(double));

  if (input == NULL || out_x87 == NULL || out_c == NULL) {
    printf("could not allocate arrays\n");
    free(input);
    free(out_x87);
    free(out_c);
    return 1;
  }

  for (uint64_t i = 0; i < length; i++) {
    input[i] = -3.0 + 6.0 * (double)i / (double)length;
  }

  double x87_ms = measure(sin_x87, input, out_x87, length);
  double c_ms = measure(sin_stdlib, input, out_c, length);

  double max_diff = 0.0;
  for (uint64_t i = 0; i < length; i++) {
    double diff = fabs(out_x87[i] - out_c[i]);
    if (diff > max_diff) {
      max_diff = diff;
    }
  }

  printf("sin_x87:    %.2f ms\n", x87_ms);
  printf("sin_stdlib: %.2f ms\n", c_ms);
  printf("x87 / C:    %.2fx\n", x87_ms / c_ms);
  printf("max difference: %.12g\n", max_diff);

  free(input);
  free(out_x87);
  free(out_c);
  return 0;
}
