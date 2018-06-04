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
    type state_type is (s0, s1, s2);
    signal state, next_state : state_type;

    signal dout_c, dout_o : std_logic_vector(127 downto 0);
    signal rd_en_c : std_logic;
    signal wtf : std_logic;
begin
    clock_process : process(clock, reset)
    begin
        if reset = '1' then
            state <= s0;
            dout_o <= (others=> '0');
        elsif (rising_edge(clock)) then
            state <= next_state;
            dout_o <= dout_c;
        end if; 
    end process clock_process;

    dout <= dout_o;

    fsm_process : process(nextd, fifo_empty, state, din, dout_o)
    begin
        rd_en <= '0';
        dout_c <= dout_o;
		next_state <=state;
        case state is
            when s0 =>
                if nextd = '1' then
                    next_state <= s1;
                else
                    next_state <= s0;
                end if;
            when s1 =>
                if nextd = '0' then
                    next_state <=s2;
                else 
                    next_state <= s1;
                end if;
            when s2 =>
                if fifo_empty = '0' then                    
                    rd_en <= '1';
                    dout_c <= din;
                    next_state <= s0;
                end if; 
            when others =>
                next_state <= s0;           
        end case;
    end process fsm_process;
end architecture behavior;
