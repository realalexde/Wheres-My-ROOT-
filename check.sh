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

echo "== Where's my ROOT?? :: Advanced Android Root / Integrity Check v4.0 =="
echo

# --- CORE SYSTEM CHECKS ---
echo "🔍 CORE SYSTEM INTEGRITY:"
run_check "Shell not root (uid!=0)" sh -c '! id | grep -q "uid=0"'
run_check "Bootloader locked" sh -c 'getprop ro.boot.vbmeta.device_state 2>/dev/null | grep -q locked'
run_check "Verified Boot GREEN" sh -c 'getprop ro.boot.verifiedbootstate 2>/dev/null | grep -q green'
run_check "/system mounted ro" sh -c '! mount | grep " /system " | grep -q rw'
run_check "/vendor mounted ro" sh -c '! mount | grep " /vendor " | grep -q rw'
run_check "ro.secure=1" sh -c 'getprop ro.secure 2>/dev/null | grep -q 1'
run_check "ro.debuggable=0" sh -c 'getprop ro.debuggable 2>/dev/null | grep -q 0'
run_check "Build type user" sh -c 'getprop ro.build.type 2>/dev/null | grep -q user'
run_check "Build tags release-keys" sh -c 'getprop ro.build.tags 2>/dev/null | grep -q release-keys'
run_check "SELinux enforcing" sh -c 'getenforce 2>/dev/null | grep -q Enforcing'

echo

# --- ROOT BINARY CHECKS ---
echo "🔍 ROOT BINARIES:"
run_check "No su in PATH" sh -c '! command -v su >/dev/null 2>&1'
for path in /system/bin/su /system/xbin/su /sbin/su /vendor/bin/su /data/local/tmp/su /data/local/bin/su; do
  run_check "No su binary: $(basename "$path")" sh -c '! [ -e "'"$path"'" ]'
done

echo

# --- MAGISKSU CHECKS ---
echo "🔍 MAGISK/KERNELSU:"
run_check "No Magisk mount" sh -c '! mount | grep -qE "(magisk|/magisk|/sbin/.magisk)"'
run_check "No Magisk paths" sh -c '! [ -e /sbin/.magisk -o -e /data/adb/magisk -o -e /cache/magisk.log ]'
run_check "No Magisk modules" sh -c '! [ -d /data/adb/modules ] || ! ls /data/adb/modules 2>/dev/null | grep -qE "(magisk|ksu)"'
run_check "No KernelSU" sh -c '! [ -e /data/adb/ksud -o -e /data/adb/modules/KernelSU ]'
run_check "No APatch" sh -c '! [ -e /data/adb/ap -o -e /data/adb/modules/APatch ]'

echo

# --- APPS & TOOLS ---
echo "🔍 ROOT APPS/TOOLS:"
run_check "No Superuser.apk" sh -c '! [ -e /system/app/Superuser.apk -o -e /system/priv-app/Superuser.apk ]'
run_check "No SuperSU app" sh -c '! pm list packages 2>/dev/null | grep -qE "(noshufou|supersu|superuser)"'
run_check "No busybox" sh -c '! command -v busybox >/dev/null 2>&1'
run_check "No Root Explorer" sh -c '! pm list packages 2>/dev/null | grep -qE "(rootexplorer|solidexplorer)"'

echo

# --- ADVANCED CHECKS ---
echo "🔍 ADVANCED:"
run_check "No suspicious init.rc" sh -c '! grep -qr "su>" /init.rc /system/etc/init 2>/dev/null'
run_check "No overlayfs root" sh -c '! mount | grep -q "overlay" && mount | grep -q "/data "'
run_check "No qemu/emulator" sh -c '! getprop ro.kernel.qemu 2>/dev/null | grep -q 1'
run_check "No test build props" sh -c '! grep -q "test-keys" /system/build.prop 2>/dev/null'
run_check "No Xposed" sh -c '! [ -e /system/framework/XposedBridge.jar ]'

echo

# --- Play Integrity - 3 отдельных файла ---
echo "🔍 PLAY INTEGRITY:"
BASIC_OK=0 DEVICE_OK=0 STRONG_OK=0

[ -f /data/local/tmp/wmroot_basic.ok ] && BASIC_OK=1
[ -f /data/local/tmp/wmroot_device.ok ] && DEVICE_OK=1  
[ -f /data/local/tmp/wmroot_strong.ok ] && STRONG_OK=1

run_check "Play Integrity BASIC" sh -c "[ $BASIC_OK -eq 1 ]"
run_check "Play Integrity DEVICE" sh -c "[ $DEVICE_OK -eq 1 ]"
run_check "Play Integrity STRONG" sh -c "[ $STRONG_OK -eq 1 ]"

echo
echo "== RESULT =="

echo "Checks total : $TOTAL"
echo "Passed       : $PASSED"
echo "Failed       : $FAILED"

PROB=$((FAILED * 100 / TOTAL))
echo "Root probability: ${PROB}%"

echo
echo "=== PLAY INTEGRITY STATUS ==="
echo "BASIC     $( [ $BASIC_OK -eq 1 ] && echo "✅" || echo "❌" )"
echo "DEVICE    $( [ $DEVICE_OK -eq 1 ] && echo "✅" || echo "❌" )"
echo "STRONG    $( [ $STRONG_OK -eq 1 ] && echo "✅" || echo "❌" )"

echo
if [ $COMPROMISED -eq 1 ]; then
  echo "✅ ROOT DETECTED"
else
  echo "❌ NO ROOT DETECTED"
fi

echo
echo "=== STATS ==="
echo "COMPROMISED=$COMPROMISED | TOTAL=$TOTAL | PASS=$PASSED | FAIL=$FAILED"
