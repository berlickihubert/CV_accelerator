module vj_rect_sum #(
    parameter II_W = 321,
    parameter ADDR_W = 17,
    parameter II_DATA_W = 32
) (
    input  wire                 clk,
    input  wire                 reset_n,

    input  wire                 start,
    input  wire [9:0]           x,
    input  wire [8:0]           y,
    input  wire [9:0]           w,
    input  wire [8:0]           h,

    output reg  [ADDR_W-1:0]    ii_raddr,
    input  wire [II_DATA_W-1:0] ii_rdata,

    output reg                  busy,
    output reg                  done,
    output reg  signed [II_DATA_W:0] sum
);

    localparam S_IDLE   = 4'd0;
    localparam S_SET_A  = 4'd1;
    localparam S_WAIT_A = 4'd2;
    localparam S_GET_A  = 4'd3;
    localparam S_SET_B  = 4'd4;
    localparam S_WAIT_B = 4'd5;
    localparam S_GET_B  = 4'd6;
    localparam S_SET_C  = 4'd7;
    localparam S_WAIT_C = 4'd8;
    localparam S_GET_C  = 4'd9;
    localparam S_SET_D  = 4'd10;
    localparam S_WAIT_D = 4'd11;
    localparam S_GET_D  = 4'd12;
    localparam S_OUT    = 4'd13;

    reg [3:0] state;

    reg [9:0] x0, x1;
    reg [8:0] y0, y1;

    reg [II_DATA_W-1:0] A, B, C, D;

    function [ADDR_W-1:0] ii_addr;
        input [9:0] xi;
        input [8:0] yi;
        begin
            ii_addr = (yi << 8) + (yi << 6) + yi + xi;
        end
    endfunction

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= S_IDLE;
            ii_raddr <= {ADDR_W{1'b0}};
            busy <= 1'b0;
            done <= 1'b0;
            sum <= '0;
            A <= '0; B <= '0; C <= '0; D <= '0;
            x0 <= 0; x1 <= 0; y0 <= 0; y1 <= 0;
        end else begin
            done <= 1'b0;

            case (state)
                S_IDLE: begin
                    busy <= 1'b0;
                    if (start) begin
                        x0 <= x + 10'd0;
                        y0 <= y + 9'd0;
                        x1 <= x + w;
                        y1 <= y + h;

                        busy <= 1'b1;
                        state <= S_SET_A;
                    end
                end

                S_SET_A: begin
                    ii_raddr <= ii_addr(x0, y0);
                    state <= S_WAIT_A;
                end

                S_WAIT_A: begin
                    state <= S_GET_A;
                end

                S_GET_A: begin
                    A <= ii_rdata;
                    state <= S_SET_B;
                end

                S_SET_B: begin
                    ii_raddr <= ii_addr(x1, y0);
                    state <= S_WAIT_B;
                end

                S_WAIT_B: begin
                    state <= S_GET_B;
                end

                S_GET_B: begin
                    B <= ii_rdata;
                    state <= S_SET_C;
                end

                S_SET_C: begin
                    ii_raddr <= ii_addr(x0, y1);
                    state <= S_WAIT_C;
                end

                S_WAIT_C: begin
                    state <= S_GET_C;
                end

                S_GET_C: begin
                    C <= ii_rdata;
                    state <= S_SET_D;
                end

                S_SET_D: begin
                    ii_raddr <= ii_addr(x1, y1);
                    state <= S_WAIT_D;
                end

                S_WAIT_D: begin
                    state <= S_GET_D;
                end

                S_GET_D: begin
                    D <= ii_rdata;
                    state <= S_OUT;
                end

                S_OUT: begin
                    // D - B - C + A
                    sum <= $signed({1'b0, D}) - $signed({1'b0, B}) - $signed({1'b0, C}) + $signed({1'b0, A});
                    done <= 1'b1;
                    busy <= 1'b0;
                    state <= S_IDLE;
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule
