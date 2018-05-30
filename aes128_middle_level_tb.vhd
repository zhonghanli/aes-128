LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity aes128_middle_level_tb is
end entity aes128_middle_level_tb;

architecture behavior of aes128_middle_level_tb is

    component aes128_middle_level is
    	port(
    	signal clock : in std_logic;
        signal reset : in std_logic;
        signal keyormsg : in std_logic;
        signal hist3 : in std_logic_vector(7 downto 0);
        signal hist2 : in std_logic_vector(7 downto 0);
        signal hist1 : in std_logic_vector(7 downto 0);
        signal hist0 : in std_logic_vector(7 downto 0);
        signal output_fifo_full : in std_logic;
        signal wr_en : out std_logic;
        signal dout : out std_logic_vector(127 downto 0)
    	);
    end component aes128_middle_level;

signal clock : std_logic := '1';
signal reset : std_logic;
signal keyormsg : std_logic;
signal hist3 : std_logic_vector(7 downto 0);
signal hist2 : std_logic_vector(7 downto 0);
signal hist1 : std_logic_vector(7 downto 0);
signal hist0 : std_logic_vector(7 downto 0);
signal output_fifo_full : std_logic;
signal wr_en : std_logic;
signal dout : std_logic_vector(127 downto 0);
constant clk_half_period : time := 1 ns;

