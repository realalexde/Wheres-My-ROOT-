#!/system/bin/sh

TOTAL=0
PASSED=0
FAILED=0
COMPROMISED=0

pass() {
  echo "[+] PASS: $1"
  PASSED=$((PASSED+1))
  TOTAL=$((TOTAL+1))
}

fail() {
  echo "[!] FAIL: $1"
  FAILED=$((FAILED+1))
  TOTAL=$((TOTAL+1))
  COMPROMISED=1
}

run_check() {
  NAME="$1"
  shift
  "$@" && pass "$NAME" || fail "$NAME"
}

echo "== Where's my ROOT?? :: Android Root / Integrity Check =="
echo

# --- CHECKS ---
run_check "Shell not root (uid!=0)" sh -c '! id | grep -q "uid=0"'
run_check "Bootloader locked" sh -c 'getprop ro.boot.vbmeta.device_state | grep -q locked'
run_check "Verified Boot GREEN" sh -c 'getprop ro.boot.verifiedbootstate | grep -q green'
run_check "/system mounted ro" sh -c '! mount | grep " /system " | grep -q rw'
run_check "ro.secure=1" sh -c 'getprop ro.secure | grep -q 1'
run_check "ro.debuggable=0" sh -c 'getprop ro.debuggable | grep -q 0'
run_check "Build type user" sh -c 'getprop ro.build.type | grep -q user'
run_check "SELinux enforcing" sh -c 'getenforce | grep -q Enforcing'

# --- OPTIONAL Play Integrity hook ---
[ -f /data/local/tmp/wmroot_integrity.ok ] && \
  run_check "Play Integrity DEVICE/STRONG" true || \
  run_check "Play Integrity DEVICE/STRONG" false

echo
echo "== RESULT =="

echo "Checks total : $TOTAL"
echo "Passed       : $PASSED"
echo "Failed       : $FAILED"

# вероятность (информативно)
PROB=$((FAILED * 100 / TOTAL))
echo "Root probability: ${PROB}%"

echo
if [ $COMPROMISED -eq 1 ]; then
  echo "❌ DEVICE STATUS: COMPROMISED"
else
  echo "✅ DEVICE STATUS: NO EVIDENCE OF ROOT"
fi
