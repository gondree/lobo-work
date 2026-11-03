#!/bin/sh
TEST=test-11-empty-input-shutdown
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
Empty input should close the pool cleanly and report no work.

Command:
--------
printf '' | ./lobo_work.x --workers 4 --queue 2
EOF

printf '' | "$PROGRAM" --workers 4 --queue 2 >"$OUT" 2>&1
STATUS=$?
grep -q 'submitted: 0;' "$OUT" || STATUS=1
grep -q 'accepted: 0;' "$OUT" || STATUS=1
grep -q 'rejected: 0;' "$OUT" || STATUS=1
grep -q 'completed: 0;' "$OUT" || STATUS=1
grep -q 'workers: 4;' "$OUT" || STATUS=1
grep -q 'queue_capacity: 2;' "$OUT" || STATUS=1
grep -q 'max_active: 0;' "$OUT" || STATUS=1

if test "$STATUS" -eq 0; then
   echo "PASS $TEST"
else
   echo "FAIL $TEST"
   exit 1
fi
