# 📱 Where's My ROOT?
> Android root detection in a single shell script — no dependencies, no installs, just copy-paste.

---

## ⚡ Quick Start

### Run directly (no save needed)
```sh
curl -s https://raw.githubusercontent.com/realalexde/Wheres-My-ROOT-/refs/heads/main/check.sh | sh
```

### Save & run
```sh
curl -O https://raw.githubusercontent.com/realalexde/Wheres-My-ROOT-/refs/heads/main/check.sh
chmod +x check.sh
sh ./check.sh
```

> **Recommended:** run inside [Termux](https://termux.dev). Install busybox first if needed:
> ```sh
> pkg update && pkg install busybox
> ```

---

## 🧾 Sample Output

```
🔍 CORE SYSTEM INTEGRITY:
[+] PASS: Shell not root (uid!=0)
[!] FAIL: Bootloader locked

=== PLAY INTEGRITY STATUS ===
BASIC     ✅
DEVICE    ❌
STRONG    ❌

✅ ROOT DETECTED
Checks total: 28 | Passed: 22 | Failed: 6
Root probability: 21%
```

---

## 🎯 Play Integrity — Manual Override

The script reads three flag files to determine Play Integrity status.  
Create them manually to mark each level as passed:

```sh
touch /data/local/tmp/wmroot_basic.ok    # BASIC  ✅
touch /data/local/tmp/wmroot_device.ok   # DEVICE ✅
touch /data/local/tmp/wmroot_strong.ok   # STRONG ✅
```

---

## 🔬 What It Checks — 28+ Tests

| Category | What's Detected |
|---|---|
| 🔒 **Core System** | Bootloader state, Verified Boot, SELinux, `ro.secure` |
| 🔍 **Root Binaries** | `su`, Magisk, KernelSU, APatch |
| 📱 **Root Apps** | SuperSU, Root Explorer, busybox |
| ⚙️ **Advanced** | `overlayfs`, Xposed, `test-keys`, QEMU/emulator |

---

## ✨ Features

- 28+ root detection tests
- Play Integrity levels: **BASIC / DEVICE / STRONG**
- Detects **Magisk**, **KernelSU**, **APatch**
- Works with plain `/system/bin/sh` — zero dependencies
- Color-coded output with root probability percentage

---

## 🔗 Repository

[github.com/realalexde/Wheres-My-ROOT-](https://github.com/realalexde/Wheres-My-ROOT-)
