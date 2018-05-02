LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity rk_gen_tb is
end entity rk_gen_tb;

architecture behavior of rkey_gen_tb is 
    component rkey_gen is
        port(
            clock : in std_logic;
            reset : in std_logic;
            in_key: in std_logic_vector(127 downto 0);
            out_key : out std_logic_vector(127 downto 0);
            out_ready : out std_logic
        );
    end component rkey_gen;

    signal clock : std_logic := '1';
    signal reset : std_logic;
    constant clk_half_period : time := 1ps;

    signal in_key_tb, out_key_tb, out_ready_tb : std_logic_vector(127 downto 0);

begin
    dut : rkey_gen port map(clock, reset, in_key_tb, out_key_tb, out_ready_tb);

    clk <= not clk after clk_half_period;

    test: process
    begin
        
    end process;

end architecture behavior;