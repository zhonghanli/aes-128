LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity aes128_full is
    port(
        clock : in std_logic;
        reset : in std_logic;
        input_fifo_empty: in std_logic;
        input_fifo_data : in std_logic_vector(127 downto 0);
        rd_en : out std_logic;
        roundkeys : in quadword_arr(0 to 10);
        output_fifo_full : in std_logic;
        output_fifo_data : out std_logic_vector(127 downto 0);
        wr_en : out std_logic
    );
end entity aes128_full;

architecture behavior of aes128_full is
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

    signal start_vector : std_logic_vector(0 to 11);
    signal output_vector : quadword_arr(0 to 10);
    signal send, ready : std_logic;
    signal step_arr : fourbit_arr(0 to 10);
begin
    step_arr <= step_arr_const(0 to 10);
    output_fifo_data <= output_vector(10);
    gen_aes128_steps:for i in 0 to 10 generate
        first_step: if i = 0 generate
            initial_step: aes128_step port map(
                clock,
                reset,
                start_vector(i),
                step_arr(i),
                input_fifo_data,
                roundkeys(i),
                output_vector(i),
                start_vector(i+1)
            );
        end generate first_step;

        other_steps: if i>0 generate
            other_steps: aes128_step port map(
                clock,
                reset,
                start_vector(i),
                step_arr(i),
                output_vector(i-1),
                roundkeys(i),
                output_vector(i),
                start_vector(i+1)
            );
        end generate other_steps;
    end generate gen_aes128_steps;

    ready_process: process(input_fifo_empty, start_vector(11), output_vector(10), output_fifo_full, reset)
    begin
        start_vector(0) <= '0';

        case ready is
            when '1' =>
                ready <= '0';
                wr_en <= '0';
                if input_fifo_empty = '0' then
                    start_vector(0) <= '1' ;
                    rd_en <= '1';
                else
                    start_vector(0) <= '0';
                    rd_en <= '0';
                end if;
            when '0' =>
                if start_vector(11) = '1' then
                    ready <= '1';
                    if output_fifo_full = '0' then
                        wr_en <= '1';
                    else 
                        wr_en <= '0';
                    end if;
                else
                    ready<= '0';
                end if;
            when others =>
                ready <= '1';
        end case;
    end process;



end architecture behavior;