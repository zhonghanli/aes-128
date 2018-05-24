LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity output_control is
    port(
        clock, reset, nextd : in std_logic;
        fifo_empty : in std_logic;
        din: in std_logic_vector(127 downto 0);
        rd_en : out std_logic;
        dout : out std_logic_vector(127 downto 0)
    );
end entity output_control;

architecture behavior of output_control is
    type state_type is (s0, s1);
    signal state, next_state : state_type;
begin
    clock_process : process(clock, reset)
    begin
        if reset = '1' then
            state <= s0;
        elsif (rising_edge(clock)) then
            state <= next_state;
        end if; 
    end process clock_process;

    fsm_process : process(nextd, fifo_empty, state)
    begin
        rd_en <= '0';
        case state is
            when s0 =>
                if fifo_empty = '0' and nextd = '1' then
                    rd_en <= '1';
                    next_state <= s1;
                    dout <= din;
                else 
                    rd_en <= '0';
                    next_state <= s0;
                    dout <= (others=> '0');
                end if;
            when s1 =>
                if nextd <= '0' then
                    next_state<=s0;
                else 
                    next_state <= s1;
                end if;            
        end case;
    end process fsm_process;
end architecture behavior;