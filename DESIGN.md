# Lobo Work Design Document

Complete this document with your team. Keep the prompts and write responses
replacing each `@TODO` line.

## Team members:

@TODO


## What each person contributed:

@TODO


## How you coordinated changes and testing:

@TODO


## Module and interface changes

Identify which provided files your team left unchanged. Then identify each
file your team changed and briefly explain why.
If you changed a provided file or public interface, explain the change and its
effect on the rest of the program. Otherwise, state that the provided interfaces
were preserved.

@TODO


## Worker-pool synchronization

List every mutex and condition variable in your implementation. Use the
appropriate format below for each synchronization object, using these notes:

* use the exact variable or field name from your code.
* for "Location," give the source or header filename and, when applicable, the containing struct type and field name.
* for thread-role fields, use only: "main thread", "worker threads", or "both".
* for a condition variable, describe the predicate checked in the corresponding while loop.

For a mutex:

```text
Mutex variable name or struct field:
Location:
Initialized by (thread-role):
Destroyed by (thread-role):
Threads that lock it (thread-role):
Threads that unlock it (thread-role):
Shared state protected:
```

For a condition variable:

```text
Condition-variable name or struct field:
Location:
Initialized by (thread-role):
Destroyed by (thread-role):
Threads that wait on it (thread-role):
Threads that signal or broadcast it (thread-role):
Associated mutex:
Condition being waited for:
```

@TODO


## Worker-loop summary

Describe the worker loop in a few paragraphs or a short fenced pseudocode block.
Address only the important implementation decisions:

* what a worker does when no job is available;
* how it obtains a job safely;
* when it releases the mutex;
* when it calls the job runner;
* when it updates active and completed counts; and
* how it exits during pool closure, including what tells it that no more jobs
  will arrive and whether it finishes queued jobs before returning.

Do not restate the assignment requirements. Describe how your code implements
them.

@TODO


## Testing

Describe the three student tests you wrote, using this format:

```text
Test:
Purpose:
Command:
Expected result:
Observed result:
Failure this test would reveal:
```

For each test, explain why it adds meaningful coverage beyond the supplied tests.

### `student-test-1-work.sh`

@TODO


### `student-test-2-concurrency-or-stress.sh`

@TODO


### `student-test-3-shutdown-or-parsing-or-statistics.sh`

@TODO


## Additional design decisions

Use this section only for decisions that are not already specified by the
assignment or represented in the synchronization inventory.

@TODO
