LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity aes128_top_level is
    port(
        signal clock : in std_logic;
        signal reset : in std_logic;
        signal keyormsg : in std_logic;
        signal keyboard_clk : in std_logic;
        signal keyboard_data : in std_logic;
        signal output_fifo_full : in std_logic;
        signal wr_en : out std_logic;
        signal dout : out std_logic_vector(127 downto 0)

    );
end entity aes128_top_level;

architecture structural of aes128_top_level is
    component ps2 is
        port( 	keyboard_clk, keyboard_data, clock_50MHz ,
                reset : in std_logic;--, read : in std_logic;
                scan_code : out std_logic_vector( 7 downto 0 );
                scan_readyo : out std_logic;
                hist3 : out std_logic_vector(7 downto 0);
                hist2 : out std_logic_vector(7 downto 0);
                hist1 : out std_logic_vector(7 downto 0);
                hist0 : out std_logic_vector(7 downto 0);
                asciikey : out std_logic_vector(7 downto 0)
            );
    end component ps2;

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

    signal scan_code, hist3, hist2, hist1, hist0 : std_logic_vector(7 downto 0);
    signal scan_readyo : std_logic;
    asciikey : std_logic_vector(7 downto 0);

begin
end architecture structural;