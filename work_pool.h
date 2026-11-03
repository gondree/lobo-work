/**
 * @file work_pool.h
 * @brief Fixed worker-pool interface.
 */

#ifndef WORK_POOL_H
#define WORK_POOL_H

#include "lobo_work.h"

typedef struct LoboWorkPool LoboWorkPool;

/**
 * Function used by a worker to execute one job.
 *
 * @param job job to execute.
 */
typedef void (*LoboWorkRunner)(const LoboWorkJob *job);

typedef struct {
   unsigned long accepted;
   unsigned long rejected;
   unsigned long completed;
   unsigned long max_active;
} LoboWorkPoolStats;

/**
 * Create a fixed-size worker pool.
 *
 * @param worker_count number of workers to create.
 * @param queue_capacity maximum number of waiting jobs.
 * @param runner function each worker calls to execute a job.
 * @return a new pool, or NULL if creation fails.
 */
LoboWorkPool *lobo_work_pool_create(int worker_count,
                                    int queue_capacity,
                                    LoboWorkRunner runner);

/**
 * Submit one job to the pool, waiting when the bounded queue is full.
 *
 * @param pool pool receiving the job.
 * @param job job to copy into the pool queue.
 * @return nonzero if the job was accepted, or 0 if the pool is closed.
 */
int lobo_work_pool_add(LoboWorkPool *pool, const LoboWorkJob *job);

/**
 * Close the pool to new work and wait for accepted work to finish.
 *
 * @param pool pool to close. Queued jobs are completed before this call
 * returns, and all workers are joined.
 */
void lobo_work_pool_close(LoboWorkPool *pool);

/**
 * Copy a synchronized snapshot of the pool statistics.
 *
 * @param pool pool whose statistics should be copied.
 * @param stats destination for the snapshot.
 */
void lobo_work_pool_get_stats(LoboWorkPool *pool, LoboWorkPoolStats *stats);

/**
 * Release all resources owned by a pool.
 *
 * @param pool pool to destroy. The pool must already have been closed.
 */
void lobo_work_pool_destroy(LoboWorkPool *pool);

#endif
