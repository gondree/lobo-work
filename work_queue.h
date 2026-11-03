/**
 * @file work_queue.h
 * @brief Bounded FIFO queue interface.
 */

#ifndef WORK_QUEUE_H
#define WORK_QUEUE_H

#include <stddef.h>

#include "lobo_work.h"

typedef struct {
   LoboWorkJob *items;
   size_t capacity;
   size_t head;
   size_t tail;
   size_t count;
} LoboWorkQueue;

/**
 * Initialize a bounded FIFO queue.
 *
 * @param queue queue object to initialize.
 * @param capacity maximum number of jobs the queue can hold.
 * @return nonzero on success, or 0 if initialization fails.
 */
int lobo_work_queue_init(LoboWorkQueue *queue, size_t capacity);

/**
 * Destroy a queue and release its storage.
 *
 * @param queue queue to destroy. It must not be accessed afterward until it
 * is initialized again.
 */
void lobo_work_queue_destroy(LoboWorkQueue *queue);

/**
 * Attempt to append one job to the queue.
 *
 * This operation returns immediately if the queue is full. It does not perform
 * synchronization; a caller sharing the queue between threads must provide
 * the required synchronization.
 *
 * @param queue queue to modify.
 * @param job job to copy into the queue.
 * @return nonzero if the job was added, or 0 if the queue was full.
 */
int lobo_work_queue_try_add(LoboWorkQueue *queue, const LoboWorkJob *job);

/**
 * Attempt to remove the oldest job from the queue.
 *
 * This operation returns immediately if the queue is empty. It does not
 * perform synchronization; a caller sharing the queue between threads must
 * provide the required synchronization.
 *
 * @param queue queue to modify.
 * @param job destination for the removed job.
 * @return nonzero if a job was removed, or 0 if the queue was empty.
 */
int lobo_work_queue_pop(LoboWorkQueue *queue, LoboWorkJob *job);

#endif
