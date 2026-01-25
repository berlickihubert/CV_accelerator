module vga_controller(
    input wire clk,
    input wire reset_n,
    input wire [7:0] vram_data,
    input wire [9:0] box_valid,
    input wire [99:0] box_x,
    input wire [89:0] box_y,
    input wire [99:0] box_w,
    input wire [89:0] box_h,
    output wire [16:0] vram_addr,
    output reg hsync,
    output reg vsync,
    output reg [7:0] vga_r,
    output reg [7:0] vga_g,
    output reg [7:0] vga_b,
    output reg vga_blank_n,
    output wire vga_sync_n, // disabled
    output wire vga_clk
);
    // https://ocw.mit.edu/ans7870/6/6.111/s04/NEWKIT/vga.htm
    parameter H_ACTIVE  = 640;  // active pixels per row
    parameter H_FRONT   = 16;   // interval between active and hsync
    parameter H_SYNC    = 96;   // hsync width 
    parameter H_BACK    = 48;   // interval to the next active row
    parameter H_TOTAL   = 800;

    // parameter V_ACTIVE  = 480;
    // parameter V_FRONT   = 10;
    // parameter V_SYNC    = 2;
    // parameter V_BACK    = 33;
    // parameter V_TOTAL   = 525;

    parameter V_ACTIVE  = 480;
    parameter V_FRONT   = 11;
    parameter V_SYNC    = 2;
    parameter V_BACK    = 31;
    parameter V_TOTAL   = 525;

    reg [9:0] h_cnt;
    reg [9:0] v_cnt;

    assign vga_clk = clk; 
    assign vga_sync_n = 1'b0; 

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            h_cnt <= 0;
        else begin
            if (h_cnt == H_TOTAL - 1)
                h_cnt <= 0;
            else
                h_cnt <= h_cnt + 1;
        end
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            v_cnt <= 0;
        else begin
            if (h_cnt == H_TOTAL - 1) begin
                if (v_cnt == V_TOTAL - 1)
                    v_cnt <= 0;
                else
                    v_cnt <= v_cnt + 1;
            end
        end
    end


    
    wire [16:0] addr_calc;
    wire active_area_raw;

    wire [9:0] pix_x;
    wire [8:0] pix_y;
    assign pix_x = h_cnt[9:1];
    assign pix_y = v_cnt[9:1];
    
    assign active_area_raw = (h_cnt < H_ACTIVE) && (v_cnt < V_ACTIVE);
    assign addr_calc = (active_area_raw) ? (pix_y * 320 + pix_x) : 17'd0;
    
    assign vram_addr = addr_calc;


    wire [9:0] box_border_i;
    genvar bi;
    generate
        for (bi = 0; bi < 10; bi = bi + 1) begin : gen_boxes
            wire bvalid;
            wire [9:0] bx;
            wire [8:0] by;
            wire [9:0] bw;
            wire [8:0] bh;

            wire [9:0] bx2;
            wire [8:0] by2;

            assign bvalid = box_valid[bi];
            assign bx = box_x[bi*10 +: 10];
            assign by = box_y[bi*9 +: 9];
            assign bw = box_w[bi*10 +: 10];
            assign bh = box_h[bi*9 +: 9];

            assign bx2 = bx + bw - 10'd1;
            assign by2 = by + bh - 9'd1;

            wire in_box_x = (pix_x >= bx) && (pix_x <= bx2);
            wire in_box_y = (pix_y >= by) && (pix_y <= by2);

            wire on_left   = (pix_x == bx) && in_box_y;
            wire on_right  = (pix_x == bx2) && in_box_y;
            wire on_top    = (pix_y == by) && in_box_x;
            wire on_bottom = (pix_y == by2) && in_box_x;

            assign box_border_i[bi] = bvalid && active_area_raw && (on_left || on_right || on_top || on_bottom);
        end
    endgenerate

    wire box_border = |box_border_i;

    wire hsync_curr, vsync_curr, blank_curr;
    
    assign hsync_curr = ~((h_cnt >= (H_ACTIVE + H_FRONT)) && (h_cnt < (H_ACTIVE + H_FRONT + H_SYNC)));
    assign vsync_curr = ~((v_cnt >= (V_ACTIVE + V_FRONT)) && (v_cnt < (V_ACTIVE + V_FRONT + V_SYNC)));
    assign blank_curr = active_area_raw; 

    reg [1:0] hsync_shift_register;
    reg [1:0] vsync_shift_register;
    reg [1:0] blank_shift_register;

    always @(posedge clk or negedge reset_n) begin
        hsync_shift_register <= {hsync_curr, 1'b0};
        vsync_shift_register <= {vsync_curr, 1'b0};
        blank_shift_register <= {blank_curr, 1'b0};

        // if (!reset_n) begin
        //     hsync_shift_register <= 2'b11;
        //     vsync_shift_register <= 2'b11;
        //     blank_shift_register <= 2'b00;
        // end else begin
        //     hsync_shift_register <= {hsync_shift_register[0], hsync_curr};
        //     vsync_shift_register <= {vsync_shift_register[0], vsync_curr};
        //     blank_shift_register <= {blank_shift_register[0], blank_curr};
        // end
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            hsync <= 1'b1;
            vsync <= 1'b1;
            vga_blank_n <= 1'b0;
            vga_r <= 8'b0;
            vga_g <= 8'b0;
            vga_b <= 8'b0;
        end else begin
            hsync <= hsync_shift_register[1];
            vsync <= vsync_shift_register[1];
            vga_blank_n <= blank_shift_register[1];
            
            if (blank_shift_register[1]) begin
                if (box_border) begin
                    vga_r <= 8'hFF;
                    vga_g <= 8'h00;
                    vga_b <= 8'h00;
                end else begin
                    vga_r <= vram_data;
                    vga_g <= vram_data;
                    vga_b <= vram_data;
                end
            end else begin
                vga_r <= 8'b0;
                vga_g <= 8'b0;
                vga_b <= 8'b0;
            end
        end
    end

endmodule
