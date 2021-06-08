# Infrared codes

Infrared codes from the Katana remote control, read using an ESP32 and a standard 38kHz infrared photodiode.

One could possibly get away with programming an M5Stack Atom Lite for sending them on demand, and powering it from the USB host port of the Katana.

Note that the remote is the only way of manipulating the intensity of the subwoofer – Sound Blaster Connect cannot handle it, and the Katana sends no data to the USB connection when bass is manipulated from the remote.

- Protocol: NEC
- Address: 0xC144


| Button       | Command  |
|--------------|----------|
| Mute         | 0x30CF   |
| | | |
| Power        | 0x10EF   |
| | | |
| Bass         | 0xF00F   |
| Plus         | 0x50AF   |
| SBX (X)      | 0x6897   |
| | | |
| Left         | 0xE01F   |
| Play/Pause   | 0x906F   |
| Right        | 0x609F   |
| | | |
| Display      | 0x00FF   |
| Minus        | 0x807F   |
| LED          | 0x40BF   |
| | | |
| Bluetooth    | 0x38C7   |
| | | |
| USB          | 0xA857   |
| | | |
| Computer     | 0xC837   |
| Optical      | 0x8877   |
| AUX          | 0x48B7   |
