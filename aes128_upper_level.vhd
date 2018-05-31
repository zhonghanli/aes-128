LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity aes128_upper_level is
    port(
        signal clock : in std_logic;
        signal reset : in std_logic;
        signal keyormsg : in std_logic;
        signal hist3 : in std_logic_vector(7 downto 0);
        signal hist2 : in std_logic_vector(7 downto 0);
        signal hist1 : in std_logic_vector(7 downto 0);
        signal hist0 : in std_logic_vector(7 downto 0);
        signal nextd : in std_logic;
        signal dout : out std_logic_vector(127 downto 0)
    );
end entity aes128_upper_level;

architecture structural of aes128_upper_level is
    component aes128_middle_level is
        port(
            signal clock : in std_logic;
            signal reset : in std_logic;
            signal keyormsg : in std_logic;
            signal hist3 : in std_logic_vector(7 downto 0);
            signal hist2 : in std_logic_vector(7 downto 0);
            signal hist1 : in std_logic_vector(7 downto 0);
            signal hist0 : in std_logic_vector(7 downto 0);
            signal output_fifo_full : in std_logic;
            signal wr_en : out std_logic;
            signal dout : out std_logic_vector(127 downto 0)
        );
    end component aes128_middle_level;

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

    signal wr_en, rd_en, full, empty : std_logic;
    signal fifo_din, fifo_dout : std_logic_vector(127 downto 0);
begin
    mid: aes128_middle_level port map(clock, reset, keyormsg, hist3, hist2, hist1, hist0, full, wr_en, fifo_din);
    ff: fifo port map(clock, clock, reset, rd_en, wr_en, fifo_din, fifo_dout, full, empty);
    oc: output_control port map(clock, reset, nextd, empty, fifo_dout, rd_en, dout);
end architecture structural;