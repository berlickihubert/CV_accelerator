module vj_cascade_eval_19x19_3stage #(
    // 3 stages with [1,5,10] weak classifiers => 16 total
    parameter integer ST0_WEAK = 1,
    parameter integer ST1_WEAK = 5,
    parameter integer ST2_WEAK = 10,
    parameter integer TOTAL_WEAK = (ST0_WEAK + ST1_WEAK + ST2_WEAK),

    parameter integer II_W = 321,
    parameter integer ADDR_W = 17,
    parameter integer II_DATA_W = 25,
    parameter integer COORD_W = 6,
    parameter integer THRESH_W = 32,
    parameter integer ALPHA_W  = 16
) (
    input  wire                 clk,
    input  wire                 reset_n,

    input  wire                 start,
    input  wire [9:0]           win_x,
    input  wire [8:0]           win_y,

    output wire [ADDR_W-1:0]    ii_raddr,
    input  wire [II_DATA_W-1:0] ii_rdata,

    input  wire signed [31:0]   stage0_threshold,
    input  wire signed [31:0]   stage1_threshold,
    input  wire signed [31:0]   stage2_threshold,

    output reg                  busy,
    output reg                  done,
    output reg                  pass,

    output reg signed [31:0]    score_out
);

    localparam integer S0_START = 0;
    localparam integer S1_START = S0_START + ST0_WEAK;
    localparam integer S2_START = S1_START + ST1_WEAK;

    localparam integer S0_LAST  = S1_START - 1;
    localparam integer S1_LAST  = S2_START - 1;
    localparam integer S2_LAST  = TOTAL_WEAK - 1;

    wire [2:0] rect_count;

    wire [COORD_W-1:0] rx0, ry0, rw0, rh0;
    wire signed [3:0]  wt0;
    wire [COORD_W-1:0] rx1, ry1, rw1, rh1;
    wire signed [3:0]  wt1;
    wire [COORD_W-1:0] rx2, ry2, rw2, rh2;
    wire signed [3:0]  wt2;
    wire [COORD_W-1:0] rx3, ry3, rw3, rh3;
    wire signed [3:0]  wt3;

    wire signed [THRESH_W-1:0] threshold;
    wire signed [ALPHA_W-1:0]  alpha;
    wire polarity;

    reg [$clog2(TOTAL_WEAK)-1:0] weak_idx;

    vj_feature_rom_19x19 #(
        .NUM_WEAK(TOTAL_WEAK),
        .MAX_RECTS(4),
        .COORD_W(COORD_W),
        .THRESH_W(THRESH_W),
        .ALPHA_W(ALPHA_W)
    ) u_rom (
        .idx(weak_idx),
        .rect_count(rect_count),
        .rx0(rx0), .ry0(ry0), .rw0(rw0), .rh0(rh0), .wt0(wt0),
        .rx1(rx1), .ry1(ry1), .rw1(rw1), .rh1(rh1), .wt1(wt1),
        .rx2(rx2), .ry2(ry2), .rw2(rw2), .rh2(rh2), .wt2(wt2),
        .rx3(rx3), .ry3(ry3), .rw3(rw3), .rh3(rh3), .wt3(wt3),
        .threshold(threshold),
        .alpha(alpha),
        .polarity(polarity)
    );

    reg rect_start;
    reg [9:0] rect_x;
    reg [8:0] rect_y;
    reg [9:0] rect_w;
    reg [8:0] rect_h;

    wire rect_done;
    wire signed [II_DATA_W:0] rect_sum;

    vj_rect_sum #(
        .II_W(II_W),
        .ADDR_W(ADDR_W),
        .II_DATA_W(II_DATA_W)
    ) u_rect_sum (
        .clk(clk),
        .reset_n(reset_n),
        .start(rect_start),
        .x(rect_x),
        .y(rect_y),
        .w(rect_w),
        .h(rect_h),
        .ii_raddr(ii_raddr),
        .ii_rdata(ii_rdata),
        .busy(),
        .done(rect_done),
        .sum(rect_sum)
    );

    localparam S_IDLE   = 4'd0;
    localparam S_RECT0  = 4'd1;
    localparam S_RECT1  = 4'd2;
    localparam S_RECT2  = 4'd3;
    localparam S_RECT3  = 4'd4;
    localparam S_WEAK   = 4'd5;
    localparam S_NEXT   = 4'd6;
    localparam S_STAGE  = 4'd7;
    localparam S_DONE   = 4'd8;

    reg [3:0] state;

    reg [1:0] stage_id;
    reg signed [31:0] stage_score_acc;

    reg signed [II_DATA_W+4:0] feat_acc;
    reg signed [II_DATA_W+4:0] feat_val;

    function signed [II_DATA_W+4:0] apply_wt;
        input signed [II_DATA_W:0] s;
        input signed [3:0] w;
        begin
            apply_wt = $signed(s) * $signed(w);
        end
    endfunction

    task start_rect;
        input [COORD_W-1:0] rx;
        input [COORD_W-1:0] ry;
        input [COORD_W-1:0] rw;
        input [COORD_W-1:0] rh;
        begin
            rect_x <= win_x + {{(10-COORD_W){1'b0}}, rx};
            rect_y <= win_y + {{(9-COORD_W){1'b0}}, ry};
            rect_w <= {{(10-COORD_W){1'b0}}, rw};
            rect_h <= {{(9-COORD_W){1'b0}}, rh};
            rect_start <= 1'b1;
        end
    endtask

    function signed [31:0] stage_threshold_sel;
        input [1:0] sid;
        begin
            case (sid)
                2'd0: stage_threshold_sel = stage0_threshold;
                2'd1: stage_threshold_sel = stage1_threshold;
                default: stage_threshold_sel = stage2_threshold;
            endcase
        end
    endfunction

    function integer stage_last_idx;
        input [1:0] sid;
        begin
            case (sid)
                2'd0: stage_last_idx = S0_LAST;
                2'd1: stage_last_idx = S1_LAST;
                default: stage_last_idx = S2_LAST;
            endcase
        end
    endfunction

    function integer stage_next_start;
        input [1:0] sid;
        begin
            case (sid)
                2'd0: stage_next_start = S1_START;
                2'd1: stage_next_start = S2_START;
                default: stage_next_start = S2_START;
            endcase
        end
    endfunction

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            busy <= 1'b0;
            done <= 1'b0;
            pass <= 1'b0;
            score_out <= 32'sd0;
            state <= S_IDLE;

            stage_id <= 2'd0;
            weak_idx <= '0;
            stage_score_acc <= 32'sd0;

            rect_start <= 1'b0;
            rect_x <= 0; rect_y <= 0; rect_w <= 0; rect_h <= 0;

            feat_acc <= '0;
            feat_val <= '0;
        end else begin
            done <= 1'b0;
            rect_start <= 1'b0;

            case (state)
                S_IDLE: begin
                    busy <= 1'b0;
                    if (start) begin
                        busy <= 1'b1;
                        stage_id <= 2'd0;
                        weak_idx <= S0_START[$clog2(TOTAL_WEAK)-1:0];
                        stage_score_acc <= 32'sd0;
                        score_out <= 32'sd0;
                        state <= S_RECT0;
                    end
                end

                S_RECT0: begin
                    feat_acc <= '0;
                    if (rect_count != 3'd0) begin
                        start_rect(rx0, ry0, rw0, rh0);
                        state <= S_RECT1;
                    end else begin
                        state <= S_WEAK;
                    end
                end

                S_RECT1: begin
                    if (rect_done) begin
                        feat_acc <= feat_acc + apply_wt(rect_sum, wt0);
                        if (rect_count >= 3'd2) begin
                            start_rect(rx1, ry1, rw1, rh1);
                            state <= S_RECT2;
                        end else begin
                            state <= S_WEAK;
                        end
                    end
                end

                S_RECT2: begin
                    if (rect_done) begin
                        feat_acc <= feat_acc + apply_wt(rect_sum, wt1);
                        if (rect_count >= 3'd3) begin
                            start_rect(rx2, ry2, rw2, rh2);
                            state <= S_RECT3;
                        end else begin
                            state <= S_WEAK;
                        end
                    end
                end

                S_RECT3: begin
                    if (rect_done) begin
                        feat_acc <= feat_acc + apply_wt(rect_sum, wt2);
                        if (rect_count >= 3'd4) begin
                            start_rect(rx3, ry3, rw3, rh3);
                            state <= S_WEAK;
                        end else begin
                            state <= S_WEAK;
                        end
                    end
                end

                S_WEAK: begin
                    if (rect_count == 3'd4) begin
                        if (rect_done) begin
                            feat_val <= feat_acc + apply_wt(rect_sum, wt3);
                            state <= S_NEXT;
                        end
                    end else begin
                        feat_val <= feat_acc;
                        state <= S_NEXT;
                    end
                end

                S_NEXT: begin
                    begin : weak_calc
                        reg signed [II_DATA_W+4:0] diff;
                        reg pred;
                        reg signed [31:0] alpha_ext;
                        reg signed [31:0] delta;

                        diff = feat_val - $signed(threshold);
                        pred = polarity ? (diff >= 0) : (diff <= 0);

                        alpha_ext = {{(32-ALPHA_W){alpha[ALPHA_W-1]}}, alpha};
                        delta = pred ? alpha_ext : -alpha_ext;
                        stage_score_acc <= stage_score_acc + delta;
                    end

                    if (weak_idx == stage_last_idx(stage_id)) begin
                        state <= S_STAGE;
                    end else begin
                        weak_idx <= weak_idx + 1'b1;
                        state <= S_RECT0;
                    end
                end

                S_STAGE: begin
                    if (stage_score_acc >= stage_threshold_sel(stage_id)) begin
                        if (stage_id == 2'd2) begin
                            pass <= 1'b1;
                            score_out <= stage_score_acc;
                            state <= S_DONE;
                        end else begin
                            stage_id <= stage_id + 2'd1;
                            weak_idx <= stage_next_start(stage_id);
                            stage_score_acc <= 32'sd0;
                            state <= S_RECT0;
                        end
                    end else begin
                        pass <= 1'b0;
                        score_out <= stage_score_acc;
                        state <= S_DONE;
                    end
                end

                S_DONE: begin
                    done <= 1'b1;
                    busy <= 1'b0;
                    state <= S_IDLE;
                end

                default: state <= S_IDLE;
            endcase
        end
    end

endmodule
