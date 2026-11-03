#!/bin/sh
TEST=test-8-short-options-cli
OUTPUT=$(realpath "$(dirname "$0")")/output
OUT=$OUTPUT/$TEST.out
LOG=$OUTPUT/$TEST.log
PROGRAM=${PROGRAM:-./lobo_work.x}

test "tests" = "$(basename "$(dirname "$(realpath "$0")")")" || { echo "FAIL: $0 not in 'tests'"; exit 1; }
test -x "$PROGRAM" || { echo "FAIL: $PROGRAM must exist and be executable"; exit 2; }
mkdir -p "$OUTPUT"
rm -f "$OUT"

cat >"$LOG" <<'EOF'
Description:
------------
The short command-line options should configure the pool.

Command:
--------
printf 'one 0\ntwo 0\n' | ./lobo_work.x -w 2 -q 1
EOF

printf 'one 0\ntwo 0\n' | "$PROGRAM" -w 2 -q 1 >"$OUT" 2>&1
STATUS=$?
grep -q 'submitted: 2;' "$OUT" || STATUS=1
grep -q 'accepted: 2;' "$OUT" || STATUS=1
grep -q 'rejected: 0;' "$OUT" || STATUS=1
grep -q 'completed: 2;' "$OUT" || STATUS=1
grep -q 'workers: 2;' "$OUT" || STATUS=1
grep -q 'queue_capacity: 1;' "$OUT" || STATUS=1

if test "$STATUS" -eq 0; then
   echo "PASS $TEST"
else
   echo "FAIL $TEST"
   exit 1
fi
