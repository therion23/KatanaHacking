# USB commands

The following incredibly incomplete tables show how to send commands to the Creative Sound BlasterX Katana, using its USB port and a Linux hidraw device node. It should theoretically be possible to control a Katana from any operating system with a hidraw equivalent.

## Structures

The command and response structures are identical:

| Offset | Description             |
|--------|-------------------------|
|      0 | Magic byte, always 0x5a |
|      1 | Command                 |
|      2 | Length of data          |
|     3+ | Data                    |
