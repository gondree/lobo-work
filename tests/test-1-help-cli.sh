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
The help option should describe usage and supported options.

Command:
--------
./lobo_work.x --help
EOF

"$PROGRAM" --help >"$OUT" 2>&1
STATUS=0
grep -q '^Usage:' "$OUT" || STATUS=1
grep -q -- '--workers' "$OUT" || STATUS=1
grep -q -- '--queue' "$OUT" || STATUS=1
grep -q -- '--help' "$OUT" || STATUS=1

if test "$STATUS" -eq 0; then
   echo "PASS $TEST"
else
   echo "FAIL $TEST"
   exit 1
fi

