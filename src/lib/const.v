`ifndef Dark_Constants
`define Dark_Constants

`define BYTE_WIDTH  7:0

`define INST_BYTE   4
`define INST_WIDTH  31
`define DATA_WIDTH  31
`define ADDR_WIDTH  31

// 64L 64B ICACHE, 4KiB total
// 64 lines, 64 bytes per line

`define CACHE_LENGTH    64
`define CACHE_SIZE      64

`define CACHE_TAG_WIDTH     20
`define CACHE_INDEX_WIDTH   6
`define CACHE_OFFSET_WIDTH  4       // Low 2 bytes are useless for ICACHE.

`define CACHE_TAG_RANGE     31:12   // 20 high bits as tag
`define CACHE_INDEX_RANGE   11:6    // 64 lines
`define CACHE_OFFSET_RANGE  5:2     // 6 bits offset in a 64B line

`endif
