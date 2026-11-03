#!/bin/sh
TEST=test-13-queue-capacity-one-stress
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
Many jobs should complete with a queue capacity of one.

Command:
--------
{ for i in 1 2 3 4 5 6 7 8 9 10 11 12; do printf 'job%s 2\n' "$i"; done; } | ./lobo_work.x --workers 3 --queue 1
EOF

{ for i in 1 2 3 4 5 6 7 8 9 10 11 12; do printf 'job%s 2\n' "$i"; done; } | "$PROGRAM" --workers 3 --queue 1 >"$OUT" 2>&1
STATUS=$?
grep -q 'submitted: 12;' "$OUT" || STATUS=1
grep -q 'accepted: 12;' "$OUT" || STATUS=1
grep -q 'rejected: 0;' "$OUT" || STATUS=1
grep -q 'completed: 12;' "$OUT" || STATUS=1
grep -q 'queue_capacity: 1;' "$OUT" || STATUS=1

if test "$STATUS" -eq 0; then
   echo "PASS $TEST"
else
   echo "FAIL $TEST"
   exit 1
fi
