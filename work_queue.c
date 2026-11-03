/**
 * @file work_queue.c
 * @brief Non-locking bounded FIFO queue implementation.
 */

#include "work_queue.h"

#include <stdlib.h>

int
lobo_work_queue_init(LoboWorkQueue *queue, size_t capacity)
{
   queue->items = calloc(capacity, sizeof *queue->items);
   if (queue->items == NULL)
      return 0;

   queue->capacity = capacity;
   queue->head = 0;
   queue->tail = 0;
   queue->count = 0;
   return 1;
}

void
lobo_work_queue_destroy(LoboWorkQueue *queue)
{
   free(queue->items);
   queue->items = NULL;
   queue->capacity = 0;
   queue->head = 0;
   queue->tail = 0;
   queue->count = 0;
}

int
lobo_work_queue_try_add(LoboWorkQueue *queue, const LoboWorkJob *job)
{
   if (queue->count == queue->capacity)
      return 0;

   queue->items[queue->tail] = *job;
   queue->tail = (queue->tail + 1) % queue->capacity;
   queue->count++;
   return 1;
}

int
lobo_work_queue_pop(LoboWorkQueue *queue, LoboWorkJob *job)
{
   if (queue->count == 0)
      return 0;

   *job = queue->items[queue->head];
   queue->head = (queue->head + 1) % queue->capacity;
   queue->count--;
   return 1;
}
