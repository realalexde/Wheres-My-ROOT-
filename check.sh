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

echo "== Where's my ROOT?? :: Advanced Android Root / Integrity Check v2.0 =="
echo

# --- CORE SYSTEM CHECKS ---
run_check "Shell not root (uid!=0)" sh -c '! id | grep -q "uid=0"'
run_check "Bootloader locked" sh -c 'getprop ro.boot.vbmeta.device_state | grep -q locked'
run_check "Verified Boot GREEN" sh -c 'getprop ro.boot.verifiedbootstate | grep -q green'
run_check "/system mounted ro" sh -c '! mount | grep " /system " | grep -q rw'
run_check "/vendor mounted ro" sh -c '! mount | grep " /vendor " | grep -q rw'
run_check "ro.secure=1" sh -c 'getprop ro.secure | grep -q 1'
run_check "ro.debuggable=0" sh -c 'getprop ro.debuggable | grep -q 0'
run_check "Build type user" sh -c 'getprop ro.build.type | grep -q user'
run_check "Build tags release-keys" sh -c 'getprop ro.build.tags | grep -q release-keys'
run_check "SELinux enforcing" sh -c 'getenforce | grep -q Enforcing'

# --- ROOT BINARY CHECKS ---
run_check "No su in PATH" sh -c '! command -v su >/dev/null 2>&1'
for path in /system/bin/su /system/xbin/su /sbin/su /vendor/bin/su /data/local/tmp/su; do
  run_check "No su binary: $path" sh -c '! [ -e "'"$path"'" ]'
done

# --- MAGISKSU CHECKS ---
run_check "No Magisk mount" sh -c '! mount | grep -q magisk'
run_check "No Magisk tmpfs" sh -c '! mount | grep -q /magisk'
run_check "No Magisk paths" sh -c '! [ -e /sbin/.magisk -o -e /data/adb/magisk ]'
run_check "No Magisk modules" sh -c '! [ -d /data/adb/modules ] || ! ls /data/adb/modules | grep -q magisk'
run_check "No magisk binary" sh -c '! command -v magisk >/dev/null 2>&1'

# --- KERNELSU CHECKS ---
run_check "No KernelSU" sh -c '! [ -e /data/adb/ksud -o -e /data/adb/modules/KernelSU ]'

# --- BUSYBOX & TOYS ---
run_check "No busybox" sh -c '! command -v busybox >/dev/null 2>&1'

# --- SUPERUSER APPS ---
run_check "No Superuser.apk" sh -c '! [ -e /system/app/Superuser.apk -o -e /system/priv-app/Superuser.apk ]'
run_check "No SuperSU" sh -c '! pm list packages 2>/dev/null | grep -q com.noshufou.android.su'

# --- ADVANCED SYSTEMLESS CHECKS ---
run_check "No suspicious init.rc" sh -c '! grep -q "su " /init.rc 2>/dev/null'
run_check "No suspicious fstab" sh -c '! grep -q "su " /vendor/etc/fstab.* 2>/dev/null'
run_check "No overlayfs root" sh -c '! mount | grep -q overlay && ! mount | grep -q /data'

# --- EMULATOR DETECTION ---
run_check "Not emulator (qemu)" sh -c '! getprop ro.kernel.qemu | grep -q 1'
run_check "Not emulator (build)" sh -c '! getprop ro.build.characteristics | grep -q emulator'

# --- Play Integrity hook (unchanged) ---
[ -f /data/local/tmp/wmroot_integrity.ok ] && \
  run_check "Play Integrity DEVICE/STRONG" true || \
  run_check "Play Integrity DEVICE/STRONG" false

echo
echo "== RESULT =="

echo "Checks total : $TOTAL"
echo "Passed       : $PASSED"
echo "Failed       : $FAILED"

PROB=$((FAILED * 100 / TOTAL))
echo "Root probability: ${PROB}%"

echo
if [ $COMPROMISED -eq 1 ]; then
  echo "❌ DEVICE STATUS: ROOTED"
  echo "    Failed checks indicate possible root/modifications"
else
  echo "✅ DEVICE STATUS: NO EVIDENCE OF ROOT"
  echo "    Device appears clean and unmodified"
fi

echo
echo "=== DETAILED BREAKDOWN ==="
echo "COMPROMISED=$COMPROMISED TOTAL=$TOTAL PASSED=$PASSED FAILED=$FAILED"
