#!/bin/sh
TEST=test-10-invariants-statistics
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
The final statistics should satisfy the required counter invariants.

Command:
--------
{ for i in 1 2 3 4 5 6 7 8; do printf 'job%s 5\n' "$i"; done; } | ./lobo_work.x --workers 3 --queue 2
EOF

{
   for i in 1 2 3 4 5 6 7 8; do
      printf 'job%s 5\n' "$i"
   done
} | "$PROGRAM" --workers 3 --queue 2 >"$OUT" 2>&1
STATUS=$?
grep -q 'submitted: 8;' "$OUT" || STATUS=1
grep -q 'accepted: 8;' "$OUT" || STATUS=1
grep -q 'rejected: 0;' "$OUT" || STATUS=1
grep -q 'completed: 8;' "$OUT" || STATUS=1
MAX_ACTIVE=$(sed -n 's/.*max_active: \([0-9][0-9]*\).*/\1/p' "$OUT")
test -n "$MAX_ACTIVE" || STATUS=1
test "$MAX_ACTIVE" -le 3 2>/dev/null || STATUS=1

if test "$STATUS" -eq 0; then
   echo "PASS $TEST"
else
   echo "FAIL $TEST"
   exit 1
fi
