/**
 * @file job_parse.h
 * @brief Workload-line parsing interface.
 */

#ifndef JOB_PARSE_H
#define JOB_PARSE_H

#include <stdio.h>

#include "lobo_work.h"

/**
 * Read the next job from a workload stream.
 *
 * @param input input stream containing workload lines.
 * @param job destination for the parsed job.
 * @return 1 for a job, 0 at end of file, or -1 for a malformed line.
 */
int lobo_work_read_job(FILE *input, LoboWorkJob *job);

#endif
