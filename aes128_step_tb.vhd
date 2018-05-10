LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity aes128_step_tb is
end entity aes128_step_tb;

architecture behavior of aes128_step_tb is
    component aes128_step is
        port(
            signal clock : in std_logic;
            signal reset : in std_logic;
            signal start : in std_logic;
            signal step : in std_logic_vector(3 downto 0);
            signal in_vector : in std_logic_vector(127 downto 0);
            signal roundkey : in std_logic_vector(127 downto 0);
            signal out_vector : out std_logic_vector(127 downto 0);
            signal done : out std_logic
        );
    end component aes128_step;

    signal clock : std_logic := '1';
    signal reset,start_tb, done : std_logic;
    constant clk_half_period : time := 1 ns;

    signal step : std_logic_vector(3 downto 0);
    signal in_vector, roundkey, out_vector : std_logic_vector(127 downto 0);
begin
    clock <= not clock after clk_half_period;

    dut : aes128_step port map(
        clock,
        reset,
        start_tb,
        step,
        in_vector,
        roundkey,
        out_vector,
        done
    );

    test: process
    begin
        reset <= '1';
        step <= "0001";
        start_tb <= '0';
        roundkey <= x"E232FCF191129188B159E4E6D679A293";
        in_vector <= x"001F0E543C4E08596E221B0B4774311A";
        wait for 2 ns;
        reset <= '0';
        wait for 2 ns;
        start_tb <= '1';
        wait for 2 ns;
        start_tb <= '0';

        wait for 100 ns;


        reset <= '1';
        step <= "0000";
        start_tb <= '0';
        roundkey <= x"5468617473206D79204B756E67204675";
        in_vector <= x"54776F204F6E65204E696E652054776F";
        wait for 2 ns;
        reset <= '0';
        wait for 2 ns;
        start_tb <= '1';
        wait for 2 ns;
        start_tb <= '0';

        wait for 100 ns;

        

    end process test;

end architecture behavior;