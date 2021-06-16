# KatanaHacking
USB protocol and IR codes for the Creative Sound BlasterX Katana.

## DISCLAIMER

No warranties! Use at your own risk! If anything breaks, it's NOT my fault.

If your Katana fries from trying out the USB commands documented here, it should be considered a firmware bug and filed with Creative.

## tl;dr:
- [USB protocol](USB.md)
- [Infrared codes](IR.md)

## [Katana Control](katanactl.pp)
- Compiles with FreePascal. It will be documented in the future, but for now, i use it to dump the missing "opcodes", both in realtime and from converted Wireshark dumps. You can also use it to (very rudimentarily) send commands to a Katana, but i recommend you don't do this unless you understand FreePascal syntax.

## What was used:
- Firmware 2.1.210426.140 - this firmware update was not accompanied by a driver or application update, so i suppose this will work with the 2019 firmware as well.
- USB protocol captured using Wireshark and USBPcap on Windows, and analysed using Wireshark on Linux.
- IR codes read using an ESP32 and a standard 38kHz infrared photocell.
- No reverse engineering of drivers, applications or firmware files have taken place. Frankly, i wouldn't know where to begin.

## Inspired and helped by:
- [Ian Douglas Scott](https://iandouglasscott.com/2018/01/14/reverse-engineering-creative-sound-blaster-e1/)
- [Christos Arvanitis](https://arvchristos.github.io/post/matching-dev-hidraw-devices-with-physical-devices/)
- [David Sword](https://davidsword.ca/create-custom-ir-remote-with-home-assistant-esphome/)
