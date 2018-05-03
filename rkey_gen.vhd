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
    type state_type is (s0, s1, s2, s3, s4);
    signal state, next_state : state_type;

    
    type std_array is array(Natural range <>) of std_logic_vector(7 downto 0);
    signal roundshifted_arr, roundshifted_arr_c : std_array(3 downto 0);
    signal subByte_arr, subByte_arr_c : std_array(3 downto 0);
    signal rcon_arr, rcon_arr_c : std_array(3 downto 0);
    signal in_key_arr : std_array(15 downto 0);

    signal output_vector, output_vector_c : std_logic_vector(127 downto 0);


begin

    in_key_update : process(in_key)
    begin
        for i in 0 to 15 loop
            in_key_arr(i) <= in_key((i+1)*8-1 downto i*8);
        end loop;
    end process in_key_update;

    rk_gen_fsm: process(in_key, state, roundshifted_arr, subByte_arr, rcon_arr, output_vector)
        variable temp_out : std_logic_vector(127 downto 0);

    begin
        roundshifted_arr_c <= roundshifted_arr;
        subByte_arr_c <= subByte_arr;
        rcon_arr_c <= rcon_arr;
        output_vector_c <= output_vector;

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
                rcon_arr_c(3) <= subByte_arr(3) xor rcon(255 - to_integer(unsigned(step)));
                for i in 0 to 2 loop
                    rcon_arr_c(i) <= subByte_arr(i);
                end loop;  
                next_state <= s3;      
            when s3 =>
                for i in 0 to 3 loop
                    temp_out(127-i*8 downto 128-(i+1)*8) := in_key(127-i*8 downto 128-(i+1)*8) xor rcon_arr(3-i);
                end loop;
                temp_out(95 downto 64) := in_key(95 downto 64) xor temp_out(127 downto 96);
                temp_out(63 downto 32) := in_key(63 downto 32) xor temp_out(95 downto 64);
                temp_out(31 downto 0) := in_key(31 downto 0) xor temp_out(63 downto 32);
                out_key <= temp_out;
                next_state <= s4;
            when s4 =>
                            

            when others =>
                

                
        end case;
    end process rk_gen_fsm;

	clock_process : process(clock, reset)
    begin
        if reset = '1' then
            state <= s0;
            roundshifted_arr <= (others=>(others => '0'));
            subByte_arr <= (others=>(others => '0'));
            rcon_arr <= (others=>(others => '0'));
            output_vector <= (others => '0');
        elsif ( rising_edge(clock)) then
            state <= next_state;
            state <= next_state;
            roundshifted_arr <= roundshifted_arr_c;
            subByte_arr <= subByte_arr_c;
            rcon_arr <= rcon_arr_c;
            output_vector <= output_vector_c;
        end if; 

    end process clock_process;

end architecture behavior;