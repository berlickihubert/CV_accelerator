module vj_scanner_19x19 #(
    parameter integer IMG_W = 320,
    parameter integer IMG_H = 240,
    parameter integer WIN_W = 19,
    parameter integer WIN_H = 19,
    parameter integer II_W  = 321,
    parameter integer ADDR_W = 17,
    parameter integer II_DATA_W = 25,
    parameter integer ST0_WEAK = 2,
    parameter integer ST1_WEAK = 5,
    parameter integer ST2_WEAK = 10,
    parameter integer ST3_WEAK = 15,
    parameter integer TOPK = 10,
    parameter integer SCAN_STEP_X = 1,
    parameter integer SCAN_STEP_Y = 1,
    parameter integer MIN_SCORE = -1000,
    parameter integer SUPPRESS_DIST = 4
) (
    input  wire                 clk,
    input  wire                 reset_n,

    input  wire                 start,

    output wire [ADDR_W-1:0]    ii_raddr,
    input  wire [II_DATA_W-1:0] ii_rdata,

    input  wire signed [31:0]   stage0_threshold_adj,
    input  wire signed [31:0]   stage1_threshold_adj,
    input  wire signed [31:0]   stage2_threshold_adj,
    input  wire signed [31:0]   stage3_threshold_adj,

    output reg                  busy,
    output reg                  done,

    output reg                  det_valid,
    output reg  [9:0]           det_x,
    output reg  [8:0]           det_y,
    output reg  [9:0]           det_w,
    output reg  [8:0]           det_h
);

    localparam integer MAX_X = IMG_W - WIN_W;
    localparam integer MAX_Y = IMG_H - WIN_H;

    reg [9:0] x;
    reg [8:0] y;

    reg cascade_start;
    wire cascade_done;
    wire cascade_pass;
    wire signed [31:0] cascade_score;

    // Auto-generated
        // stage_params = [2, 5, 10, 15]
        // stage0_threshold_q = -464
        // stage1_threshold_q = -453
        // stage2_threshold_q = -147
        // stage3_threshold_q = 138
    wire signed [31:0] stage0_threshold_base = -32'sd464;
    wire signed [31:0] stage1_threshold_base = -32'sd453;
    wire signed [31:0] stage2_threshold_base = -32'sd147;
    wire signed [31:0] stage3_threshold_base = 32'sd138;

    wire signed [31:0] stage0_threshold = stage0_threshold_base + stage0_threshold_adj;
    wire signed [31:0] stage1_threshold = stage1_threshold_base + stage1_threshold_adj;
    wire signed [31:0] stage2_threshold = stage2_threshold_base + stage2_threshold_adj;
    wire signed [31:0] stage3_threshold = stage3_threshold_base + stage3_threshold_adj;

    vj_cascade_eval_19x19_4stage #(
        .ST0_WEAK(ST0_WEAK),
        .ST1_WEAK(ST1_WEAK),
        .ST2_WEAK(ST2_WEAK),
        .ST3_WEAK(ST3_WEAK),
        .II_W(II_W),
        .ADDR_W(ADDR_W),
        .II_DATA_W(II_DATA_W)
    ) u_cascade (
        .clk(clk),
        .reset_n(reset_n),
        .start(cascade_start),
        .win_x(x),
        .win_y(y),
        .ii_raddr(ii_raddr),
        .ii_rdata(ii_rdata),
        .stage0_threshold(stage0_threshold),
        .stage1_threshold(stage1_threshold),
        .stage2_threshold(stage2_threshold),
        .stage3_threshold(stage3_threshold),
        .busy(),
        .done(cascade_done),
        .pass(cascade_pass),
        .score_out(cascade_score)
    );

    localparam S_IDLE = 2'd0;
    localparam S_RUN  = 2'd1;
    localparam S_OUT  = 2'd2;

    reg [1:0] state;

    reg [TOPK-1:0] best_found;
    reg signed [31:0] best_score [0:TOPK-1];
    reg [9:0] best_x [0:TOPK-1];
    reg [8:0] best_y [0:TOPK-1];
    reg [3:0] out_idx;

    reg emit_valid;
    reg [9:0] emit_x;
    reg [8:0] emit_y;
    reg out_drain;

    integer bi;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= S_IDLE;
            busy <= 1'b0;
            done <= 1'b0;

            x <= 10'd0;
            y <= 9'd0;

            cascade_start <= 1'b0;

            best_found <= {TOPK{1'b0}};
            for (bi = 0; bi < TOPK; bi = bi + 1) begin
                best_score[bi] <= 32'sd0;
                best_x[bi] <= 10'd0;
                best_y[bi] <= 9'd0;
            end
            out_idx <= 4'd0;

            emit_valid <= 1'b0;
            emit_x <= 10'd0;
            emit_y <= 9'd0;
            out_drain <= 1'b0;

            det_valid <= 1'b0;
            det_x <= 10'd0;
            det_y <= 9'd0;
            det_w <= WIN_W;
            det_h <= WIN_H;
        end else begin
            done <= 1'b0;
            det_valid <= 1'b0;
            cascade_start <= 1'b0;

            case (state)
                S_IDLE: begin
                    busy <= 1'b0;
                    if (start) begin
                        busy <= 1'b1;
                        x <= 10'd0;
                        y <= 9'd0;
                        cascade_start <= 1'b1;
                        best_found <= {TOPK{1'b0}};
                        for (bi = 0; bi < TOPK; bi = bi + 1) begin
                            best_score[bi] <= 32'sd0;
                            best_x[bi] <= 10'd0;
                            best_y[bi] <= 9'd0;
                        end
                        out_idx <= 4'd0;
                        emit_valid <= 1'b0;
                        emit_x <= 10'd0;
                        emit_y <= 9'd0;
                        out_drain <= 1'b0;
                        state <= S_RUN;
                    end
                end

                S_RUN: begin
                    if (cascade_done) begin
                        if (cascade_pass) begin
                            begin : insert_best
                                integer j;
                                integer k;
                                reg inserted;
                                reg suppress;
                                reg signed [31:0] cand_score;
                                reg [9:0] cand_x;
                                reg [8:0] cand_y;
                                reg [9:0] dx;
                                reg [8:0] dy;

                                inserted = 1'b0;
                                suppress = 1'b0;
                                cand_score = cascade_score;
                                cand_x = x;
                                cand_y = y;

                                if (cand_score < MIN_SCORE) begin
                                    suppress = 1'b1;
                                end

                                for (j = 0; j < TOPK; j = j + 1) begin
                                    if (best_found[j]) begin
                                        dx = (cand_x > best_x[j]) ? (cand_x - best_x[j]) : (best_x[j] - cand_x);
                                        dy = (cand_y > best_y[j]) ? (cand_y - best_y[j]) : (best_y[j] - cand_y);
                                        if ((dx <= SUPPRESS_DIST) && (dy <= SUPPRESS_DIST) && (cand_score <= best_score[j])) begin
                                            suppress = 1'b1;
                                        end
                                    end
                                end

                                if (!suppress) begin
                                    for (j = 0; j < TOPK; j = j + 1) begin
                                        if (!inserted && (!best_found[j] || (cand_score > best_score[j]))) begin
                                            for (k = TOPK-1; k > j; k = k - 1) begin
                                                best_found[k] <= best_found[k-1];
                                                best_score[k] <= best_score[k-1];
                                                best_x[k] <= best_x[k-1];
                                                best_y[k] <= best_y[k-1];
                                            end
                                            best_found[j] <= 1'b1;
                                            best_score[j] <= cand_score;
                                            best_x[j] <= cand_x;
                                            best_y[j] <= cand_y;
                                            inserted = 1'b1;
                                        end
                                    end
                                end
                            end
                        end

                        begin : advance_pos
                            integer nx;
                            integer ny;
                            nx = x + SCAN_STEP_X;
                            ny = y;
                            if (nx > MAX_X) begin
                                nx = 0;
                                ny = y + SCAN_STEP_Y;
                            end

                            if (ny > MAX_Y) begin
                                state <= S_OUT;
                                out_idx <= 4'd0;
                            end else begin
                                x <= nx[9:0];
                                y <= ny[8:0];
                                cascade_start <= 1'b1;
                            end
                        end
                    end
                end

                S_OUT: begin
                    det_valid <= emit_valid;
                    det_x <= emit_x;
                    det_y <= emit_y;
                    det_w <= WIN_W;
                    det_h <= WIN_H;

                    if (!out_drain) begin
                        if (out_idx < TOPK) begin
                            if (best_found[out_idx]) begin
                                emit_valid <= 1'b1;
                                emit_x <= best_x[out_idx];
                                emit_y <= best_y[out_idx];
                            end else begin
                                emit_valid <= 1'b0;
                            end

                            out_drain <= (out_idx == (TOPK-1));
                            out_idx <= out_idx + 4'd1;
                        end else begin
                            out_drain <= 1'b1;
                            emit_valid <= 1'b0;
                        end
                    end else begin
                        busy <= 1'b0;
                        done <= 1'b1;
                        state <= S_IDLE;
                        out_drain <= 1'b0;
                        emit_valid <= 1'b0;
                    end
                end

                default: state <= S_IDLE;
            endcase
        end
    end

endmodule
