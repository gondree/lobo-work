/**
 * @file job_parse.c
 * @brief Workload-line parsing implementation.
 */

#define _POSIX_C_SOURCE 200809L

#include "job_parse.h"

#include <string.h>

int
lobo_work_read_job(FILE *input, LoboWorkJob *job)
{
   char line[LOBO_WORK_MAX_LINE];
   char name[LOBO_WORK_MAX_NAME];
   unsigned long duration_ms;
   int fields;

   while (fgets(line, sizeof line, input) != NULL) {
      if (line[0] == '\n' || line[0] == '#')
         continue;

      fields = sscanf(line, "%63s %lu", name, &duration_ms);
      if (fields != 2 || duration_ms > 3600000UL)
         return -1;

      if (strchr(name, '#') != NULL)
         return -1;

      strncpy(job->name, name, sizeof job->name - 1);
      job->name[sizeof job->name - 1] = '\0';
      job->duration_ms = duration_ms;
      return 1;
   }

   if (ferror(input))
      return -1;

   return 0;
}
