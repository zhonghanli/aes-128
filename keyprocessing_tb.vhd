LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

entity keyprocessing_tb is
end entity keyprocessing_tb;

architecture behavior of keyprocessing_tb is
	component keyprocessing is
		port(
			asciikey : in std_logic_vector(7 downto 0);
		  keyormsg, read, full : in std_logic;
		  -- If keyormsg = 0, key. If keyormsg = 1, msg.
		  -- Only send msg if 'full' (from fifo) is 0
		  clock, reset : in std_logic;
		  cipherkey, din : out std_logic_vector(127 downto 0);
		  send_key_out : out std_logic;
		  wr_enable_out : out std_logic
		);
	end component keyprocessing;
	
	signal clock : std_logic := '1';
    signal reset : std_logic;
    constant clk_half_period : time := 1 ns;
    
    signal asciikey : std_logic_vector(7 downto 0);
    signal keyormsg, read, full : std_logic;
    signal cipherkey, din : std_logic_vector(127 downto 0);
    signal send_key_out : std_logic;
	signal wr_enable_out : std_logic;

begin
	dut: keyprocessing port map(asciikey, keyormsg, read, full, clock, reset, cipherkey, din, send_key_out, wr_enable_out);
	clock <= not clock after clk_half_period;
	
	test: process
	begin
	full <= '0';
		-- full key
		reset <= '1';
		wait for 2 ns;
		reset <= '0';
		read <= '1';
		keyormsg <= '0'; -- key
		asciikey <= X"45"; --E
		wait for 2 ns;
		asciikey <= X"45"; --E
		wait for 2 ns;
		asciikey <= X"43"; --C
		wait for 2 ns;
		asciikey <= X"53"; --S
		wait for 2 ns;
		asciikey <= X"20"; -- 
		wait for 2 ns;
		asciikey <= X"33"; --3
		wait for 2 ns;
		asciikey <= X"39"; --9
		wait for 2 ns;
		asciikey <= X"32"; --2
		wait for 2 ns;
		asciikey <= X"20"; -- 
		wait for 2 ns;
		asciikey <= X"6D"; --m
		wait for 2 ns;
		asciikey <= X"69"; --i
		wait for 2 ns;
		asciikey <= X"64"; --d
		wait for 2 ns;
		asciikey <= X"74"; --t
		wait for 2 ns;
		asciikey <= X"65"; --e
		wait for 2 ns;
		asciikey <= X"72"; --r
		wait for 2 ns;
		asciikey <= X"6D"; --m
		wait for 2 ns;
		asciikey <= X"81"; --Enter
		wait for 2 ns;
		read <= '0';
		wait for 50 ns;
		
		-- different key
		reset <= '1';
		wait for 2 ns;
		reset <= '0';
		read <= '1';
		keyormsg <= '0'; -- key
		asciikey <= X"43"; --C
		wait for 2 ns;
		asciikey <= X"48"; --H
		wait for 2 ns;
		asciikey <= X"45"; --E
		wait for 2 ns;
		asciikey <= X"4D"; --M
		wait for 2 ns;
		asciikey <= X"20"; -- 
		wait for 2 ns;
		asciikey <= X"31"; --1
		wait for 2 ns;
		asciikey <= X"30"; --0
		wait for 2 ns;
		asciikey <= X"31"; --1
		wait for 2 ns;
		asciikey <= X"20"; -- 
		wait for 2 ns;
		asciikey <= X"6D"; --m
		wait for 2 ns;
		asciikey <= X"69"; --i
		wait for 2 ns;
		asciikey <= X"64"; --d
		wait for 2 ns;
		asciikey <= X"74"; --t
		wait for 2 ns;
		asciikey <= X"65"; --e
		wait for 2 ns;
		asciikey <= X"72"; --r
		wait for 2 ns;
		asciikey <= X"6D"; --m
		wait for 2 ns;
		asciikey <= X"81"; --Enter
		wait for 2 ns;
		read <= '0';
		wait for 50 ns;
		
		-- partial key
		reset <= '1';
		wait for 2 ns;
		reset <= '0';
		read <= '1';
		keyormsg <= '0'; -- key
		asciikey <= X"45"; --E
		wait for 2 ns;
		asciikey <= X"45"; --E
		wait for 2 ns;
		asciikey <= X"43"; --C
		wait for 2 ns;
		asciikey <= X"53"; --S
		wait for 2 ns;
		asciikey <= X"20"; -- 
		wait for 2 ns;
		asciikey <= X"33"; --3
		wait for 2 ns;
		asciikey <= X"39"; --9
		wait for 2 ns;
		asciikey <= X"32"; --2
		wait for 2 ns;
		asciikey <= X"20"; -- 
		wait for 2 ns;
		asciikey <= X"6D"; --m
		wait for 2 ns;
		asciikey <= X"69"; --i
		wait for 2 ns;
		asciikey <= X"64"; --d
		wait for 2 ns;
		asciikey <= X"81"; --Enter
		wait for 2 ns;
		read <= '0';
		wait for 50 ns;
		
		-- full message - fifo is full
		keyormsg <= '1'; -- msg
		full <= '1';
		reset <= '1';
		wait for 2 ns;
		reset <= '0';
		read <= '1';
		asciikey <= X"47"; --G
		wait for 2 ns;
		asciikey <= X"72"; --r
		wait for 2 ns;
		asciikey <= X"61"; --a
		wait for 2 ns;
		asciikey <= X"64"; --d
		wait for 2 ns;
		asciikey <= X"75"; --u
		wait for 2 ns;
		asciikey <= X"61"; --a
		wait for 2 ns;
		asciikey <= X"74"; --t
		wait for 2 ns;
		asciikey <= X"69"; --i
		wait for 2 ns;
		asciikey <= X"6F"; --o
		wait for 2 ns;
		asciikey <= X"6E"; --n
		wait for 2 ns;
		asciikey <= X"69"; --i
		wait for 2 ns;
		asciikey <= X"73"; --s
		wait for 2 ns;
		asciikey <= X"6E"; --n
		wait for 2 ns;
		asciikey <= X"65"; --e
		wait for 2 ns;
		asciikey <= X"61"; --a
		wait for 2 ns;
		asciikey <= X"72"; --r
		wait for 2 ns;
		asciikey <= X"81"; --Enter
		wait for 2 ns;
		read <= '0';
		wait for 50 ns;
		
		-- full message - fifo is empty
		keyormsg <= '1'; -- msg
		full <= '0';
		reset <= '1';
		wait for 2 ns;
		reset <= '0';
		read <= '1';
		asciikey <= X"47"; --G
		wait for 2 ns;
		asciikey <= X"72"; --r
		wait for 2 ns;
		asciikey <= X"61"; --a
		wait for 2 ns;
		asciikey <= X"64"; --d
		wait for 2 ns;
		asciikey <= X"75"; --u
		wait for 2 ns;
		asciikey <= X"61"; --a
		wait for 2 ns;
		asciikey <= X"74"; --t
		wait for 2 ns;
		asciikey <= X"69"; --i
		wait for 2 ns;
		asciikey <= X"6F"; --o
		wait for 2 ns;
		asciikey <= X"6E"; --n
		wait for 2 ns;
		asciikey <= X"69"; --i
		wait for 2 ns;
		asciikey <= X"73"; --s
		wait for 2 ns;
		asciikey <= X"6E"; --n
		wait for 2 ns;
		asciikey <= X"65"; --e
		wait for 2 ns;
		asciikey <= X"61"; --a
		wait for 2 ns;
		asciikey <= X"72"; --r
		wait for 2 ns;
		asciikey <= X"81"; --Enter
		wait for 2 ns;
		read <= '0';
		wait for 50 ns;
		
		-- partial message - fifo is empty
		keyormsg <= '1'; -- msg
		full <= '0';
		reset <= '1';
		wait for 2 ns;
		reset <= '0';
		read <= '1';
		asciikey <= X"4F"; --O
		wait for 2 ns;
		asciikey <= X"6E"; --n
		wait for 2 ns;
		asciikey <= X"65"; --e
		wait for 2 ns;
		asciikey <= X"20"; -- 
		wait for 2 ns;
		asciikey <= X"6D"; --m
		wait for 2 ns;
		asciikey <= X"6F"; --o
		wait for 2 ns;
		asciikey <= X"6E"; --n
		wait for 2 ns;
		asciikey <= X"74"; --t
		wait for 2 ns;
		asciikey <= X"68"; --h
		wait for 2 ns;
		asciikey <= X"20"; -- 
		wait for 2 ns;
		asciikey <= X"6C"; --l
		wait for 2 ns;
		asciikey <= X"65"; --e
		wait for 2 ns;
		asciikey <= X"66"; --f
		wait for 2 ns;
		asciikey <= X"74"; --t
		wait for 2 ns;
		asciikey <= X"81"; --Enter
		wait for 2 ns;
		read <= '0';
		wait for 50 ns;
		
	end process;


end architecture behavior;