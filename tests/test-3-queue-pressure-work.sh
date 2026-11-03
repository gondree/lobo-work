TEST=$(basename "${0%.sh}")
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
Submission must wait when a bounded queue is full. No valid job should be
rejected under queue pressure.

Command:
--------
cat sample_jobs/queue-pressure.txt | ./lobo_work.x --workers 2 --queue 2
EOF

"$PROGRAM" --workers 2 --queue 2 < sample_jobs/queue-pressure.txt >"$OUT" 2>&1

STATUS=0
grep -q 'submitted: 12;' "$OUT" || STATUS=1
grep -q 'accepted: 12;' "$OUT" || STATUS=1
grep -q 'rejected: 0;' "$OUT" || STATUS=1
grep -q 'completed: 12;' "$OUT" || STATUS=1
grep -q 'workers: 2;' "$OUT" || STATUS=1
grep -q 'queue_capacity: 2;' "$OUT" || STATUS=1

if test "$STATUS" -eq 0; then
   echo "PASS $TEST"
else
   echo "FAIL $TEST"
   exit 1
fi

