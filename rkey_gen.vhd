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
    signal temp1, temp1_c : std_logic_vector(7 downto 0);
    signal temp2 : std_logic_vector(23 downto 0);
    signal shifted_key : std_logic_vector(127 downto 0);
    type std_array is array(Natural range <>) of std_logic_vector(7 downto 0);
    signal temp_arr, temp_arr_c : std_array(0 to 3);
    signal in_key_arr : std_array(0 to 15);
begin

    in_key_update : process(in_key)
    begin
        for i in 0 to 15 loop
            in_key_arr(i) <= in_key((i+1)*8-1 downto i*8);
        end loop;
    end process in_key_update;

    rk_gen_fsm: process(in_key, state, temp_arr)
        variable new_lastword : std_logic_vector(31 downto 0);
    begin
        temp_arr_c <= temp_arr;

        case(state) is
            when s0 => 
                -- temp1_c <= in_key_arr(31 downto 0) rol 8;
                -- temp_arr <= in_key(7 downto 0) & in_key(31 downto 8);
                temp_arr_c <= in_key_arr(0) & in_key_arr(1 to 3);
                next_state<=s1;
                -- temp1 <= in_key(31 downto 24);
                -- temp2 <= in_key(23 downto 0);

            --     next_state <= s1;
            -- when s1 =>
            --     next_state <= s2;     
            -- when s2 =>
            --     shifted_key(31 downto 24) <= subBytes(temp2(23 downto 16));
            --     next_state <= s3;
            -- when s3 =>
            --     shifted_key <= unsigned(shifted_key) xor rcon(1);  
            when s1=> 
        end case;
    end process rk_gen_fsm;

	clock_process : process(clock, reset)
    begin
        if reset = '1' then
            state <= s0;
            temp_arr <= (others=>(others => '0'));
        elsif ( rising_edge(clock)) then
            state <= next_state;
            temp_arr <= temp_arr_c;
        end if; 
    end process clock_process;

end architecture behavior;