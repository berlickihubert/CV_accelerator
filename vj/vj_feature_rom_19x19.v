module vj_feature_rom_19x19 #(
    parameter integer NUM_WEAK = 16,
    parameter integer MAX_RECTS = 4,
    parameter integer COORD_W = 6,
    parameter integer THRESH_W = 32,
    parameter integer ALPHA_W  = 16
) (
    input  wire [$clog2(NUM_WEAK)-1:0] idx,

    output reg  [2:0] rect_count,

    output reg  [COORD_W-1:0] rx0, ry0, rw0, rh0,
    output reg  signed [3:0]  wt0,

    output reg  [COORD_W-1:0] rx1, ry1, rw1, rh1,
    output reg  signed [3:0]  wt1,

    output reg  [COORD_W-1:0] rx2, ry2, rw2, rh2,
    output reg  signed [3:0]  wt2,

    output reg  [COORD_W-1:0] rx3, ry3, rw3, rh3,
    output reg  signed [3:0]  wt3,

    output reg  signed [THRESH_W-1:0] threshold,
    output reg  signed [ALPHA_W-1:0]  alpha,
    output reg                        polarity
);



    always @(*) begin
        rect_count = 3'd0;

        rx0 = '0; ry0 = '0; rw0 = '0; rh0 = '0; wt0 = 0;
        rx1 = '0; ry1 = '0; rw1 = '0; rh1 = '0; wt1 = 0;
        rx2 = '0; ry2 = '0; rw2 = '0; rh2 = '0; wt2 = 0;
        rx3 = '0; ry3 = '0; rw3 = '0; rh3 = '0; wt3 = 0;

        threshold = '0;
        alpha = 16'sd256;
        polarity = 1'b1;

        case (idx)
            0: begin
                rect_count = 3'd2;
                rx0 = 1; ry0 = 3; rw0 = 1; rh0 = 3; wt0 = 1;
                rx1 = 1; ry1 = 6; rw1 = 1; rh1 = 3; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd61;
                alpha = 16'sd208;
                polarity = 1'b0;
            end
            1: begin
                rect_count = 3'd2;
                rx0 = 1; ry0 = 3; rw0 = 1; rh0 = 3; wt0 = 1;
                rx1 = 1; ry1 = 6; rw1 = 1; rh1 = 3; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd61;
                alpha = 16'sd208;
                polarity = 1'b0;
            end
            2: begin
                rect_count = 3'd2;
                rx0 = 10; ry0 = 12; rw0 = 1; rh0 = 1; wt0 = 1;
                rx1 = 10; ry1 = 13; rw1 = 1; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd9;
                alpha = 16'sd193;
                polarity = 1'b0;
            end
            3: begin
                rect_count = 3'd2;
                rx0 = 13; ry0 = 0; rw0 = 1; rh0 = 1; wt0 = 1;
                rx1 = 13; ry1 = 1; rw1 = 1; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd24;
                alpha = 16'sd203;
                polarity = 1'b1;
            end
            4: begin
                rect_count = 3'd2;
                rx0 = 3; ry0 = 17; rw0 = 1; rh0 = 1; wt0 = 1;
                rx1 = 3; ry1 = 18; rw1 = 1; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd2;
                alpha = 16'sd191;
                polarity = 1'b1;
            end
            5: begin
                rect_count = 3'd2;
                rx0 = 17; ry0 = 5; rw0 = 1; rh0 = 1; wt0 = 1;
                rx1 = 17; ry1 = 6; rw1 = 1; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd16;
                alpha = 16'sd173;
                polarity = 1'b0;
            end
            6: begin
                rect_count = 3'd2;
                rx0 = 7; ry0 = 0; rw0 = 1; rh0 = 2; wt0 = 1;
                rx1 = 7; ry1 = 2; rw1 = 1; rh1 = 2; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd55;
                alpha = 16'sd181;
                polarity = 1'b1;
            end
            7: begin
                rect_count = 3'd2;
                rx0 = 15; ry0 = 17; rw0 = 1; rh0 = 1; wt0 = 1;
                rx1 = 15; ry1 = 18; rw1 = 1; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd0;
                alpha = 16'sd198;
                polarity = 1'b1;
            end
            8: begin
                rect_count = 3'd2;
                rx0 = 9; ry0 = 12; rw0 = 1; rh0 = 1; wt0 = 1;
                rx1 = 9; ry1 = 13; rw1 = 1; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd14;
                alpha = 16'sd226;
                polarity = 1'b0;
            end
            9: begin
                rect_count = 3'd2;
                rx0 = 9; ry0 = 5; rw0 = 1; rh0 = 1; wt0 = 1;
                rx1 = 9; ry1 = 6; rw1 = 1; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd8;
                alpha = 16'sd276;
                polarity = 1'b1;
            end
            10: begin
                rect_count = 3'd2;
                rx0 = 5; ry0 = 3; rw0 = 1; rh0 = 1; wt0 = 1;
                rx1 = 5; ry1 = 4; rw1 = 1; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd14;
                alpha = 16'sd253;
                polarity = 1'b0;
            end
            11: begin
                rect_count = 3'd2;
                rx0 = 5; ry0 = 15; rw0 = 1; rh0 = 2; wt0 = 1;
                rx1 = 5; ry1 = 17; rw1 = 1; rh1 = 2; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd5;
                alpha = 16'sd224;
                polarity = 1'b0;
            end
            12: begin
                rect_count = 3'd2;
                rx0 = 10; ry0 = 1; rw0 = 1; rh0 = 3; wt0 = 1;
                rx1 = 10; ry1 = 4; rw1 = 1; rh1 = 3; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd30;
                alpha = 16'sd176;
                polarity = 1'b1;
            end
            13: begin
                rect_count = 3'd2;
                rx0 = 13; ry0 = 7; rw0 = 1; rh0 = 1; wt0 = 1;
                rx1 = 13; ry1 = 8; rw1 = 1; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd11;
                alpha = 16'sd189;
                polarity = 1'b1;
            end
            14: begin
                rect_count = 3'd2;
                rx0 = 11; ry0 = 10; rw0 = 1; rh0 = 2; wt0 = 1;
                rx1 = 11; ry1 = 12; rw1 = 1; rh1 = 2; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd14;
                alpha = 16'sd192;
                polarity = 1'b0;
            end
            15: begin
                rect_count = 3'd2;
                rx0 = 8; ry0 = 0; rw0 = 1; rh0 = 1; wt0 = 1;
                rx1 = 8; ry1 = 1; rw1 = 1; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd4;
                alpha = 16'sd231;
                polarity = 1'b1;
            end
            default: begin
                rect_count = 3'd0;
                threshold = 32'sd0;
                alpha = 16'sd0;
                polarity = 1'b1;
            end
        endcase
    end

endmodule
