module Add4(
        input   wire    [3:0]   a,
        input   wire    [3:0]   b,
        input   wire            cin,
        output  wire    [3:0]   sum,
        output  wire            g,
        output  wire            p
    );
    wire    [3:0]   G = a & b; // g
    wire    [3:0]   P = a ^ b; // p
    wire    [3:0]   c;

    assign c[0] = cin;
    assign c[1] = G[0] | (P[0] & cin);
    assign c[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & cin);
    assign c[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & cin);

    assign  sum = c ^ P;
    assign  g   = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
    assign  p   = P[3] & P[2] & P[1] & P[0];

endmodule

module Add16(
        input  wire     [15:0]          a,
        input  wire     [15:0]          b,
        input  wire                     cin,
        output wire     [15:0]          sum,
        output wire                      cout
    );
    wire    [3:0]   G;
    wire    [3:0]   P;
    wire    [3:0]   c;

    assign c[0] = cin;
    assign c[1] = G[0] | (P[0] & cin);
    assign c[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & cin);
    assign c[3] = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & cin);

    Add4 add4_0(a[3:0], b[3:0], c[0], sum[3:0], G[0], P[0]);
    Add4 add4_1(a[7:4], b[7:4], c[1], sum[7:4], G[1], P[1]);
    Add4 add4_2(a[11:8], b[11:8], c[2], sum[11:8], G[2], P[2]);
    Add4 add4_3(a[15:12], b[15:12], c[3], sum[15:12], G[3], P[3]);

    assign cout = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | (P[3] & P[2] & P[1] & P[0] & cin);
endmodule


module Add32(
        input wire      [31:0]          a,
        input wire      [31:0]          b,
        input wire                      cin,
        output wire     [31:0]          sum,
        output wire                     cout
    );
    wire tmp;
    Add16 add16_0(a[15:0] , b[15:0],  cin, sum[15:0] , tmp);
    Add16 add16_1(a[31:16], b[31:16], tmp, sum[31:16], cout);
endmodule


module Add(
        input   wire    [31:0]          a,
        input   wire    [31:0]          b,
        output  reg     [31:0]          sum
    );
    wire [31:0] ans;

    Add32 add32_main(
        .a(a),
        .b(b),
        .cin(1'b0),
        .sum(ans),
        .cout()
    );

    always @* begin
		sum <= ans;
	end

endmodule