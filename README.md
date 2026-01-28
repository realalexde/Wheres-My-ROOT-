
# Where's My ROOT? - Android Root Detection

## 🚀 Quick Start (3 Commands)

### 📱 In Termux (Recommended):
# 1. Update packages & install busybox (if needed)
pkg update && pkg install busybox

# 2. Run check DIRECTLY from GitHub (no save!)
`curl -s https://raw.githubusercontent.com/realalexde/Wheres-My-ROOT-/refs/heads/main/check.sh | sh`

### 💾 Alternative - Save & Run:
# Download
curl -O https://raw.githubusercontent.com/realalexde/Wheres-My-ROOT-/refs/heads/main/check.sh

# Make executable
chmod +x check.sh

# Run
sh ./check.sh

### 🔥 One-liner (Copy-Paste):
curl -s https://raw.githubusercontent.com/realalexde/Wheres-My-ROOT-/refs/heads/main/check.sh | sh

## ✅ Sample Output:
🔍 CORE SYSTEM INTEGRITY:
[+] PASS: Shell not root (uid!=0)
[!] FAIL: Bootloader locked

=== PLAY INTEGRITY STATUS ===
BASIC     ✅
DEVICE    ❌
STRONG    ❌

✅ ROOT DETECTED

Checks total : 28 | Passed: 22 | Failed: 6
Root probability: 21%

## 🎯 Play Integrity Files

Script reads 3 separate files:
`
touch /data/local/tmp/wmroot_basic.ok    # BASIC ✅
touch /data/local/tmp/wmroot_device.ok   # DEVICE ✅  
touch /data/local/tmp/wmroot_strong.ok   # STRONG ✅
`

## 📋 What It Checks (28+ Tests):

| Category | Checks |
|----------|--------|
| 🔒 **Core** | Bootloader, Verified Boot, SELinux, ro.secure |
| 🔍 **Root** | su binaries, Magisk, KernelSU, APatch |
| 📱 **Apps** | SuperSU, busybox, Root Explorer |
| ⚙️ **Advanced** | overlayfs, Xposed, test-keys, qemu |

## 💾 Repository
`
https://github.com/realalexde/Wheres-My-ROOT-
`

## 🛠️ Features
- ✅ **28+ root detection tests**
- ✅ **Individual Play Integrity (BASIC/DEVICE/STRONG)**
- ✅ **Magisk/KernelSU/APatch detection**
- ✅ **Works with `/system/bin/sh`** (no dependencies)
- ✅ **Color-coded results** ✅❌
- ✅ **Root probability %**

---

**Canvas-ready Markdown** - copy this entire block into your GitHub README.md! 🎨

