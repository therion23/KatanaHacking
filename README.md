# KatanaHacking
USB protocol and IR codes for the Creative Sound BlasterX Katana

## DISCLAIMER



## tl;dr:
- [USB protocol](USB.md)
- [Infrared codes](IR.md)

## What was used:
- Firmware 2.1.210426.140
- USB protocol captured using Wireshark and USBPcap on Windows, and analysed using Wireshark on Linux.
- IR codes read using an ESP32 and a standard 38kHz infrared photocell.
- No reverse engineering of drivers, applications or firmware files have taken place. Frankly, i wouldn't know where to begin.

## Inspired by:
- [Ian Douglas Scott](https://iandouglasscott.com/2018/01/14/reverse-engineering-creative-sound-blaster-e1/)
- [Christos Arvanitis](https://arvchristos.github.io/post/matching-dev-hidraw-devices-with-physical-devices/)
