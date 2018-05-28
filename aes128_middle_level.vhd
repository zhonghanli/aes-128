LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity aes128_middle_level is
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
end entity aes128_middle_level;

architecture structural of aes128_middle_level is

    component mc_to_ascii is
        port( 	clock : in std_logic;
                reset : in std_logic;
                read : out std_logic;
                hist3 : in std_logic_vector(7 downto 0);
                hist2 : in std_logic_vector(7 downto 0);
                hist1 : in std_logic_vector(7 downto 0);
                hist0 : in std_logic_vector(7 downto 0);
                asciikey : out std_logic_vector(7 downto 0)
            );
    end component mc_to_ascii;

    component keyprocessing is
        port(  asciikey : in std_logic_vector(7 downto 0);
            keyormsg, read, full : in std_logic;
            clock, reset : in std_logic;
            cipherkey, din : out std_logic_vector(127 downto 0);
            send_key_out : out std_logic;
            wr_enable_out : out std_logic
        );
    end component keyprocessing;

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

    component aes128_full is
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
    end component aes128_full;

    component keyexpansion is
        port(
            signal clock : in std_logic;
            signal reset : in std_logic;
            signal cipher_key : in std_logic_vector(127 downto 0);
            signal start : in std_logic;
            signal keyset : out quadword_arr(0 to 10) -- defined in constants
        );
    end component keyexpansion;

    signal mc2asciiread: std_logic;
    signal full1, empty1, send1, wr_en1, rd_en1: std_logic;
    signal asciikey : std_logic_vector(7 downto 0);
    signal cipherkey, din, dout_fifo : std_logic_vector(127 downto 0);
    signal keyset: quadword_arr(0 to 10);
begin
    
    mc_to_ascii_component: mc_to_ascii port map(clock, reset, mc2asciiread, hist3, hist2, hist1, hist0, asciikey);
    keyprocess_component: keyprocessing port map(asciikey, keyormsg, mc2asciiread, full1, clock, reset, cipherkey, din, send1, wr_en1);
    keyexpansion_component: keyexpansion port map(clock, reset, cipherkey, send1, keyset);
    data2aes_fifo: fifo port map(clock,clock, reset, rd_en1, wr_en1, din, dout_fifo, full1, empty1);
    aes128_full_component: aes128_full port map(clock, reset, full1, din, rd_en1, keyset, output_fifo_full, dout, wr_en);

end architecture structural;