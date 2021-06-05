# USB commands

The following incredibly incomplete tables show how to send commands to the Creative Sound BlasterX Katana, using its USB port and a Linux hidraw device node. It should theoretically be possible to control a Katana from any operating system with a hidraw equivalent.

Note that only root can write to a hidraw device. There is probably an absurdly simple way around this, with an even more absurd number of potential consequences. Caveat emptor.

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

Magic byte 0x5a, command 0x1a, followed by 3 bytes of data.

## Commands

### 0x07 - System information

- Length 1, Data 0x00 - Returns a 10 byte data array
- Length 1, Data 0x01 - Returns a 7 byte data array
- Length 1, Data 0x02 - Returns firmware version as an ASCII string, 0 terminated
- Length 1, Data 0x03 - Returns 9 bytes in hexadecimal notation as a 0 terminated ASCII string


## Responses

### 0x02 - Error

- The length will usually be 10, but sometimes only 2. The first Data byte is the command that failed.
