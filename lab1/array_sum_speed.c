// Get modern behaviour out of time.h, per https://stackoverflow.com/a/40515669
#define _POSIX_C_SOURCE 199309L
#include "array_sum.h"
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char *argv[]) {
  // Get array size from command line
  if (argc < 2) {
    printf("Must give integer on command line for array size.\n");
    return 2;
  }
  int32_t n = atoi(argv[1]);
  struct timespec start, end;

  // Create and fill array.
  // Uses rand() unseeded, unless next line is un-commented.
  // srand(time(NULL));
  int32_t *arr = malloc(n * sizeof(int32_t));
  if (arr == NULL) {
    printf("Can't allocate memory.\n");
    return 1;
  }
  for (int i = 0; i < n; i++) {
    arr[i] = rand() % 10;
  }

  // Sum array values several times, timing each one.
  int32_t total;
  for (int i = 0; i < 10; i++) {
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start);
    total = array_sum(arr, n);
    clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);
    double elapsed = (end.tv_sec - start.tv_sec) * 1e3 + (end.tv_nsec - start.tv_nsec) / 1e6;
    printf("calculated %d in %g ms\n", total, elapsed);
  }
  free(arr);

  return 0;
}
