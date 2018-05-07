LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity keyprocessing_tb is
end entity keyprocessing_tb;

architecture behavior of processing_tb is
	component keyprocessing is
		port(
			asciikey : in std_logic_vector(7 downto 0);
		  keyormsg, read, full : in std_logic;
		  -- If keyormsg = 0, key. If keyormsg = 1, msg.
		  -- Only send msg if 'full' (from fifo) is 0
		  clock, reset : in std_logic;
		  cipherkey, din : out std_logic_vector(127 downto 0);
		  send_key : out std_logic;
		  wr_enable : out std_logic
		);
	end component keyprocessing;
	
	signal clock : std_logic := '1';
    signal reset : std_logic;
    constant clk_half_period : time := 1 ns;
    
    signal asciikey : std_logic_vector(7 downto 0);
    signal keyormsg, read, full : in std_logic;
    signal cipherkey, din : out std_logic_vector(127 downto 0);
    signal send_key : out std_logic;
	signal wr_enable : out std_logic;

begin
	dut: keyprocessing port map(asciikey, keyormsg, read, full, clock, reset, cipherkey, din, send_key, wr_enable);
	clock <= not clock after clk_half_period;
	
	test: process
	begin
		reset <= '1';
		reset <= '0';
		read <= '1';
		keyormsg <= '0'; -- key
		asciikey <= X"45"; --E
		wait for 5 ns;
		asciikey <= X"45"; --E
		wait for 5 ns;
		asciikey <= X"43"; --C
		wait for 5 ns;
		asciikey <= X"53"; --S
		wait for 5 ns;
		asciikey <= X"20"; -- 
		wait for 5 ns;
		asciikey <= X"33"; --3
		wait for 5 ns;
		asciikey <= X"39"; --9
		wait for 5 ns;
		asciikey <= X"32"; --2
		wait for 5 ns;
		asciikey <= X"20"; -- 
		wait for 5 ns;
		asciikey <= X"6D"; --m
		wait for 5 ns;
		asciikey <= X"69"; --i
		wait for 5 ns;
		asciikey <= X"64"; --d
		wait for 5 ns;
		asciikey <= X"74"; --t
		wait for 5 ns;
		asciikey <= X"65"; --e
		wait for 5 ns;
		asciikey <= X"72"; --r
		wait for 5 ns;
		asciikey <= X"6D"; --m
		wait for 5 ns;
		asciikey <= X"81"; --Enter
		wait for 20ns;

	
	end process;


end architecture behavior;