#!/bin/sh
TEST=test-9-malformed-input-parsing
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
A malformed line should produce an error without losing earlier valid work.

Command:
--------
{ printf '# comment\n\nvalid 0\nmalformed\n'; } | ./lobo_work.x -w 2 -q 2
EOF

{ printf '# comment\n\nvalid 0\nmalformed\n'; } | "$PROGRAM" -w 2 -q 2 >"$OUT" 2>&1
STATUS=$?
test "$STATUS" -ne 0 || STATUS=1
grep -q 'malformed workload line' "$OUT" || STATUS=1
grep -q 'submitted: 1;' "$OUT" || STATUS=1
grep -q 'accepted: 1;' "$OUT" || STATUS=1
grep -q 'rejected: 0;' "$OUT" || STATUS=1
grep -q 'completed: 1;' "$OUT" || STATUS=1

if test "$STATUS" -eq 0; then
   echo "PASS $TEST"
else
   echo "FAIL $TEST"
   exit 1
fi
