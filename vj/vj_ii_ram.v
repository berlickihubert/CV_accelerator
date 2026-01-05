module vj_ii_ram #(
    parameter ADDR_W = 17,
    parameter DATA_W = 32,
    parameter integer DEPTH = 77361 // 321*241 = 77361
) (
    input  wire                 clk,

    // write port
    input  wire                 we,
    input  wire [ADDR_W-1:0]     waddr,
    input  wire [DATA_W-1:0]     wdata,

    input  wire [ADDR_W-1:0]     raddr,
    output reg  [DATA_W-1:0]     rdata
);

    reg [DATA_W-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        if (we) begin
            mem[waddr] <= wdata;
        end
        rdata <= mem[raddr];
    end

endmodule
