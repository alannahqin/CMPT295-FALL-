
#define _POSIX_C_SOURCE 199309L
#include <algorithm>
#include <cassert>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define DATA_T double
#define DATA_PRINTF "%g"
#define RAND_EXPR ((double)rand() / RAND_MAX - 0.5)

enum array_ordering { RANDOM, SORTED, REVERSE_SORTED, ALMOST_SORTED };

void gently_shuffle_array(DATA_T *array, uint64_t length) {
  uint64_t limit = 10;
  for (uint64_t i = 0; i + limit + 1 < length; i++) {
    uint64_t offset = rand() % limit;
    DATA_T tmp = array[i + offset];
    array[i + offset] = array[i];
    array[i] = tmp;
  }
}

DATA_T *create_array(uint64_t length, array_ordering order) {
  DATA_T *array = (DATA_T *)malloc(length * sizeof(DATA_T));
  if (array == NULL) {
    return NULL;
  }

  for (uint64_t i = 0; i < length; i++) {
    array[i] = RAND_EXPR;
  }

  switch (order) {
  case RANDOM:
    break;
  case SORTED:
    std::sort(array, array + length);
    break;
  case ALMOST_SORTED:
    std::sort(array, array + length);
    gently_shuffle_array(array, length);
    break;
  case REVERSE_SORTED:
    std::sort(array, array + length);
    std::reverse(array, array + length);
    break;
  }
  return array;
}

int data_cmp(const void *a, const void *b) {
  DATA_T arg1 = *(const DATA_T *)a;
  DATA_T arg2 = *(const DATA_T *)b;
  if (arg1 < arg2)
    return -1;
  if (arg1 > arg2)
    return 1;
  return 0;
}

void stdlib_qsort(DATA_T *array, uint64_t length) {
  qsort(array, length, sizeof(DATA_T), data_cmp);
}

void std_sort(DATA_T *array, uint64_t length) { std::sort(array, array + length); }

// bubble sort
void bubble_sort(DATA_T *array, uint64_t length) {
  for (uint64_t i = 0; i + 1 < length; i++) {
    for (uint64_t j = i + 1; j < length; j++) {
      if (array[i] > array[j]) {
        DATA_T temp = array[j];
        array[j] = array[i];
        array[i] = temp;
      }
    }
  }
}

bool is_sorted(DATA_T *array, uint64_t length) {
  for (uint64_t i = 0; i + 1 < length; i++) {
    if (array[i] > array[i + 1]) {
      return false;
    }
  }
  return true;
}

void time_sort(const char *descr, void (*sort)(DATA_T *, uint64_t), uint64_t length,
               array_ordering order) {
  struct timespec start, end;

  DATA_T *array = create_array(length, order);
  if (array == NULL) {
    printf("Couldn't allocate.\n");
    return;
  }

  clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &start);
  sort(array, length);
  clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &end);

  assert(is_sorted(array, length));
  free(array);

  double elapsed = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;

  printf("%25s sorted %8lu values in %7.2f ms\n", descr, length, elapsed * 1000);
}

void time_them(uint64_t length) {
  time_sort("bubble_sort on sorted", bubble_sort, length, SORTED);
  time_sort("bubble_sort on reverse", bubble_sort, length, REVERSE_SORTED);
  time_sort("bubble_sort on random", bubble_sort, length, RANDOM);
  time_sort("qsort on random", stdlib_qsort, length, RANDOM);
  time_sort("std::sort on random", std_sort, length, RANDOM);
}

void just_sort(void (*sort)(DATA_T *, uint64_t), uint64_t length, array_ordering order) {
  DATA_T *array = create_array(length, order);

  if (array == NULL) {
    printf("Couldn't allocate.\n");
    return;
  }

  sort(array, length);
  assert(is_sorted(array, length));
  free(array);
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    printf("Must give array size on command line.\n");
    return 1;
  }

  uint64_t length = atol(argv[1]);

  printf("Array size: %lu kB\n", length * sizeof(DATA_T) / 1024);

  just_sort(bubble_sort, length, RANDOM);

  return 0;
}
