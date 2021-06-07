# USB commands

The following incredibly incomplete tables show how to send commands to the Creative Sound BlasterX Katana, using its USB port and a Linux hidraw device node. It should theoretically be possible to control a Katana from any operating system with a hidraw equivalent.

Note that only root can write to a hidraw device. There is probably an absurdly simple way around this, with an even more absurd number of potential consequences. Caveat emptor.

Note also that if you intend to program something around this, allocating 64 bytes for a receive buffer would be a good idea. The Katana always sends responses in 0 padded 64 byte blocks.

## Structures

The command and response structures are identical:

| Offset | Description             |
|--------|-------------------------|
|      0 | Magic byte, always 0x5a |
|      1 | Command                 |
|      2 | Length of data          |
|     3+ | Data                    |

## Example

`# echo –n –e '\x5A\x1A\x03\x00\x02\x01' > /dev/hidraw1`

Magic byte 0x5a, command 0x1a, followed by 3 bytes of Data.

## Commands and responses

### 0x02 - Error (response only)

- Returns Length 10 (sometimes only 2). The first Data byte is the command that failed. There is possibly a distinction in response codes between invalid commands and invalid Data sent to a valid command.

### 0x07 - System information

- Length 1, Data 0x00 - Returns 16 bytes of Data, out of which the first six are the USB VID, REV and PID (the rest are 0's).
- Length 1, Data 0x02 - Returns firmware version as an ASCII string, 0 terminated.
- Length 1, Data 0x03 - Returns the USB serial as an ASCII string, 0 terminated.

Setting Length to 0 returns the last received answer.

Note that there is no way of distinguishing between the responses, i.e. they don't contain information about the requested type. The apps for Windows and Android never request anything but the firmware revision (0x02).

### 0x11 - Get equalizer data

- Commands are always three bytes long. Responses are always two bytes indicating how many sets of six bytes follow.

### 0x12 - Set equalizer data

- Commands are always seven bytes long. Responses are often error 0x02's.

### 0x1a - Profiles

- Length 3, Data 0x02 0x00 0xNN - Select profile NN (0 for Neutral, 1-4 for stored profiles, 5 for "Personal", which i assume is a temporary profile). Returns 2 bytes of Data, 0x02 and 0xNN from before. Note that the returned profile number is sometimes XOR 0x80 for reasons unknown to me.

### 0x23 - Volume (response only)

- Returns Length 3, Data 0x00 0xNN 0x00, where NN is the volume displayed on the Katana itself (usually half of what Windows reports).

### 0x26 - Acoustic engine (Windows only?)


### 0x3a - Lighting

- Lighting contains a large amount of subcommands, which are specified as the first byte of Data.

#### Subcommand 0x04 - Set lighting pattern

- Data (after subcommand) 0x00 0xNN 0xYY 0xZZ, followed by 7 patterns of 7 bytes each (see subcommand 0x05 below). Returns an error, and i am yet to get it working.

#### Subcommand 0x05 - Get lighting pattern

- Length 3, Data (with subcommand) 0x05 0x01 0xNN, where NN is the profile number. Returns 54 bytes of Data, where the first 3 match your query, followed by 0xYY and 0xZZ, followed by 7 patterns of 7 bytes each. YY is usually 0x07, possibly signifying the number of patterns to follow. ZZ is usually 0x00.

#### Subcommand 0x06 - Lighting On/Off

- Length 1, Data 0x00 for off, anything else for on. This affects the currently selected profile only.

#### Subcommand 0x0a - Set palette

- Length 33, Data (after subcommand) 0x?? (can be 0 or 1) 0xNN (profile) 0x01 0x01, followed by 7 sets of 4 bytes each, defining the palette. The palette format is (yet) unknown to me.

#### Subcommand 0x0b - Get palette

- Data (after subcommand) 0x?? (can be 0 or 1) 0xNN (profile), followed by one or three bytes. Returns palette in the above format.

#### Subcommand 0x15 - Set lighting pattern name

- Data (after subcommand) is 0xNN for profile NN 0 thru 5, two bytes for length of name, and finally the name of the lighting pattern, where every character is followed by 0x00 (see 0x16 below). Strangely enough, it replies with an error (0x02), but it works just fine regardless.

#### Subcommand 0x16 - Get lighting pattern name

- Length 1, Data 0xNN for profile NN 0 thru 5. Returns Length, 0x16, 0xNN, length of string - twice, 0x00 and finally the name of the lighting pattern, where every character is followed by 0x00. So 'Test' would be `0x04 0x04 0x00 'T' 0x00 'e' 0x00 's' 0x00 't' 0x00`. Note that if a profile has lighting disabled, this function will return 'Lights Off' instead of the name of the stored pattern.

### 0x9c - Input

- Input contains a three (known) subcommands, which are specified as the first byte of Data.

#### Subcommand 0x00 - Set input

- Length 2, Data (with subcommand) 0x00 0xNN, where NN is 0x01 for Bluetooth, 0x04 for AUX (Jack in), 0x07 for Optical (S/PDIF), 0x09 for USB (mass storage), or 0x0C for Computer (via USB cable). Note that this command returns an error (0x02) followed immediately by a Subcommand 0x01 reply.

#### Subcommand 0x01 - Query input

- Length 1, Data (with subcommand) 0x01. Returns 6 bytes of Data, where the second is the currently active input as per the above list.

#### Subcommand 0x02 - Unknown

- Length 1, Data (with subcommand) 0x02. Returns 18 bytes of Data. It seems to be three bytes of something, followed by three bytes per input (device number as per above, followed by 0x02 0x01).

#### Subcommand 0x06 - Input status (response only)

- Returns Length 14. Four bytes of something, followed by five pairs of bytes - the index of the device (see subcommand 0x00) followed by its readiness, i.e. 0x04 0x01 if a jack plug is inserted in the AUX port, 0x04 0x00 if not.


## Equalizer registers

- 0x95 0x04 - Voice Clarity Noise Reduction
- 0x95 0x05 - Voice Morph
- 0x96 0x07 - Crystalizer
- 0x96 0x09 - Equalizer on/off
- 0x96 0x70 - Smart Volume
- 0x96 0x71 - Surround / Immersion
- 0x96 0x72 - Dialog+
- 0x97 0x02 - Dolby
