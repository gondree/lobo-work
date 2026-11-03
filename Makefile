CC ?= cc
CPPFLAGS ?=
CFLAGS ?= -std=c11 -Wall -Wextra -Wpedantic -O2
LDFLAGS ?= -pthread

PROGRAM = lobo_work.x
SOURCES = lobo_work.c work_pool.c work_queue.c job_parse.c
OBJECTS = $(SOURCES:.c=.o)
TESTS = $(wildcard tests/*.sh)

all: $(PROGRAM)

$(PROGRAM): $(OBJECTS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<

check: $(PROGRAM)
	mkdir -p tests/output
	@set -e; for t in $(TESTS); do sh $$t; done

clean:
	rm -f $(PROGRAM) $(OBJECTS)

.PHONY: all check clean
