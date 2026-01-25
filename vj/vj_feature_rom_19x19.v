module vj_feature_rom_19x19 #(
    parameter integer NUM_WEAK = 72,
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



        // Auto-generated
        // stage_params = [2, 5, 10, 15]
        // stage0_threshold_q = -464
        // stage1_threshold_q = -453
        // stage2_threshold_q = -147
        // stage3_threshold_q = 138

        case (idx)
            0: begin
                rect_count = 3'd2;
                rx0 = 9; ry0 = 1; rw0 = 2; rh0 = 9; wt0 = 1;
                rx1 = 11; ry1 = 1; rw1 = 2; rh1 = 9; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd225;
                alpha = 16'sd268;
                polarity = 1'b1;
            end
            1: begin
                rect_count = 3'd2;
                rx0 = 14; ry0 = 3; rw0 = 1; rh0 = 3; wt0 = 1;
                rx1 = 14; ry1 = 6; rw1 = 1; rh1 = 3; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd87;
                alpha = 16'sd195;
                polarity = 1'b0;
            end
            2: begin
                rect_count = 3'd2;
                rx0 = 6; ry0 = 1; rw0 = 2; rh0 = 10; wt0 = 1;
                rx1 = 8; ry1 = 1; rw1 = 2; rh1 = 10; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd281;
                alpha = 16'sd198;
                polarity = 1'b0;
            end
            3: begin
                rect_count = 3'd4;
                rx0 = 1; ry0 = 15; rw0 = 3; rh0 = 2; wt0 = 1;
                rx1 = 4; ry1 = 15; rw1 = 3; rh1 = 2; wt1 = -1;
                rx2 = 1; ry2 = 17; rw2 = 3; rh2 = 2; wt2 = -1;
                rx3 = 4; ry3 = 17; rw3 = 3; rh3 = 2; wt3 = 1;
                threshold = 32'sd79;
                alpha = 16'sd167;
                polarity = 1'b1;
            end
            4: begin
                rect_count = 3'd2;
                rx0 = 6; ry0 = 0; rw0 = 7; rh0 = 2; wt0 = 1;
                rx1 = 6; ry1 = 2; rw1 = 7; rh1 = 2; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd311;
                alpha = 16'sd153;
                polarity = 1'b1;
            end
            5: begin
                rect_count = 3'd2;
                rx0 = 11; ry0 = 9; rw0 = 3; rh0 = 2; wt0 = 1;
                rx1 = 14; ry1 = 9; rw1 = 3; rh1 = 2; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd50;
                alpha = 16'sd140;
                polarity = 1'b0;
            end
            6: begin
                rect_count = 3'd4;
                rx0 = 0; ry0 = 1; rw0 = 1; rh0 = 1; wt0 = 1;
                rx1 = 1; ry1 = 1; rw1 = 1; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 2; rw2 = 1; rh2 = 1; wt2 = -1;
                rx3 = 1; ry3 = 2; rw3 = 1; rh3 = 1; wt3 = 1;
                threshold = -32'sd10;
                alpha = 16'sd129;
                polarity = 1'b0;
            end
            7: begin
                rect_count = 3'd4;
                rx0 = 12; ry0 = 15; rw0 = 3; rh0 = 2; wt0 = 1;
                rx1 = 15; ry1 = 15; rw1 = 3; rh1 = 2; wt1 = -1;
                rx2 = 12; ry2 = 17; rw2 = 3; rh2 = 2; wt2 = -1;
                rx3 = 15; ry3 = 17; rw3 = 3; rh3 = 2; wt3 = 1;
                threshold = -32'sd71;
                alpha = 16'sd161;
                polarity = 1'b0;
            end
            8: begin
                rect_count = 3'd2;
                rx0 = 2; ry0 = 4; rw0 = 13; rh0 = 2; wt0 = 1;
                rx1 = 2; ry1 = 6; rw1 = 13; rh1 = 2; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd423;
                alpha = 16'sd145;
                polarity = 1'b0;
            end
            9: begin
                rect_count = 3'd2;
                rx0 = 0; ry0 = 8; rw0 = 1; rh0 = 2; wt0 = 1;
                rx1 = 1; ry1 = 8; rw1 = 1; rh1 = 2; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd8;
                alpha = 16'sd144;
                polarity = 1'b0;
            end
            10: begin
                rect_count = 3'd4;
                rx0 = 13; ry0 = 0; rw0 = 3; rh0 = 1; wt0 = 1;
                rx1 = 16; ry1 = 0; rw1 = 3; rh1 = 1; wt1 = -1;
                rx2 = 13; ry2 = 1; rw2 = 3; rh2 = 1; wt2 = -1;
                rx3 = 16; ry3 = 1; rw3 = 3; rh3 = 1; wt3 = 1;
                threshold = 32'sd41;
                alpha = 16'sd142;
                polarity = 1'b1;
            end
            11: begin
                rect_count = 3'd2;
                rx0 = 9; ry0 = 4; rw0 = 1; rh0 = 2; wt0 = 1;
                rx1 = 10; ry1 = 4; rw1 = 1; rh1 = 2; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd29;
                alpha = 16'sd119;
                polarity = 1'b1;
            end
            12: begin
                rect_count = 3'd2;
                rx0 = 8; ry0 = 3; rw0 = 1; rh0 = 7; wt0 = 1;
                rx1 = 9; ry1 = 3; rw1 = 1; rh1 = 7; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd88;
                alpha = 16'sd122;
                polarity = 1'b0;
            end
            13: begin
                rect_count = 3'd2;
                rx0 = 0; ry0 = 0; rw0 = 4; rh0 = 1; wt0 = 1;
                rx1 = 4; ry1 = 0; rw1 = 4; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd31;
                alpha = 16'sd107;
                polarity = 1'b0;
            end
            14: begin
                rect_count = 3'd4;
                rx0 = 0; ry0 = 0; rw0 = 1; rh0 = 3; wt0 = 1;
                rx1 = 1; ry1 = 0; rw1 = 1; rh1 = 3; wt1 = -1;
                rx2 = 0; ry2 = 3; rw2 = 1; rh2 = 3; wt2 = -1;
                rx3 = 1; ry3 = 3; rw3 = 1; rh3 = 3; wt3 = 1;
                threshold = -32'sd32;
                alpha = 16'sd103;
                polarity = 1'b0;
            end
            15: begin
                rect_count = 3'd2;
                rx0 = 0; ry0 = 10; rw0 = 1; rh0 = 1; wt0 = 1;
                rx1 = 0; ry1 = 11; rw1 = 1; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd1;
                alpha = 16'sd100;
                polarity = 1'b1;
            end
            16: begin
                rect_count = 3'd2;
                rx0 = 14; ry0 = 0; rw0 = 2; rh0 = 1; wt0 = 1;
                rx1 = 14; ry1 = 1; rw1 = 2; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd16;
                alpha = 16'sd103;
                polarity = 1'b0;
            end
            17: begin
                rect_count = 3'd2;
                rx0 = 9; ry0 = 0; rw0 = 2; rh0 = 6; wt0 = 1;
                rx1 = 11; ry1 = 0; rw1 = 2; rh1 = 6; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd199;
                alpha = 16'sd166;
                polarity = 1'b1;
            end
            18: begin
                rect_count = 3'd2;
                rx0 = 13; ry0 = 0; rw0 = 3; rh0 = 1; wt0 = 1;
                rx1 = 16; ry1 = 0; rw1 = 3; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd38;
                alpha = 16'sd143;
                polarity = 1'b1;
            end
            19: begin
                rect_count = 3'd4;
                rx0 = 4; ry0 = 8; rw0 = 1; rh0 = 1; wt0 = 1;
                rx1 = 5; ry1 = 8; rw1 = 1; rh1 = 1; wt1 = -1;
                rx2 = 4; ry2 = 9; rw2 = 1; rh2 = 1; wt2 = -1;
                rx3 = 5; ry3 = 9; rw3 = 1; rh3 = 1; wt3 = 1;
                threshold = -32'sd5;
                alpha = 16'sd130;
                polarity = 1'b0;
            end
            20: begin
                rect_count = 3'd2;
                rx0 = 4; ry0 = 3; rw0 = 1; rh0 = 3; wt0 = 1;
                rx1 = 4; ry1 = 6; rw1 = 1; rh1 = 3; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd85;
                alpha = 16'sd122;
                polarity = 1'b0;
            end
            21: begin
                rect_count = 3'd4;
                rx0 = 8; ry0 = 5; rw0 = 1; rh0 = 7; wt0 = 1;
                rx1 = 9; ry1 = 5; rw1 = 1; rh1 = 7; wt1 = -1;
                rx2 = 8; ry2 = 12; rw2 = 1; rh2 = 7; wt2 = -1;
                rx3 = 9; ry3 = 12; rw3 = 1; rh3 = 7; wt3 = 1;
                threshold = -32'sd77;
                alpha = 16'sd127;
                polarity = 1'b0;
            end
            22: begin
                rect_count = 3'd2;
                rx0 = 10; ry0 = 8; rw0 = 1; rh0 = 1; wt0 = 1;
                rx1 = 10; ry1 = 9; rw1 = 1; rh1 = 1; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd1;
                alpha = 16'sd118;
                polarity = 1'b0;
            end
            23: begin
                rect_count = 3'd4;
                rx0 = 12; ry0 = 17; rw0 = 2; rh0 = 1; wt0 = 1;
                rx1 = 14; ry1 = 17; rw1 = 2; rh1 = 1; wt1 = -1;
                rx2 = 12; ry2 = 18; rw2 = 2; rh2 = 1; wt2 = -1;
                rx3 = 14; ry3 = 18; rw3 = 2; rh3 = 1; wt3 = 1;
                threshold = -32'sd7;
                alpha = 16'sd121;
                polarity = 1'b0;
            end
            24: begin
                rect_count = 3'd2;
                rx0 = 14; ry0 = 9; rw0 = 4; rh0 = 3; wt0 = 1;
                rx1 = 14; ry1 = 12; rw1 = 4; rh1 = 3; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd53;
                alpha = 16'sd116;
                polarity = 1'b1;
            end
            25: begin
                rect_count = 3'd4;
                rx0 = 13; ry0 = 15; rw0 = 1; rh0 = 1; wt0 = 1;
                rx1 = 14; ry1 = 15; rw1 = 1; rh1 = 1; wt1 = -1;
                rx2 = 13; ry2 = 16; rw2 = 1; rh2 = 1; wt2 = -1;
                rx3 = 14; ry3 = 16; rw3 = 1; rh3 = 1; wt3 = 1;
                threshold = -32'sd7;
                alpha = 16'sd136;
                polarity = 1'b0;
            end
            26: begin
                rect_count = 3'd2;
                rx0 = 5; ry0 = 15; rw0 = 2; rh0 = 2; wt0 = 1;
                rx1 = 5; ry1 = 17; rw1 = 2; rh1 = 2; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = -32'sd22;
                alpha = 16'sd106;
                polarity = 1'b0;
            end
            27: begin
                rect_count = 3'd2;
                rx0 = 11; ry0 = 6; rw0 = 1; rh0 = 7; wt0 = 1;
                rx1 = 12; ry1 = 6; rw1 = 1; rh1 = 7; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd6;
                alpha = 16'sd117;
                polarity = 1'b0;
            end
            28: begin
                rect_count = 3'd3;
                rx0 = 7; ry0 = 0; rw0 = 10; rh0 = 3; wt0 = 1;
                rx1 = 7; ry1 = 3; rw1 = 10; rh1 = 3; wt1 = -1;
                rx2 = 7; ry2 = 6; rw2 = 10; rh2 = 3; wt2 = 1;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd6255;
                alpha = 16'sd117;
                polarity = 1'b1;
            end
            29: begin
                rect_count = 3'd2;
                rx0 = 1; ry0 = 7; rw0 = 1; rh0 = 6; wt0 = 1;
                rx1 = 1; ry1 = 13; rw1 = 1; rh1 = 6; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd44;
                alpha = 16'sd119;
                polarity = 1'b1;
            end
            30: begin
                rect_count = 3'd4;
                rx0 = 8; ry0 = 8; rw0 = 3; rh0 = 2; wt0 = 1;
                rx1 = 11; ry1 = 8; rw1 = 3; rh1 = 2; wt1 = -1;
                rx2 = 8; ry2 = 10; rw2 = 3; rh2 = 2; wt2 = -1;
                rx3 = 11; ry3 = 10; rw3 = 3; rh3 = 2; wt3 = 1;
                threshold = 32'sd4;
                alpha = 16'sd103;
                polarity = 1'b1;
            end
            31: begin
                rect_count = 3'd2;
                rx0 = 16; ry0 = 15; rw0 = 1; rh0 = 4; wt0 = 1;
                rx1 = 17; ry1 = 15; rw1 = 1; rh1 = 4; wt1 = -1;
                rx2 = 0; ry2 = 0; rw2 = 0; rh2 = 0; wt2 = 0;
                rx3 = 0; ry3 = 0; rw3 = 0; rh3 = 0; wt3 = 0;
                threshold = 32'sd4;
                alpha = 16'sd97;
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
