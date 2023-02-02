# Infrared codes

Infrared codes from the Katana remote control, read using an ESP32 and a standard 38kHz infrared photodiode.

One could possibly get away with programming an M5Stack Atom Lite for sending them on demand, and powering it from the USB host port of the Katana.

Note that the remote is the only way of manipulating the intensity of the subwoofer – Sound Blaster Connect cannot handle it, and the Katana sends no data to the USB connection when bass is manipulated from the remote.

LSB values are used with ESPhome 2021.12 and onwards.

- Protocol: NEC
- LSB Address: 0x2283
- MSB Address: 0xC144

| Button       | LSB Command | MSB Command |
|--------------|-------------|-------------|
| Mute         |    0xF30C   |    0x30CF   |
| | | |
| Power        |    0xF708   |    0x10EF   |
| | | |
| Bass         |    0xF00F   |    0xF00F   |
| Plus         |    0xF50A   |    0x50AF   |
| SBX (X)      |    0xE916   |    0x6897   |
| | | |
| Left         |    0xF807   |    0xE01F   |
| Play/Pause   |    0xF609   |    0x906F   |
| Right        |    0xF906   |    0x609F   |
| | | |
| Display      |    0xFF00   |    0x00FF   |
| Minus        |    0xFE01   |    0x807F   |
| LED          |    0xFD02   |    0x40BF   |
| | | |
| Bluetooth    |    0xE31C   |    0x38C7   |
| | | |
| USB          |    0xEA15   |    0xA857   |
| | | |
| Computer     |    0xEC13   |    0xC837   |
| Optical      |    0xEE11   |    0x8877   |
| AUX          |    0xED12   |    0x48B7   |
