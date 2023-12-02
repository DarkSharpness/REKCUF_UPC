module RegisterFile #(
    parameter ROB_WIDTH = 4
    parameter REG_WIDTH = 5
) (
    input   wire    rstIn,
    input   wire    clkIn,
    input   wire    clrIn,  // wrong branch prediction
    input   wire    rdyIn,

    // instruction unit
    input   wire    issueFlag,
    input   wire    [REG_WIDTH-1:0] issueReg,   // rd
    input   wire    [ROB_WIDTH-1:0] issueROB,   // issue to ROB

    // request from decoder
    input   wire    [REG_WIDTH-1:0] rs1Flag,    // rs1
    output  wire                    rs1Busy,    // rs1 busy
    output  wire    [31:0]          rs1Data,    // rs1 data
    output  wire    [ROB_WIDTH-1:0] rs1Rename,  // rs1 rename

    input   wire    [REG_WIDTH-1:0] rs2Flag,    // rs2
    output  wire                    rs2Busy,    // rs2 busy
    output  wire    [31:0]          rs2Data,    // rs2 data
    output  wire    [ROB_WIDTH-1:0] rs2Rename,  // rs2 rename

    // reorder buffer commit
    input wire  writeFlag,
    input wire  [ROB_WIDTH-1:0] writeSrc,
    input wire  [REG_WIDTH-1:0] writeReg,
    input wire  [31:0]          writeData,
);

// Data part.
reg [31:0] data[31:0];              // Core register data.
reg [ROB_WIDTH:0] reorder [31:0];   // highest bit as dirty tag.

wire issueEffective = issueFlag && (issueReg != 0);
wire writeEffective = writeFlag && (writeReg != 0);
wire writeLatest    = busy[writeReg] && (reorder[writeReg] == writeSrc);


// Body part.
always @(posedge clkIn) begin
    if (rstIn || clrIn) begin 
        if (rstIn) begin
            integer j; generate
                for (j = 0; j < 32; j = j + 1) data[j] <= 0;
            endgenerate
        end

        integer i; generate
            for (i = 0; i < 32; i = i + 1) reorder[i] <= 0;
        endgenerate

    end else if (rdyIn) begin
        // Commit before issue, or will cause error!
        if (writeEffective) begin 
            data[writeReg] <= writeData;
            if (writeLatest) reorder[writeReg] <= 0;
        end

        if (issueEffective) begin
            reorder[issueReg] <= {1'b1, issueROB};
        end
    end
end

// Output part.
assign rs1Data      = data[rs1Flag];
assign rs1Busy      = busy[rs1Flag];
assign rs1Rename    = reorder[rs1Flag];
assign rs2Data      = data[rs2Flag];
assign rs2Busy      = busy[rs2Flag];
assign rs2Rename    = reorder[rs2Flag];


endmodule