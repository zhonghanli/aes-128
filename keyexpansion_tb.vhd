LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity keyexpansion_tb is
end entity keyexpansion_tb;

architecture behavior of keyexpansion_tb is
    component keyexpansion is
        port(
            signal clock : in std_logic;
            signal reset : in std_logic;
            signal cipher_key : in std_logic_vector(127 downto 0);
            signal start : in std_logic;
            signal keyset : out quadword_arr(0 to 10) -- defined in constants
        );
    end component keyexpansion;
    signal clock : std_logic := '1';
    signal reset : std_logic;
    constant clk_half_period : time := 1 ns;

    signal cipher_key : std_logic_vector(127 downto 0);
    signal start : std_logic;
    signal keyset : quadword_arr(0 to 10);
begin
    dut : keyexpansion port map(
        clock,
        reset,
        cipher_key,
        start,
        keyset
    );

    clock <= not clock after clk_half_period;

    test:process
    begin
        reset <= '1';
        cipher_key <= X"5468617473206D79204B756E67204675";
        start <= '0';
        wait for 2 ns;
        start <= '1';
        reset <= '0';
        wait for 2 ns;
        start <= '0';

        wait for 500 ns;
    end process test;

end architecture behavior;