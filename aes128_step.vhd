LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity aes128_step is
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
end entity aes128_step;

architecture behavior of aes128_step is
    type state_type is (s0, s1, s2, s3, s4);
    signal state, next_state : state_type;

    type std_array is array(Natural range <>) of std_logic_vector(7 downto 0);
    signal in_vector_arr, roundkey_arr : std_array(15 downto 0);
    signal init_arr, init_arr_c : std_array(15 downto 0);
    signal subByte_arr, subByte_arr_c : std_array(15 downto 0);
    signal roundShift_arr, roundShift_arr_c : std_array(15 downto 0);
    signal mixColumns_arr, mixColumns_arr_c : std_array(15 downto 0);

    --signal done_c : std_logic;


begin
    input_update : process(in_vector, roundkey)
    begin
        for i in 0 to 15 loop
            in_vector_arr(i) <= in_vector((i+1)*8-1 downto i*8);
            roundkey_arr(i) <= roundkey((i+1)*8-1 downto i*8);
        end loop;
    end process input_update;

    aes128_step_fsm : process(start,in_vector, roundkey, in_vector_arr, roundkey_arr, state, subByte_arr, roundShift_arr, mixColumns_arr)
            --variable transpose_arr, temp_rshift : std_array(15 downto 0);
            variable products : std_array(0 to 3);
    begin
        init_arr_c <= init_arr;
        subByte_arr_c <= subByte_arr;
        roundShift_arr_c <= roundShift_arr;
        mixColumns_arr_c <= mixColumns_arr;
        done <= '0';
        case state is
            when s0 =>
                if start = '1' and step = "0000" then
                    out_vector <= in_vector xor roundkey;
                    done <= '1';
                    next_state <= s0;   
                elsif start = '1' then 
                    init_arr_c <= in_vector_arr;
                    next_state <= s1;
                else 
                    next_state <= s0;
                end if;

                -- if step = "0000" then
                --     for i in 0 to 15 loop
                --         init_arr_c(i) <= in_vector_arr(i) xor roundkey_arr(i);
                --     end loop;
                -- else
                --     init_arr_c <= in_vector_arr;
                -- end if;
            when s1 =>
                for i in 0 to 15 loop
                    subByte_arr_c(i) <= subBytes(init_arr(i));
                end loop;
                next_state <= s2;   
            when s2 =>
                --*********manually assigning 16 positions may be simpler than writing loops
                roundShift_arr_c(15) <= subByte_arr(15);
                roundShift_arr_c(2) <= subByte_arr(14);
                roundShift_arr_c(5) <= subByte_arr(13);
                roundShift_arr_c(8) <= subByte_arr(12);
                roundShift_arr_c(11) <= subByte_arr(11);
                roundShift_arr_c(14) <= subByte_arr(10);
                roundShift_arr_c(1) <= subByte_arr(9);
                roundShift_arr_c(4) <= subByte_arr(8);
                roundShift_arr_c(7) <= subByte_arr(7);
                roundShift_arr_c(10) <= subByte_arr(6);
                roundShift_arr_c(13) <= subByte_arr(5);
                roundShift_arr_c(0) <= subByte_arr(4);
                roundShift_arr_c(3) <= subByte_arr(3);
                roundShift_arr_c(6) <= subByte_arr(2);
                roundShift_arr_c(9) <= subByte_arr(1);
                roundShift_arr_c(12) <= subByte_arr(0);

                --check if last round to skip mixCols
                if step = "1010" then
                    next_state <= s4;
                else
                    next_state <= s3;
                end if;
            when s3 =>
                for i in 3 downto 0 loop
                    for j in 3 downto 0 loop
                        for k in 0 to 3 loop
                            products(k) := mult(roundshift_arr(3+i*4-k),mixCol_const(15-(3-j)-k*4));
                        end loop;            
                        mixColumns_arr_c(i*4+j) <= products(0) xor products(1) xor products(2) xor products(3);
                    end loop;
                end loop;
                next_state <= s4;
            when s4 =>
                if step = "1010" then
                    for i in 15 downto 0 loop
                        out_vector(127-i*8 downto 128-(i+1)*8) <= roundShift_arr(15-i) xor roundkey_arr(15-i);
                    end loop;
                else
                    for i in 15 downto 0 loop
                        out_vector(127-i*8 downto 128-(i+1)*8) <= mixColumns_arr(15-i) xor roundkey_arr(15-i);
                    end loop;
                end if;
                done <= '1';                       
                next_state <= s0;                      
            when others =>
                next_state <= s0;
        end case;
    end process;


    clock_process : process(clock, reset)
    begin
        if reset = '1' then
            state <= s0;
            init_arr <= (others=>(others => '0'));
            subByte_arr <= (others=>(others => '0'));
            roundShift_arr <= (others=>(others => '0'));
            mixColumns_arr <= (others=>(others => '0'));
        elsif ( rising_edge(clock)) then
            state <= next_state;
            init_arr <= init_arr_c;
            subByte_arr <= subByte_arr_c;
            roundShift_arr <= roundShift_arr_c;
            mixColumns_arr <= mixColumns_arr_c;
        end if; 

    end process clock_process;
end architecture behavior;
