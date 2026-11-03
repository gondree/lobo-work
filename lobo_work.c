/**
 * @file lobo_work.c
 * @brief Student driver for the serial-first LoboWork project.
 */

#define _POSIX_C_SOURCE 200809L

#include "lobo_work.h"
#include "job_parse.h"
#include "work_pool.h"

#include <errno.h>
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

/**
 * Execute one simulated job by sleeping for its requested duration.
 *
 * This implementation is provided as stable support code. It preserves the
 * workload model used by the project and should not be changed. The worker
 * pool should call it through the LoboWorkRunner callback interface.
 *
 * @param job job whose duration determines how long to sleep.
 */
static void
run_job(const LoboWorkJob *job)
{
   struct timespec duration = {
      .tv_sec = (time_t) (job->duration_ms / 1000),
      .tv_nsec = (long) (job->duration_ms % 1000) * 1000000L
   };

   while (nanosleep(&duration, &duration) < 0 && errno == EINTR) {
      /* Preserve the requested duration across signal interruptions. */
   }
}

static void
print_help(const char *program_name)
{
   printf("Usage: %s [OPTIONS] < workload.txt\n\n", program_name);
   printf("Read jobs into a bounded queue and run them serially.\n\n");
   printf("Options:\n");
   printf("  -w, --workers N  worker count\n");
   printf("  -q, --queue N    queue capacity (default: %d)\n",
          LOBO_WORK_DEFAULT_QUEUE);
   printf("  -h, --help       show this help message\n");
}

static int
parse_positive(const char *text, const char *option)
{
   char *end;
   long value = strtol(text, &end, 10);

   if (*text == '\0' || *end != '\0' || value <= 0 || value > 10000) {
      fprintf(stderr, "error: invalid %s value '%s'\n", option, text);
      exit(EXIT_FAILURE);
   }

   return (int) value;
}

int
main(int argc, char **argv)
{
   int worker_count = 1;
   int queue_capacity = LOBO_WORK_DEFAULT_QUEUE;
   static struct option options[] = {
      {"workers", required_argument, NULL, 'w'},
      {"queue", required_argument, NULL, 'q'},
      {"help", no_argument, NULL, 'h'},
      {NULL, 0, NULL, 0}
   };
   int option;

   while ((option = getopt_long(argc, argv, "w:q:h", options, NULL)) != -1) {
      if (option == 'w')
         worker_count = parse_positive(optarg, "workers");
      else if (option == 'q')
         queue_capacity = parse_positive(optarg, "queue");
      else {
         print_help(argv[0]);
         return option == 'h' ? EXIT_SUCCESS : EXIT_FAILURE;
      }
   }

   (void) worker_count;
   LoboWorkPool *pool = lobo_work_pool_create(
      1, queue_capacity, run_job);
   if (pool == NULL) {
      perror("lobo_work_pool_create");
      return EXIT_FAILURE;
   }

   LoboWorkJob job;
   int result;
   unsigned long submitted = 0;
   while ((result = lobo_work_read_job(stdin, &job)) > 0) {
      submitted++;
      lobo_work_pool_add(pool, &job);
   }

   if (result < 0)
      fprintf(stderr, "error: malformed workload line\n");

   lobo_work_pool_close(pool);
   LoboWorkPoolStats stats;
   lobo_work_pool_get_stats(pool, &stats);
   printf("submitted: %lu; accepted: %lu; rejected: %lu; "
          "completed: %lu; workers: 1; queue_capacity: %d; "
          "max_active: %lu;\n",
          submitted, stats.accepted, stats.rejected, stats.completed,
          queue_capacity, stats.max_active);
   lobo_work_pool_destroy(pool);
   return result < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
}
