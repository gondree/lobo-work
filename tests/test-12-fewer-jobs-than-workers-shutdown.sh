#!/bin/sh
TEST=test-12-fewer-jobs-than-workers-shutdown
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
Workers waiting after a small workload should exit cleanly.

Command:
--------
printf 'only 0\n' | ./lobo_work.x --workers 8 --queue 2
EOF

printf 'only 0\n' | "$PROGRAM" --workers 8 --queue 2 >"$OUT" 2>&1
STATUS=$?
grep -q 'submitted: 1;' "$OUT" || STATUS=1
grep -q 'accepted: 1;' "$OUT" || STATUS=1
grep -q 'rejected: 0;' "$OUT" || STATUS=1
grep -q 'completed: 1;' "$OUT" || STATUS=1
grep -q 'workers: 8;' "$OUT" || STATUS=1
grep -q 'max_active: 1;' "$OUT" || STATUS=1

if test "$STATUS" -eq 0; then
   echo "PASS $TEST"
else
   echo "FAIL $TEST"
   exit 1
fi
