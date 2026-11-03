/**
 * @file lobo_work.h
 * @brief Shared constants and job types for the LoboWork project.
 */

#ifndef LOBO_WORK_H
#define LOBO_WORK_H

#define LOBO_WORK_DEFAULT_WORKERS 4
#define LOBO_WORK_DEFAULT_QUEUE 8
#define LOBO_WORK_MAX_LINE 256
#define LOBO_WORK_MAX_NAME 64

typedef struct {
   char name[LOBO_WORK_MAX_NAME];
   unsigned long duration_ms;
} LoboWorkJob;

#endif
