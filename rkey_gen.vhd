LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;


entity rkey_gen is
    port(
        clock : in std_logic;
        reset : in std_logic;
        in_key: in std_logic_vector(127 downto 0);
        out_key : out std_logic_vector(127 downto 0);
        out_ready : out std_logic
    );

end entity rkey_gen;

architecture behavior of rkey_gen is
    type state_type is (s0, s1);
    signal state, next_state : state_type;
    signal temp1 : std_logic_vector(7 downto 0);
    signal temp2 : std_logic_vector(23 downto 0);
    signal shifted_key : std_logic_vector(127 downto 0);

begin
    rk_gen_fsm: process(in_key, state)
    begin
        case(state) is
            when s0 =>
                temp1 <= in_key(31 downto 24);
                temp2 <= in_key(23 downto 0);
                next_state <= s1;
            when s1 =>
                shifted_key(7 downto 0) <= temp1;
                shifted_key(31 downto 8) <= temp2;
                shifted_key(127 downto 32) <= in_key(127 downto 32);
                next_state <= s2;
            when s2 =>
                
        end case;
    end process rk_gen_fsm;

	clock_process : process(clock, reset)
    begin
        if reset = '1' then
            state <= s0;
        elsif ( rising_edge(clock)) then
            state <= next_state;
        end if; 
    end process clock_process;

end architecture behavior;