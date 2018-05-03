LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity rkey_gen is
    port(
        clock : in std_logic;
        reset : in std_logic;
        step : std_logic_vector(3 downto 0);
        in_key: in std_logic_vector(127 downto 0);
        out_key : out std_logic_vector(127 downto 0);
        out_ready : out std_logic
    );

end entity rkey_gen;

architecture behavior of rkey_gen is
    type state_type is (s0, s1, s2, s3);
    signal state, next_state : state_type;

    
    type std_array is array(Natural range <>) of std_logic_vector(7 downto 0);
    signal roundshifted_arr, roundshifted_arr_c : std_array(0 to 3);
    signal subByte_arr, subByte_arr_c : std_array(0 to 3);
    signal rcon_arr, rcon_arr_c : std_array(0 to 3);
    signal in_key_arr : std_array(15 downto 0);
    
    --step for rcon
    signal step : std_logic_vector(3 downto 0);
begin

    in_key_update : process(in_key)
    begin
        for i in 0 to 15 loop
            in_key_arr(i) <= in_key((i+1)*8-1 downto i*8);
        end loop;
    end process in_key_update;

    rk_gen_fsm: process(in_key, state, roundshifted_arr)
        variable new_lastword : std_logic_vector(31 downto 0);
    begin
        roundshifted_arr_c <= roundshifted_arr;
        subByte_arr_c <= subByte_arr;
        rcon_arr_c <= rcon_arr;

        case(state) is
            when s0 => 
                roundshifted_arr_c <= in_key_arr(2 downto 0) & in_key_arr(3);
                next_state<=s1;
            when s1 =>
                for i in 0 to 3 loop
                    subByte_arr_c(i) <= subBytes(roundshifted_arr(i));
                end loop;
                next_state <= s2;
            when s2 =>
                rcon_arr_c(3) <= subByte_arr_c(3) xor rcon(to_integer(unsigned(step));
            when s3 =>

                -- shifted_key(31 downto 24) <= subBytes(temp2(23 downto 16));
                -- next_state <= s3;
            -- when s3 =>
            --     shifted_key <= unsigned(shifted_key) xor rcon(1);  
        end case;
    end process rk_gen_fsm;

	clock_process : process(clock, reset)
    begin
        if reset = '1' then
            state <= s0;
            roundshifted_arr <= (others=>(others => '0'));
            subByte_arr <= (others=>(others => '0'));
            rcon_arr <= (others=>(others => '0'));
        elsif ( rising_edge(clock)) then
            state <= next_state;
            state <= next_state;
            roundshifted_arr <= roundshifted_arr_c;
            subByte_arr <= subByte_arr_c;
            rcon_arr <= rcon_arr_c;
        end if; 

    end process clock_process;

end architecture behavior;