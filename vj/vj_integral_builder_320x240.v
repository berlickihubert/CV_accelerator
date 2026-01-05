module vj_integral_builder_320x240 #(
    parameter IMG_W = 320,
    parameter IMG_H = 240,
    parameter II_W  = 321,
    parameter II_H  = 241,
    parameter ADDR_W = 17,
    parameter II_DATA_W = 32
) (
    input  wire                 clk,
    input  wire                 reset_n,

    input  wire                 frame_start,

    input  wire                 pixel_valid,
    input  wire [7:0]           pixel,

    output reg                  ii_we,
    output reg  [ADDR_W-1:0]    ii_waddr,
    output reg  [II_DATA_W-1:0] ii_wdata,

    output reg                  busy,
    output reg                  frame_done
);

    localparam integer II_STRIDE = II_W;
    localparam integer TOTAL_BORDER_WRITES = (II_W + II_H);

    reg [II_DATA_W-1:0] prev_row_ii [0:IMG_W];

    reg [9:0] x;
    reg [8:0] y;
    reg [II_DATA_W-1:0] row_sum;

    reg [17:0] init_cnt;
    reg init_phase;

    integer i;

    wire [ADDR_W-1:0] addr_row0 = init_cnt[ADDR_W-1:0];
    wire [ADDR_W-1:0] addr_col0 = (init_cnt - II_W) * II_STRIDE;
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            ii_we <= 1'b0;
            ii_waddr <= {ADDR_W{1'b0}};
            ii_wdata <= {II_DATA_W{1'b0}};
            busy <= 1'b0;
            frame_done <= 1'b0;

            x <= 10'd0;
            y <= 9'd0;
            row_sum <= {II_DATA_W{1'b0}};

            init_cnt <= 18'd0;
            init_phase <= 1'b0;

            for (i = 0; i <= IMG_W; i = i + 1) begin
                prev_row_ii[i] <= {II_DATA_W{1'b0}};
            end
        end else begin
            ii_we <= 1'b0;
            frame_done <= 1'b0;

            if (frame_start) begin
                busy <= 1'b1;
                init_phase <= 1'b1;
                init_cnt <= 18'd0;

                x <= 10'd0;
                y <= 9'd0;
                row_sum <= {II_DATA_W{1'b0}};

                for (i = 0; i <= IMG_W; i = i + 1) begin
                    prev_row_ii[i] <= {II_DATA_W{1'b0}};
                end
            end

            if (busy) begin
                if (init_phase) begin
                    ii_we <= 1'b1;
                    ii_wdata <= {II_DATA_W{1'b0}};

                    if (init_cnt < II_W) begin
                        ii_waddr <= addr_row0;
                    end else begin
                        ii_waddr <= addr_col0;
                    end

                    init_cnt <= init_cnt + 18'd1;
                    if (init_cnt == (TOTAL_BORDER_WRITES - 1)) begin
                        init_phase <= 1'b0;
                    end
                end else begin
                    if (pixel_valid) begin
                        row_sum <= row_sum + {{(II_DATA_W-8){1'b0}}, pixel};

                        begin : calc
                            reg [II_DATA_W-1:0] row_sum_next;
                            reg [II_DATA_W-1:0] ii_curr;
                            reg [ADDR_W-1:0] waddr;

                            row_sum_next = row_sum + {{(II_DATA_W-8){1'b0}}, pixel};
                            ii_curr = prev_row_ii[x+1] + row_sum_next;

                            prev_row_ii[x+1] <= ii_curr;

                            waddr = ((y + 9'd1) * II_STRIDE) + (x + 10'd1);
                            ii_we <= 1'b1;
                            ii_waddr <= waddr;
                            ii_wdata <= ii_curr;
                        end

                        if (x == (IMG_W - 1)) begin
                            x <= 10'd0;
                            row_sum <= {II_DATA_W{1'b0}};
                            if (y == (IMG_H - 1)) begin
                                y <= 9'd0;
                                busy <= 1'b0;
                                frame_done <= 1'b1;
                            end else begin
                                y <= y + 9'd1;
                            end
                        end else begin
                            x <= x + 10'd1;
                        end
                    end
                end
            end
        end
    end

endmodule
