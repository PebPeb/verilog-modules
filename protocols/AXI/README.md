
# AMBA AXI

AMBA in AMBA AXI stands for Advanced Microcontroller Bus Architecture. It is a set of interconnect specifications developed by ARM for communication between various components in a System-on-Chip (SoC).

# Write

VALID and READY signals

Master uses **VALID** to tell the Slave information is available on the channel. The Slave uses the **READY** signal to show when it can accept the information.

## Write Data Channel

- **WDATA**: Can be 8, 16, 32, 64, 128, 256, 512, or 1024 bits wide
  - This is indicated by DATA_WIDTH property
- ****: For every byte/8 data bits indicates the bytes of data are valid
  - *Example*: If 24 bits are valid in a 32 bit buss then **** = 4b'0111
  
Write channel information is always treated as buffered


## Write Response Channel

