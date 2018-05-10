LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;


entity keyexpansion is
	port(
		signal clock : in std_logic;
		signal reset : in std_logic;
		signal cipher_key : in std_logic_vector(127 downto 0);
		signal start : in std_logic;
		signal keyset : out quadword_arr(0 to 10) -- defined in constants
	);
end entity keyexpansion;


architecture behavior of keyexpansion is
	component rkey_gen is
		port(
			clock : in std_logic;
			reset : in std_logic;
			step : in std_logic_vector(3 downto 0);
			in_key: in std_logic_vector(127 downto 0);
			out_key : out std_logic_vector(127 downto 0);
			start : in std_logic;
			done : out std_logic
		);
	
	end component rkey_gen;

	signal keys : quadword_arr(0 to 9);
	signal step_arr : fourbit_arr(0 to 10);
	signal start_vector : std_logic_vector(0 to 9);

begin
	keyset(0) <= cipher_key;
	keyset(1 to 10) <= keys;
	step_arr <= step_arr_const(1 to 11);

	gen_rk_gen : for i in 0 to 9 generate
		first_bit: if i=0 generate
			rkg0 : rkey_gen port map( 
				clock,
				reset,
				step_arr(i),
				cipher_key,
				keys(i),
				start,
				start_vector(i)
			);				
		end generate;

		other_bits: if i > 0 generate
			rkg : rkey_gen port map( 
				clock,
				reset,
				step_arr(i),
				keys(i-1),
				keys(i),
				start_vector(i-1),
				start_vector(i)	
			);
		end generate;
	end generate gen_rk_gen;



end architecture behavior;
