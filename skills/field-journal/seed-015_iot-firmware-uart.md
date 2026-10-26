# [Seed] IoT Router Firmware Extraction + UART Serial Root Access

## Scenario Classification
Firmware / IoT Security

## Goal Overview
For a low-to-mid-range home router, obtain the firmware bin from the vendor website, extract the squashfs with binwalk, connect to the device UART via serial to get a root shell, and analyze its web management interface and startup scripts.

## Complete Execution Chain

### Part 1: Firmware Analysis

1. Download the firmware file (vendor website / OpenWRT / dump the flash yourself).
2. Basic identification.
   ```bash
   file firmware.bin
   binwalk firmware.bin                    # see LZMA / SquashFS / U-Boot
   binwalk -E firmware.bin                 # entropy graph to determine whether it is encrypted
   ```
3. Extraction.
   ```bash
   binwalk -e firmware.bin
   cd _firmware.bin.extracted/squashfs-root
   ```
4. Key points for static analysis.
   ```bash
   find . -name 'shadow' -exec cat {} \;          # default password hashes
   find . -name '*.cgi' -o -name 'lighttpd*'      # web service
   find . -name 'rcS' -o -name 'init.d'           # startup scripts
   grep -r 'telnetd\|busybox' .                   # suspicious backdoors
   strings $(find . -name 'httpd') | grep -i 'admin\|debug\|backdoor'
   ```
5. Obtain `/etc/shadow` and crack it offline:
   ```bash
   john --wordlist=rockyou.txt shadow
   ```

### Part 2: Hardware UART

1. Open the case and inspect the PCB → look for unpopulated 4-pin / 6-pin headers (usually unsoldered or already has pins soldered).
2. Identify with a multimeter:
   - GND (connects to the ground copper pour)
   - VCC (3.3V, stable at boot)
   - TX (voltage fluctuates a lot at boot; outputs in the UART → PC direction)
   - RX (basically unchanged at boot)
3. Connect a USB-TTL adapter (CP2102 / FT232):
   - Router TX → USB-TTL RX
   - Router RX → USB-TTL TX
   - Router GND → USB-TTL GND
   - **Do not connect VCC** (the device is self-powered)
4. Open a serial monitor on the host:
   ```bash
   sudo screen /dev/ttyUSB0 115200
   # or: minicom / picocom
   ```
5. Power on → watch U-Boot output → Linux boots → usually reaches a login prompt.
6. Try default credentials / the cracked shadow password → get a root shell.

## Pitfalls

| Issue | Cause | Solution | Time Spent |
|------|------|---------|------|
| Extraction produces an empty directory | Some firmware uses a non-standard format (vendor-private header) | Use `dd` to slice at the offset and extract manually, or use `unblob` instead of binwalk | 1h |
| binwalk -E shows entropy close to 1 | Fully encrypted | Find the decryption key used during firmware upgrade (usually hardcoded in the OEM tool) | Several hours |
| No characters visible on UART | Wrong baud rate | Try 9600 / 38400 / 57600 / 115200 / 460800 / 921600 | 30min |
| Characters visible on UART but garbled | TX/RX reversed / voltage mismatch | 1) Swap TX and RX  2) Confirm the USB-TTL is 3.3V, not 5V | 30min |
| Login prompt appears but no password works | Not cracked + vendor default password has been changed | Interrupt U-Boot with a keypress → `setenv bootargs ${bootargs} init=/bin/sh` → enter single-user mode | 1.5h |
| U-Boot does not respond to keypress interrupts | Vendor disabled the console / changed the prompt | Find `bootdelay` in the firmware; physically short the SPI flash to cause a boot failure and force U-Boot into interactive mode | Several hours |
| Got root but telnetd does not work | Image lacks dropbear/telnetd | Mount USB and copy a busybox-static binary onto it | 1h |

## Toolchain Findings

- **unblob** is more powerful than binwalk (automatically recognizes more formats and does not get stuck on private headers).
- **firmware-mod-kit** is a veteran tool but still usable for unpacking/repacking.
- **firmwalker** automatically scans the extracted squashfs for "sensitive clues" (credentials/private keys/URLs/binary backdoors).
- **EMBA** is a comprehensive firmware audit platform (an automated version of firmwalker + binary CVE scanning + emulated boot).
- **FirmAE** uses QEMU to emulate IoT firmware, enabling dynamic analysis of the web interface without real hardware.
- **ChirpStack USB-TTL** / **Bus Pirate** / **Tigard** all work; a cheap CP2102 is enough.

## Key Code/Commands

One-stop firmware audit:

```bash
# 1. Extract
unblob -k firmware.bin -o extracted/

# 2. Run firmwalker
git clone https://github.com/craigz28/firmwalker
./firmwalker.sh extracted/squashfs-root

# 3. Emulated boot (if supported)
docker run -it --rm -v $(pwd):/firmware firmae:latest \
  /work/run.sh -d 1 /firmware/firmware.bin

# 4. Once the web interface is emulated → scan directly with nuclei / nikto / curl
```

UART auto-try common baud rates:

```bash
for baud in 9600 19200 38400 57600 115200 460800 921600; do
    echo "--- $baud ---"
    timeout 3 sudo cat /dev/ttyUSB0 < <(stty -F /dev/ttyUSB0 $baud cs8 -cstopb -parenb)
done
```

Classic U-Boot single-user bypass trick:

```text
# Interrupt U-Boot with a keypress (usually hold Space or Ctrl+C)
=> setenv bootargs "console=ttyS0,115200 root=/dev/mtdblock2 rootfstype=squashfs init=/bin/sh"
=> saveenv
=> boot
# After boot, drop straight into sh without a password
```

## Suggestions for This Package

- `reverse-engineering/platforms.md` already contains a firmware chapter; suggest splitting out `references/iot-firmware-cheatsheet.md`.
- Add `reverse-engineering/references/uart-debug.md` covering UART/JTAG/SWD basics.
- Add unblob / firmwalker to the bootstrap manifest.

## Reusable Patterns/Script Snippets

**4 phases of IoT security testing**:

```text
Phase 1 — Software
  · Vendor firmware download + binwalk/unblob extraction
  · Run firmwalker once
  · grep for default credentials / private keys / backdoor strings
  · Emulated QEMU boot to run web vulnerability scans

Phase 2 — Hardware
  · Open the case and find UART/JTAG solder points
  · Use a multimeter to identify GND/VCC/TX/RX
  · Wire USB-TTL; confirm 3.3V level

Phase 3 — Debugging
  · Monitor with screen/minicom
  · Interrupt at the U-Boot stage to enter interactive mode
  · init=/bin/sh single-user password bypass

Phase 4 — Exploitation
  · Get root → crack /etc/shadow offline
  · Inspect web management CGI binaries → look for command injection / SSRF
  · Inspect UPnP / mDNS / Bluetooth broadcast logic
```

**Default credentials quick reference (common vendor defaults)**:

```text
admin / admin
admin / password
root / root
root / 1234
support / support
ubnt / ubnt          # Ubiquiti
admin / 1234         # ZyXEL
```

## Evolution Actions
- [ ] Split out iot-firmware-cheatsheet.md
- [ ] Create uart-debug.md
- [ ] Add unblob / firmwalker to bootstrap-manifest

## Environment Information
- Kali 2026.x (binwalk / unblob / squashfs-tools / firmwalker)
- USB-TTL adapter: CP2102 / FT232 (3.3V level)
- Target: ARMv7 / MIPS routers (common in OpenWRT-derived firmware)

## Anonymization Requirements
This entry is seed data, written based on public IoT security testing methods, and does not involve any real vendor or model.
