LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity rkey_gen_tb is
end entity rkey_gen_tb;

architecture behavior of rkey_gen_tb is 
    component rkey_gen is
        port(
            clock : in std_logic;
            reset : in std_logic;
            step : std_logic_vector(3 downto 0);
            in_key: in std_logic_vector(127 downto 0);
            out_key : out std_logic_vector(127 downto 0);
            start : in std_logic;
            done : out std_logic
        );
    end component rkey_gen;

    signal clock : std_logic := '1';
    signal reset : std_logic;
    constant clk_half_period : time := 1 ns;

    signal step : std_logic_vector(3 downto 0);
    signal in_key_tb, out_key_tb, out_key1 : std_logic_vector(127 downto 0);
    signal done_tb, start_tb : std_logic;

begin
    dut : rkey_gen port map(clock, reset, step, in_key_tb, out_key_tb, start_tb, done_tb);

    clock <= not clock after clk_half_period;

    test: process
    begin
        reset <= '1';
        in_key_tb <= X"5468617473206D79204B756E67204675";
        step <= "0001";
        start_tb <= '0';
        wait for 2 ns;
        start_tb <= '1';
        reset <= '0'; 
        wait for 2 ns;
        start_tb <= '0';
        wait for 20 ns;

        -- in_key_tb <= out_key_tb;
        -- step <= "0010";
        -- reset <= '1';
        -- wait for 5 ns;
        -- reset <= '0';
        -- wait for 20 ns;

        -- in_key_tb <= out_key_tb;
        -- step <= "0011";
        -- reset <= '1';
        -- wait for 5 ns;
        -- reset <= '0';
        -- wait for 20 ns;

        -- in_key_tb <= out_key_tb;
        -- step <= "0100";
        -- reset <= '1';
        -- wait for 5 ns;
        -- reset <= '0';
        -- wait for 20 ns;

        -- in_key_tb <= out_key_tb;
        -- step <= "0101";
        -- reset <= '1';
        -- wait for 5 ns;
        -- reset <= '0';
        -- wait for 20 ns;

        -- in_key_tb <= out_key_tb;
        -- step <= "0110";
        -- reset <= '1';
        -- wait for 5 ns;
        -- reset <= '0';
        -- wait for 20 ns;

        -- in_key_tb <= out_key_tb;
        -- step <= "0111";
        -- reset <= '1';
        -- wait for 5 ns;
        -- reset <= '0';
        -- wait for 20 ns;

        -- in_key_tb <= out_key_tb;
        -- step <= "1000";
        -- reset <= '1';
        -- wait for 5 ns;
        -- reset <= '0';
        -- wait for 20 ns;

        -- in_key_tb <= out_key_tb;
        -- step <= "1001";
        -- reset <= '1';
        -- wait for 5 ns;
        -- reset <= '0';
        -- wait for 20 ns;

        -- in_key_tb <= out_key_tb;
        -- step <= "1010";
        -- reset <= '1';
        -- wait for 5 ns;
        -- reset <= '0';
        -- wait for 20 ns;

  
    end process;

end architecture behavior;