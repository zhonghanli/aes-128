LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity output_control_tb is
end entity output_control_tb;

architecture behavioral of output_control_tb is
    component fifo is
        generic
        (
            constant FIFO_DATA_WIDTH : integer := 128;
            constant FIFO_BUFFER_SIZE : integer := 32
        );
        port
        (
            signal rd_clk : in std_logic;
            signal wr_clk : in std_logic;
            signal reset : in std_logic;
            signal rd_en : in std_logic;
            signal wr_en : in std_logic;
            signal din : in std_logic_vector ((FIFO_DATA_WIDTH - 1) downto 0);
            signal dout : out std_logic_vector ((FIFO_DATA_WIDTH - 1) downto 0);
            signal full : out std_logic;
            signal empty : out std_logic
        );
    end component fifo;

    component output_control is
        port(
            clock, reset, nextd : in std_logic;
            fifo_empty : in std_logic;
            din: in std_logic_vector(127 downto 0);
            rd_en : out std_logic;
            dout : out std_logic_vector(127 downto 0)
        );
    end component output_control;

    signal clock : std_logic := '1';
    signal reset : std_logic;
    constant clk_half_period : time := 1 ns;

    signal nextd, rd_en, wr_en, full, empty : std_logic;
    signal din, dout, result : std_logic_vector(127 downto 0);
begin
    clock <= not clock after clk_half_period;

    fifo_test: fifo port map(
        clock,
        clock,
        reset,
        rd_en,
        wr_en,
        din, 
        dout,
        full, 
        empty
    );

    dut: output_control port map(
        clock,
        reset,
        nextd,
        empty,
        dout,
        rd_en,
        result
    );

    test: process
    begin
        reset <= '1';
        nextd <= '0';
        wait for 2 ns;
        reset <= '0';

        wr_en <= '1';
        din <= x"5468617473206D79204B756E67204675";
        wait for 2 ns;
        wr_en<= '0';
        wait for 2 ns;
        wr_en <= '1';
        din <= x"E232FCF191129188B159E4E6D679A293";
        wait for 2 ns;
        wr_en <= '0';
        wait for 5 ns;
        nextd<= '1';
        wait for 10 ns;
        nextd<= '0';
        wait for 5 ns;
        nextd <= '1';
        wait for 10 ns;
        nextd <= '0';
    end process;

end architecture behavioral;