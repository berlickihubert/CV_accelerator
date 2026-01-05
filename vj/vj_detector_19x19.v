module vj_detector_19x19 #(
    parameter integer IMG_W = 320,
    parameter integer IMG_H = 240,
    parameter integer II_W  = 321,
    parameter integer II_H  = 241,
    parameter integer ADDR_W = 17,
    parameter integer II_DATA_W = 25, // 320*240*255 = 19,584,000 < 2^25
    parameter integer ST0_WEAK = 1,
    parameter integer ST1_WEAK = 5,
    parameter integer ST2_WEAK = 10
) (
    input  wire                 clk,
    input  wire                 reset_n,

    input  wire                 frame_start,
    input  wire                 pixel_valid,
    input  wire [7:0]           pixel,

    output wire                 det_valid,
    output wire [9:0]           det_x,
    output wire [8:0]           det_y,
    output wire [9:0]           det_w,
    output wire [8:0]           det_h,

    output wire                 busy
);

    localparam integer II_DEPTH = II_W * II_H;

    wire                 ii_we;
    wire [ADDR_W-1:0]    ii_waddr;
    wire [II_DATA_W-1:0] ii_wdata;

    wire [ADDR_W-1:0]    ii_raddr;
    wire [II_DATA_W-1:0] ii_rdata;

    vj_ii_ram #(
        .ADDR_W(ADDR_W),
        .DATA_W(II_DATA_W),
        .DEPTH(II_DEPTH)
    ) u_ii_ram (
        .clk(clk),
        .we(ii_we),
        .waddr(ii_waddr),
        .wdata(ii_wdata),
        .raddr(ii_raddr),
        .rdata(ii_rdata)
    );

    wire build_busy;
    wire frame_done;

    vj_integral_builder_320x240 #(
        .IMG_W(IMG_W),
        .IMG_H(IMG_H),
        .II_W(II_W),
        .II_H(II_H),
        .ADDR_W(ADDR_W),
        .II_DATA_W(II_DATA_W)
    ) u_builder (
        .clk(clk),
        .reset_n(reset_n),
        .frame_start(frame_start),
        .pixel_valid(pixel_valid),
        .pixel(pixel),
        .ii_we(ii_we),
        .ii_waddr(ii_waddr),
        .ii_wdata(ii_wdata),
        .busy(build_busy),
        .frame_done(frame_done)
    );

    wire scan_busy;
    wire scan_done;

    reg scan_start;

    vj_scanner_19x19 #(
        .IMG_W(IMG_W),
        .IMG_H(IMG_H),
        .WIN_W(19),
        .WIN_H(19),
        .II_W(II_W),
        .ADDR_W(ADDR_W),
        .II_DATA_W(II_DATA_W),
        .ST0_WEAK(ST0_WEAK),
        .ST1_WEAK(ST1_WEAK),
        .ST2_WEAK(ST2_WEAK)
    ) u_scan (
        .clk(clk),
        .reset_n(reset_n),
        .start(scan_start),
        .ii_raddr(ii_raddr),
        .ii_rdata(ii_rdata),
        .busy(scan_busy),
        .done(scan_done),
        .det_valid(det_valid),
        .det_x(det_x),
        .det_y(det_y),
        .det_w(det_w),
        .det_h(det_h)
    );

    assign busy = build_busy | scan_busy;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            scan_start <= 1'b0;
        end else begin
            scan_start <= 1'b0;
            if (frame_done) begin
                scan_start <= 1'b1;
            end
        end
    end

endmodule
