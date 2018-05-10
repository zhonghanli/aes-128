LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity aes128_full_tb is
end entity aes128_full_tb;

architecture behavior of aes128_full_tb is
    component aes128_full is
        port(
            clock : in std_logic;
            reset : in std_logic;
            input_fifo_empty: in std_logic;
            input_fifo_data : in std_logic_vector(127 downto 0);
            rd_en : out std_logic;
            roundkeys : in quadword_arr(0 to 10);
            output_fifo_full : in std_logic;
            output_fifo_data : out std_logic_vector(127 downto 0);
            wr_en : out std_logic
        );
    end component aes128_full;


    constant clk_half_period : time := 1 ns;
    signal clock: std_logic:= '0';
    signal reset, input_fifo_empty, rd_en, output_fifo_full, wr_en : std_logic;
    signal input_fifo_data, output_fifo_data : std_logic_vector(127 downto 0);
    signal roundkeys : quadword_arr(0 to 10);
begin   
    clock <= not clock after clk_half_period;

    dut: aes128_full port map(
        clock,
        reset,
        input_fifo_empty,
        input_fifo_data,
        rd_en,
        roundkeys,
        output_fifo_full,
        output_fifo_data,
        wr_en
    );
    
    test : process
    begin
        reset <= '0';
        input_fifo_empty <= '0';
        input_fifo_data <= X"54776F204F6E65204E696E652054776F"; 
        roundkeys(0 to 10) <= (
            x"5468617473206D79204B756E67204675",
            x"E232FCF191129188B159E4E6D679A293",
            x"56082007C71AB18F76435569A03AF7FA",
            x"D2600DE7157ABC686339E901C3031EFB",
            x"A11202C9B468BEA1D75157A01452495B",
            x"B1293B3305418592D210D232C6429B69",
            x"BD3DC2B7B87C47156A6C9527AC2E0E4E",
            x"CC96ED1674EAAA031E863F24B2A8316A",
            x"8E51EF21FABB4522E43D7A0656954B6C",
            x"BFE2BF904559FAB2A16480B4F7F1CBD8",
            x"28FDDEF86DA4244ACCC0A4FE3B316F26"
        );
        output_fifo_full <= '0';

        wait for 10 ns;

        reset <= '0';
    end process;

    
end architecture behavior;