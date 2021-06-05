# Infrared codes

Infrared codes from the Katana remote control, read using an ESP32 and a standard 38kHz infrared photodiode.

One could possibly get away with programming an M5Stack Atom Lite for sending them on demand, and powering it from the USB host port of the Katana.

Note that the remote is the only way of manipulating the intensity of the subwoofer – Sound Blaster Connect cannot handle it, and the Katana sends no data to the USB connection when bass is manipulated from the remote.

- Protocol: NEC
- Address: 0x2283


| Button       | Command  | Raw-Data   |
|--------------|----------|------------|
| Mute         | 0x0C     | 0xF30C2283 |
| | | |
| Power        | 0x08     | 0xF7082283 |
| | | |
| Bass         | 0x0F     | 0xF00F2283 |
| Plus         | 0x0A     | 0xF50A2283 |
| SBX (X)      | 0x16     | 0xE9162283 |
| | | |
| Left         | 0x07     | 0xF8072283 |
| Play/Pause   | 0x09     | 0xF6092283 |
| Right        | 0x06     | 0xF9062283 |
| | | |
| Display      | 0x00     | 0xFF002283 |
| Minus        | 0x01     | 0xFE012283 |
| LED          | 0x02     | 0xFD022283 |
| | | |
| Bluetooth    | 0x1C     | 0xE31C2283 |
| | | |
| USB          | 0x15     | 0xEA152283 |
| | | |
| Computer     | 0x13     | 0xEC132283 |
| Optical      | 0x11     | 0xEE112283 |
| AUX          | 0x12     | 0xED122283 |
