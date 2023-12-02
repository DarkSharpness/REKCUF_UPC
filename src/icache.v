module InstructionCache (
    input   wire        clkIn,
    input   wire        rstIn,
    input   wire        rdyIn,

    input   wire [31:0] addrIn,
    output  wire        hit,
    output  wire [31:0] dataOut,

    input   wire        wrEn,   // whether to write data into cache.
    input   wire [31:0] data,   // data to be written into cache.
);

// 256 lines in total. Each line contains one command.
localparam INDEX_WIDTH  = 8;
localparam INDEX_SIZE   = 2 ** INDEX_WIDTH;

// Tags with 32 - 2 - 8 = 22 bits
localparam TAG_WIDTH    = 22;

// Cached memory with tagging.
reg     [31:0]          cmd     [INDEX_SIZE-1:0]; // Command cached.
reg     [TAG_WIDTH : 0] tag     [INDEX_SIZE-1:0]; // lowest bit is valid bit.

wire    [TAG_WIDTH  -1:0]   tagIn   = addrIn[31:INDEX_WIDTH+2];
wire    [INDEX_WIDTH-1:0]   index   = addrIn[INDEX_WIDTH+1 :2];

always @(posedge clkIn) begin
    if (rstIn) begin
        genvar i; generate
            for (i = 0; i < SIZE; i = i + 1) begin
                mem[i]  <=  0;
                tag[i]  <=  0;
            end
        endgenerate
    end else if (rdyIn && wrEn) begin
        cmd[index]  <=  data;
        tag[index]  <=  {tagIn, 1'b1};
    end
end

// Output part.

assign hit      = tag[index] == {tagIn, 1'b1};
assign dataOut  = cmd[index];

endmodule