begin
	dut: aes128_middle_level port map(clock, reset, keyormsg, hist3, hist2, hist1, hist0, output_fifo_full, wr_en, dout);
	    
	clock <= not clock after clk_half_period;

	test: process
	begin
	
	-- Key:
	-- H 33, e 24, r 2D, m 3A, i 43, o 44, n 31, e 24, space 29
	-- G 34, r 2D, a 1C, n 31, g 34, e 24, r 2D 
	-- Shift: 12 or 59
	
	-- Message:
	-- E 24, x 22, p 4D, e 24, c 21, t 2C, o 44, space 29
	-- p 4D, a 1C, t 2C, r 2D, o 44, n 31, u 3C, m 3A

	reset <= '0';
	reset <= '1';
	wait for 2 ns;
	hist3 <= X"00";
	hist2 <= X"00";
	hist1 <= X"00";
	hist0 <= X"00";
	reset <= '0';
	wait for 2 ns;
	output_fifo_full <= '0';
	keyormsg <= '0'; -- cipherkey
	wait for 2 ns;
	
	-- Hermione
	hist0 <= X"12"; -- shift pressed
	wait for 2 ns;
	hist1 <= X"12";
	hist0 <= X"12"; -- shift held down
	wait for 2 ns;
	hist2 <= X"12";
	hist1 <= X"12";
	hist0 <= X"12"; -- shift held down
	wait for 2 ns;
	hist3 <= X"12";
	hist2 <= X"12";
	hist1 <= X"12";
	hist0 <= X"12"; -- shift held down
	wait for 2 ns;
	hist0 <= X"33"; -- h pressed concurrently
	wait for 2 ns;
	hist1 <= X"33";
	hist0 <= X"33";
	wait for 2 ns;
	hist2 <= X"33";
	hist1 <= X"33";
	hist0 <= X"33";
	wait for 2 ns;
	hist3 <= X"33";
	hist2 <= X"33";
	hist1 <= X"33";
	hist0 <= X"33";
	wait for 2 ns;
	hist3 <= X"F0";
	hist2 <= X"12";
	hist1 <= X"F0";
	hist0 <= X"33"; -- test: H released after shift released
	wait for 2 ns;
	hist3 <= X"12";
	hist2 <= X"F0";
	hist1 <= X"33";
	hist0 <= X"24"; -- e pressed
	wait for 2 ns;
	hist3 <= X"F0";
	hist2 <= X"33";
	hist1 <= X"24";
	hist0 <= X"24"; -- test: e held down
	wait for 2 ns;
	hist3 <= X"24";
	hist2 <= X"24";
	hist1 <= X"F0";
	hist0 <= X"24"; -- e released
	wait for 2 ns;
	hist3 <= X"24";
	hist2 <= X"F0";
	hist1 <= X"24";
	hist0 <= X"2D"; -- r pressed
	wait for 2 ns;
	hist3 <= X"24";
	hist2 <= X"2D";
	hist1 <= X"F0";
	hist0 <= X"2D"; -- r released
	wait for 2 ns;
	hist3 <= X"2D";
	hist2 <= X"F0";
	hist1 <= X"2D";
	hist0 <= X"3A"; -- m pressed
	wait for 2 ns;
	hist3 <= X"2D";
	hist2 <= X"3A";
	hist1 <= X"F0";
	hist0 <= X"3A"; -- m released
	wait for 2 ns;
	hist3 <= X"3A";
	hist2 <= X"F0";
	hist1 <= X"3A";
	hist0 <= X"43"; -- i pressed
	wait for 2 ns;
	hist3 <= X"3A";
	hist2 <= X"43";
	hist1 <= X"F0";
	hist0 <= X"43"; -- i released
	wait for 2 ns;
	hist3 <= X"43";
	hist2 <= X"F0";
	hist1 <= X"43";
	hist0 <= X"44"; -- o pressed
	wait for 2 ns;
	hist3 <= X"43";
	hist2 <= X"44";
	hist1 <= X"F0";
	hist0 <= X"44"; -- o released
	wait for 2 ns;
	hist3 <= X"44";
	hist2 <= X"F0";
	hist1 <= X"44";
	hist0 <= X"31"; -- n pressed
	wait for 2 ns;
	hist3 <= X"44";
	hist2 <= X"31";
	hist1 <= X"F0";
	hist0 <= X"31"; -- n released
	wait for 2 ns;
	hist3 <= X"31";
	hist2 <= X"F0";
	hist1 <= X"31";
	hist0 <= X"24"; -- e pressed
	wait for 2 ns;
	hist3 <= X"31";
	hist2 <= X"24";
	hist1 <= X"F0";
	hist0 <= X"24"; -- e released
	wait for 2 ns;
	hist3 <= X"24";
	hist2 <= X"F0";
	hist1 <= X"24";
	hist0 <= X"29"; -- space pressed
	wait for 2 ns;
	hist3 <= X"24";
	hist2 <= X"29";
	hist1 <= X"F0";
	hist0 <= X"29"; -- space released
	wait for 2 ns;
	
	-- Granger
	
	hist3 <= X"29";
	hist2 <= X"F0";
	hist1 <= X"29";
	hist0 <= X"12"; -- shift pressed
	wait for 2 ns;
	hist3 <= X"F0";
	hist2 <= X"29";
	hist1 <= X"12";
	hist0 <= X"12"; -- shift held down
	wait for 2 ns;
	hist3 <= X"29";
	hist2 <= X"12";
	hist1 <= X"12";
	hist0 <= X"12"; -- shift held down
	wait for 2 ns;
	hist3 <= X"12";
	hist2 <= X"12";
	hist1 <= X"12";
	hist0 <= X"34"; -- g pressed concurrently
	wait for 2 ns;
	hist3 <= X"F0";
	hist2 <= X"34";
	hist1 <= X"F0";
	hist0 <= X"12"; -- test: G released before shift released
	wait for 2 ns;
	hist3 <= X"34";
	hist2 <= X"F0";
	hist1 <= X"12";
	hist0 <= X"2D"; -- r pressed
	wait for 2 ns;
	hist3 <= X"12";
	hist2 <= X"2D";
	hist1 <= X"F0";
	hist0 <= X"2D"; -- r released
	wait for 2 ns;
	hist3 <= X"2D";
	hist2 <= X"F0";
	hist1 <= X"2D";
	hist0 <= X"1C"; -- a pressed
	wait for 2 ns;
	hist3 <= X"2D";
	hist2 <= X"1C";
	hist1 <= X"F0";
	hist0 <= X"1C"; -- a released
	wait for 2 ns;
	hist3 <= X"1D";
	hist2 <= X"F0";
	hist1 <= X"1D";
	hist0 <= X"31"; -- n pressed
	wait for 2 ns;
	hist3 <= X"44";
	hist2 <= X"31";
	hist1 <= X"F0";
	hist0 <= X"31"; -- n released
	wait for 2 ns;
	hist3 <= X"31";
	hist2 <= X"F0";
	hist1 <= X"31";
	hist0 <= X"34"; -- g pressed
	wait for 2 ns;
	hist3 <= X"31";
	hist2 <= X"34";
	hist1 <= X"F0";
	hist0 <= X"34"; -- g released
	wait for 2 ns;
	hist3 <= X"34";
	hist2 <= X"F0";
	hist1 <= X"34";
	hist0 <= X"24"; -- e pressed
	wait for 2 ns;
	hist3 <= X"33";
	hist2 <= X"24";
	hist1 <= X"F0";
	hist0 <= X"24"; -- e released
	wait for 2 ns;
	hist3 <= X"24";
	hist2 <= X"F0";
	hist1 <= X"24";
	hist0 <= X"2D"; -- r pressed
	wait for 2 ns;
	hist3 <= X"24";
	hist2 <= X"2D";
	hist1 <= X"F0";
	hist0 <= X"2D"; -- r released
	wait for 2 ns;
	hist3 <= X"2D";
	hist2 <= X"F0";
	hist1 <= X"2D";
	hist0 <= X"5A"; -- Enter pressed
	wait for 2 ns;
	hist3 <= X"2D";
	hist2 <= X"5A";
	hist1 <= X"F0";
	hist0 <= X"5A"; -- Enter released
	wait for 10 ns;
	
	-- Message: Expecto patronum
	keyormsg <= '1';
	-- Expecto
	hist3 <= X"5A";
	hist2 <= X"F0";
	hist1 <= X"5A";
	hist0 <= X"12"; -- shift pressed
	wait for 2 ns;
	hist3 <= X"F0";
	hist2 <= X"5A";
	hist1 <= X"12";
	hist0 <= X"12"; -- shift held down
	wait for 2 ns;
	hist3 <= X"5A";
	hist2 <= X"12";
	hist1 <= X"12";
	hist0 <= X"12"; -- shift held down
	wait for 2 ns;
	hist3 <= X"12";
	hist2 <= X"12";
	hist1 <= X"12";
	hist0 <= X"12"; -- shift held down
	wait for 2 ns;
	hist0 <= X"24"; -- e pressed
	wait for 2 ns;
	hist3 <= X"F0";
	hist2 <= X"12";
	hist1 <= X"F0";
	hist0 <= X"24"; -- E released after shift released
	wait for 2 ns;
	hist3 <= X"12";
	hist2 <= X"F0";
	hist1 <= X"24";
	hist0 <= X"22"; -- x pressed
	wait for 2 ns;
	hist3 <= X"24";
	hist2 <= X"22";
	hist1 <= X"F0";
	hist0 <= X"22"; -- x released
	wait for 2 ns;
	hist3 <= X"22";
	hist2 <= X"F0";
	hist1 <= X"22";
	hist0 <= X"4D"; -- p pressed
	wait for 2 ns;
	hist3 <= X"22";
	hist2 <= X"4D";
	hist1 <= X"F0";
	hist0 <= X"4D"; -- p released
	wait for 2 ns;
	hist3 <= X"4D";
	hist2 <= X"F0";
	hist1 <= X"4D";
	hist0 <= X"24"; -- e pressed
	wait for 2 ns;
	hist3 <= X"4D";
	hist2 <= X"24";
	hist1 <= X"F0";
	hist0 <= X"24"; -- e released
	wait for 2 ns;
	hist3 <= X"24";
	hist2 <= X"F0";
	hist1 <= X"24";
	hist0 <= X"21"; -- c pressed
	wait for 2 ns;
	hist3 <= X"24";
	hist2 <= X"21";
	hist1 <= X"F0";
	hist0 <= X"21"; -- c released
	wait for 2 ns;
	hist3 <= X"21";
	hist2 <= X"F0";
	hist1 <= X"21";
	hist0 <= X"2C"; -- t pressed
	wait for 2 ns;
	hist3 <= X"21";
	hist2 <= X"2C";
	hist1 <= X"F0";
	hist0 <= X"2C"; -- t released
	wait for 2 ns;
	hist3 <= X"2C";
	hist2 <= X"F0";
	hist1 <= X"2C";
	hist0 <= X"44"; -- o pressed
	wait for 2 ns;
	hist3 <= X"2C";
	hist2 <= X"44";
	hist1 <= X"F0";
	hist0 <= X"44"; -- o released
	wait for 2 ns;
	hist3 <= X"44";
	hist2 <= X"F0";
	hist1 <= X"44";
	hist0 <= X"29"; -- space pressed
	wait for 2 ns;
	hist3 <= X"44";
	hist2 <= X"29";
	hist1 <= X"F0";
	hist0 <= X"29"; -- space released
	wait for 2 ns;
	
	-- patronum
	
	hist3 <= X"29";
	hist2 <= X"F0";
	hist1 <= X"29";
	hist0 <= X"4D"; -- p pressed
	wait for 2 ns;
	hist3 <= X"29";
	hist2 <= X"4D";
	hist1 <= X"F0";
	hist0 <= X"4D"; -- p released
	wait for 2 ns;
	hist3 <= X"4D";
	hist2 <= X"F0";
	hist1 <= X"4D";
	hist0 <= X"1C"; -- a pressed
	wait for 2 ns;
	hist3 <= X"4D";
	hist2 <= X"1C";
	hist1 <= X"F0";
	hist0 <= X"1C"; -- a released
	wait for 2 ns;
	hist3 <= X"1C";
	hist2 <= X"F0";
	hist1 <= X"1C";
	hist0 <= X"2C"; -- t pressed
	wait for 2 ns;
	hist3 <= X"1C";
	hist2 <= X"2C";
	hist1 <= X"F0";
	hist0 <= X"2C"; -- t released
	wait for 2 ns;
	hist3 <= X"2C";
	hist2 <= X"F0";
	hist1 <= X"2C";
	hist0 <= X"2D"; -- r pressed
	wait for 2 ns;
	hist3 <= X"2C";
	hist2 <= X"2D";
	hist1 <= X"F0";
	hist0 <= X"2D"; -- r released
	wait for 2 ns;
	hist3 <= X"2D";
	hist2 <= X"F0";
	hist1 <= X"2D";
	hist0 <= X"44"; -- o pressed
	wait for 2 ns;
	hist3 <= X"2D";
	hist2 <= X"44";
	hist1 <= X"F0";
	hist0 <= X"44"; -- o released
	wait for 2 ns;
	hist3 <= X"44";
	hist2 <= X"F0";
	hist1 <= X"44";
	hist0 <= X"31"; -- n pressed
	wait for 2 ns;
	hist3 <= X"44";
	hist2 <= X"31";
	hist1 <= X"F0";
	hist0 <= X"31"; -- n released
	wait for 2 ns;
	hist3 <= X"31";
	hist2 <= X"F0";
	hist1 <= X"31";
	hist0 <= X"3C"; -- u pressed
	wait for 2 ns;
	hist3 <= X"31";
	hist2 <= X"3C";
	hist1 <= X"F0";
	hist0 <= X"3C"; -- u released
	wait for 2 ns;
	hist3 <= X"3C";
	hist2 <= X"F0";
	hist1 <= X"3C";
	hist0 <= X"3A"; -- m pressed
	wait for 2 ns;
	hist3 <= X"3C";
	hist2 <= X"3A";
	hist1 <= X"F0";
	hist0 <= X"3A"; -- m released
	wait for 2 ns;
	hist3 <= X"3A";
	hist2 <= X"F0";
	hist1 <= X"3A";
	hist0 <= X"5A"; -- Enter pressed
	wait for 2 ns;
	hist3 <= X"3A";
	hist2 <= X"5A";
	hist1 <= X"F0";
	hist0 <= X"5A"; -- Enter released
	
	wait for 800 ns;

	end process;
end architecture behavior;