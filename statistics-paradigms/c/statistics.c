#include <stdio.h>
#include <stdlib.h>

static int compare_ints(const void *a, const void *b) {
    const int left = *(const int *)a;
    const int right = *(const int *)b;
    return (left > right) - (left < right);
}

static double calculate_mean(const int values[], size_t count) {
    long long sum = 0;
    for (size_t i = 0; i < count; ++i) sum += values[i];
    return (double)sum / (double)count;
}

static double calculate_median(const int sorted[], size_t count) {
    const size_t middle = count / 2;
    if (count % 2 == 1) return sorted[middle];
    return ((double)sorted[middle - 1] + sorted[middle]) / 2.0;
}

static size_t find_modes(const int sorted[], size_t count, int modes[]) {
    size_t mode_count = 0, maximum_frequency = 0, run_start = 0;
    while (run_start < count) {
        size_t run_end = run_start + 1;
        while (run_end < count && sorted[run_end] == sorted[run_start]) ++run_end;
        const size_t frequency = run_end - run_start;
        if (frequency > maximum_frequency) {
            maximum_frequency = frequency;
            mode_count = 0;
        }
        if (frequency == maximum_frequency) modes[mode_count++] = sorted[run_start];
        run_start = run_end;
    }
    return mode_count;
}

int main(void) {
    int values[] = {4, 1, 2, 2, 3, 4, 4, 5};
    const size_t count = sizeof values / sizeof values[0];
    int *sorted = malloc(count * sizeof *sorted);
    int *modes = malloc(count * sizeof *modes);
    if (sorted == NULL || modes == NULL) {
        fprintf(stderr, "Unable to allocate memory.\n");
        free(sorted); free(modes);
        return EXIT_FAILURE;
    }
    for (size_t i = 0; i < count; ++i) sorted[i] = values[i];
    qsort(sorted, count, sizeof *sorted, compare_ints);
    const size_t mode_count = find_modes(sorted, count, modes);
    printf("Data: 4 1 2 2 3 4 4 5\nMean: %.2f\nMedian: %.2f\nMode(s):",
           calculate_mean(values, count), calculate_median(sorted, count));
    for (size_t i = 0; i < mode_count; ++i) printf(" %d", modes[i]);
    putchar('\n');
    free(modes); free(sorted);
    return EXIT_SUCCESS;
}
