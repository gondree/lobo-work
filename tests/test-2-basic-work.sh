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
Three valid jobs should all be accepted and completed.

Command:
--------
printf 'alpha 0\nbeta 0\ngamma 0\n' | ./lobo_work.x --workers 2 --queue 2
EOF

printf 'alpha 0\nbeta 0\ngamma 0\n' |
   "$PROGRAM" --workers 2 --queue 2 >"$OUT" 2>&1

STATUS=0
grep -q 'submitted: 3;' "$OUT" || STATUS=1
grep -q 'accepted: 3;' "$OUT" || STATUS=1
grep -q 'rejected: 0;' "$OUT" || STATUS=1
grep -q 'completed: 3;' "$OUT" || STATUS=1
grep -q 'workers: 2;' "$OUT" || STATUS=1
grep -q 'queue_capacity: 2;' "$OUT" || STATUS=1

if test "$STATUS" -eq 0; then
   echo "PASS $TEST"
else
   echo "FAIL $TEST"
   exit 1
fi

