	component avalon_jtag is
		port (
			clk_clk                           : in  std_logic                     := 'X';             -- clk
			reset_reset_n                     : in  std_logic                     := 'X';             -- reset_n
			AVL_MM_slave_0_avs_s0_address     : out std_logic_vector(16 downto 0);                    -- address
			AVL_MM_slave_0_avs_s0_read        : out std_logic;                                        -- read
			AVL_MM_slave_0_avs_s0_readdata    : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- readdata
			AVL_MM_slave_0_avs_s0_write       : out std_logic;                                        -- write
			AVL_MM_slave_0_avs_s0_writedata   : out std_logic_vector(7 downto 0);                     -- writedata
			AVL_MM_slave_0_avs_s0_waitrequest : in  std_logic                     := 'X';             -- waitrequest
			AVL_MM_slave_0_reset_reset        : out std_logic                                         -- reset
		);
	end component avalon_jtag;

	u0 : component avalon_jtag
		port map (
			clk_clk                           => CONNECTED_TO_clk_clk,                           --                   clk.clk
			reset_reset_n                     => CONNECTED_TO_reset_reset_n,                     --                 reset.reset_n
			AVL_MM_slave_0_avs_s0_address     => CONNECTED_TO_AVL_MM_slave_0_avs_s0_address,     -- AVL_MM_slave_0_avs_s0.address
			AVL_MM_slave_0_avs_s0_read        => CONNECTED_TO_AVL_MM_slave_0_avs_s0_read,        --                      .read
			AVL_MM_slave_0_avs_s0_readdata    => CONNECTED_TO_AVL_MM_slave_0_avs_s0_readdata,    --                      .readdata
			AVL_MM_slave_0_avs_s0_write       => CONNECTED_TO_AVL_MM_slave_0_avs_s0_write,       --                      .write
			AVL_MM_slave_0_avs_s0_writedata   => CONNECTED_TO_AVL_MM_slave_0_avs_s0_writedata,   --                      .writedata
			AVL_MM_slave_0_avs_s0_waitrequest => CONNECTED_TO_AVL_MM_slave_0_avs_s0_waitrequest, --                      .waitrequest
			AVL_MM_slave_0_reset_reset        => CONNECTED_TO_AVL_MM_slave_0_reset_reset         --  AVL_MM_slave_0_reset.reset
		);

