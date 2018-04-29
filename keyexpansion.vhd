-- calculates roundkeys from cipher (conducts xor operations) 
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;


entity keyexpansion is
	generic

	port
	(
		signal

end entity keyexpansion;


architecture behavior of keyexpansion is
	TYPE state is (s0,s1,s2);
	signal 

begin
	comb_process : process()
	begin
	end process comb_process

	clocked_process : process(reset,clock)
	begin
		if (reset = '1') then
			state <= 
		elsif (rising_edge(clock)) then
			case (state) is
				when f
	end process clocked_process

end architecture behavior;



-- output: 11 128-bit arrays