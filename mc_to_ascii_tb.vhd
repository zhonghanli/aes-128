LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;

entity mc_to_ascii_tb is
end entity mc_to_ascii_tb;

architecture behavior of mc_to_ascii_tb is
	component mc_to_ascii is
		port(
			clock : in std_logic;
			reset : in std_logic;
			read : out std_logic;
			hist3 : in std_logic_vector(7 downto 0);
			hist2 : in std_logic_vector(7 downto 0);
			hist1 : in std_logic_vector(7 downto 0);
			hist0 : in std_logic_vector(7 downto 0);
			asciikey : out std_logic_vector(7 downto 0)
		);
	end component mc_to_ascii;
	
signal clock : std_logic := '1';
signal reset : std_logic;
signal read : std_logic;
signal hist3 : std_logic_vector(7 downto 0);
signal hist2 : std_logic_vector(7 downto 0);
signal hist1 : std_logic_vector(7 downto 0);
signal hist0 : std_logic_vector(7 downto 0);
signal asciikey : std_logic_vector(7 downto 0);
constant clk_half_period : time := 1 ns;

begin
	dut: mc_to_ascii port map(clock, reset, read, hist3, hist2, hist1, hist0, asciikey);

clock <= not clock after clk_half_period;

test: process
begin
	
	hist3 <= X"00";
	hist2 <= X"00";
	hist1 <= X"00";
	hist0 <= X"00";
	
	-- Letter j
	reset <= '1';
	wait for 2 ns;
	-- reset all hists
	hist3 <= X"00";
	hist2 <= X"00";
	hist1 <= X"00";
	hist0 <= X"00";
	reset <= '0';
	wait for 2 ns;
 	hist0 <= X"3B"; -- j
	wait for 2 ns;
	hist1 <= X"3B";
	hist0 <= X"3B";
	wait for 2 ns;
	hist2 <= X"3B";
	hist1 <= X"F0";
	hist0 <= X"3B";
	wait for 20 ns;
	
	-- Letter k
	reset <= '1';
	wait for 2 ns;
	-- reset all hists
	hist3 <= X"00";
	hist2 <= X"00";
	hist1 <= X"00";
	hist0 <= X"00";
	reset <= '0';
	wait for 2 ns;
	hist0 <= X"42"; -- k
	wait for 2 ns;
	hist1 <= X"42";
	hist0 <= X"42";
	wait for 2 ns;
	hist2 <= X"42";
	hist1 <= X"42";
	hist0 <= X"42";
	wait for 2 ns;
	hist3 <= X"42";
	hist2 <= X"42";
	hist1 <= X"42";
	hist0 <= X"42";
	wait for 2 ns;
	hist3 <= X"42";
	hist2 <= X"42";
	hist1 <= X"F0"; -- k released
	hist0 <= X"42";
	wait for 20 ns;
	
	-- Shift key case 1
	reset <= '1';
	wait for 2 ns;
	-- reset all hists
	hist3 <= X"00";
	hist2 <= X"00";
	hist1 <= X"00";
	hist0 <= X"00";
	reset <= '0';
	wait for 2 ns;
	hist0 <= X"12"; -- shift
	wait for 2 ns;
	hist1 <= X"12";
	hist0 <= X"12";
	wait for 2 ns;
	hist2 <= X"12";
	hist1 <= X"12";
	hist0 <= X"12";
	wait for 2 ns;
	hist3 <= X"12";
	hist2 <= X"12";
	hist1 <= X"12";
	hist0 <= X"12";
	wait for 2 ns;
	hist0 <= X"4B";
	wait for 2 ns;
	hist1 <= X"4B";
	hist0 <= X"4B";
	wait for 2 ns;
	hist2 <= X"4B";
	hist1 <= X"4B";
	hist0 <= X"4B";
	wait for 2 ns;
	hist3 <= X"4B";
	hist2 <= X"4B";
	hist1 <= X"4B";
	hist0 <= X"4B";
	wait for 2 ns;
	hist3 <= X"F0";
	hist2 <= X"12";
	hist1 <= X"F0";
	hist0 <= X"4B";
	wait for 20 ns;
	
	-- Shift key case 2
	reset <= '1';
	wait for 2 ns;
	-- reset all hists
	hist3 <= X"00";
	hist2 <= X"00";
	hist1 <= X"00";
	hist0 <= X"00";
	reset <= '0';
	wait for 2 ns;
	hist0 <= X"12"; -- shift
	wait for 2 ns;
	hist1 <= X"12";
	hist0 <= X"12";
	wait for 2 ns;
	hist2 <= X"12";
	hist1 <= X"12";
	hist0 <= X"12";
	wait for 2 ns;
	hist3 <= X"12";
	hist2 <= X"12";
	hist1 <= X"12";
	hist0 <= X"12";
	wait for 2 ns;
	hist0 <= X"3A";
	wait for 2 ns;
	hist1 <= X"3A";
	hist0 <= X"3A";
	wait for 2 ns;
	hist2 <= X"3A";
	hist1 <= X"3A";
	hist0 <= X"3A";
	wait for 2 ns;
	hist3 <= X"3A";
	hist2 <= X"3A";
	hist1 <= X"3A";
	hist0 <= X"3A";
	wait for 2 ns;
	hist3 <= X"F0";
	hist2 <= X"3A";
	hist1 <= X"F0";
	hist0 <= X"12";
	wait for 100 ns;
	
	
	
end process;
	
end architecture behavior;
