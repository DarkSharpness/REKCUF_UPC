module MemCtrl(
    // system input
    input   wire                clkIn,      // system clock signal
    input   wire                rstIn,      // reset signal
    input   wire                rdyIn,      // ready signal, pause cpu when low

    // branch prediction
    input   wire                rollback,   // rollback when mispredicted

    // memory interface
    input   wire [ 7:0]         mem_din,    // data input bus
    output  wire [ 7:0]         mem_dout,   // data output bus
    output  reg  [31:0]         mem_a,      // address bus (only 17:0 is used)
    output  reg                 mem_wr,     // write/read signal (1 for write)
    input   wire                io_buffer_full, // 1 if uart buffer is full

    // instruction fetch and icache.
    input   wire            iFlag, // Whether to fetch
    input   wire [31:0]     iAddr, // PC of the instruction to fetch
    output  reg             iDone, // Whether the instruction is ready

    // load store buffer.
    input   wire            lsbFlag,    // Whether to load/store
    input   wire            lsbBits,    // Whether to load/store 8/16/32 bits
    input   wire [31:0]     lsbAddr,    // Address of the data to load/store
    input   wire [31:0]     lsbData,    // Data to store
    output  reg             lsbDone,    // Whether the load/store is ready

    // common data output.
    output  reg  [31:0]     Loaded,     // Data loaded from memory
);

// state machine
localparam IDLE = 2'b00, IFETCH = 2'b01, READ = 2'b10, WRITE = 2'b11;
reg [2:0] stage;    // stage of execution in each state.
reg [1:0] status;   // status for the state machine.

always @(posedge clkIn) begin
    if (rstIn) begin
    end else if (~rdyIn) begin
        // TODO
    end else begin
        case (status)
            IDLE: begin
            end

            IFETCH: begin
                
            end

            Read: begin

            end
            Write: begin

            end
        endcase
    end

end


   
endmodule
