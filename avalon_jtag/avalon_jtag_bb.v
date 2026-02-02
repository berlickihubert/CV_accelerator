
module avalon_jtag (
	clk_clk,
	reset_reset_n,
	AVL_MM_slave_0_avs_s0_address,
	AVL_MM_slave_0_avs_s0_read,
	AVL_MM_slave_0_avs_s0_readdata,
	AVL_MM_slave_0_avs_s0_write,
	AVL_MM_slave_0_avs_s0_writedata,
	AVL_MM_slave_0_avs_s0_waitrequest,
	AVL_MM_slave_0_reset_reset);	

	input		clk_clk;
	input		reset_reset_n;
	output	[16:0]	AVL_MM_slave_0_avs_s0_address;
	output		AVL_MM_slave_0_avs_s0_read;
	input	[7:0]	AVL_MM_slave_0_avs_s0_readdata;
	output		AVL_MM_slave_0_avs_s0_write;
	output	[7:0]	AVL_MM_slave_0_avs_s0_writedata;
	input		AVL_MM_slave_0_avs_s0_waitrequest;
	output		AVL_MM_slave_0_reset_reset;
endmodule
