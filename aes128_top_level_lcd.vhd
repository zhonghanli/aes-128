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

        signal LCD_RS : out std_logic;
        signal LCD_E : out std_logic;
        signal LCD_ON : out std_logic;
        signal RESET_LED : out std_logic;
        signal SEC_LED : out std_logic;
        signal LCD_RW : buffer std_logic;
        signal DATA_BUS: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);

        signal nextd : in std_logic
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
                hist0 : out std_logic_vector(7 downto 0)
            );
    end component ps2;

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

    component de2lcd IS
	PORT(reset, clk_50Mhz				: IN	STD_LOGIC;
		 LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED		: OUT	STD_LOGIC;
		 LCD_RW						: BUFFER STD_LOGIC;
		 DATA_BUS				: INOUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
         data : in std_logic_vector(127 downto 0)
		 );
		 
    END component de2lcd;

    component output_control is
        port(
            clock, reset, nextd : in std_logic;
            fifo_empty : in std_logic;
            din: in std_logic_vector(127 downto 0);
            rd_en : out std_logic;
            dout : out std_logic_vector(127 downto 0)
        );
    end component output_control;

    signal scan_code, hist3, hist2, hist1, hist0 : std_logic_vector(7 downto 0);
    signal scan_readyo, mc2asciiread: std_logic;
    signal full1, empty1, send1, wr_en1, rd_en1: std_logic;
    signal asciikey : std_logic_vector(7 downto 0);
    signal cipherkey, din, dout_fifo : std_logic_vector(127 downto 0);
    signal keyset: quadword_arr(0 to 10);
    signal full2, wr_en2, rd_en2, empty2: std_logic;
    signal message_out, lcd_message, lcd_message_final: std_logic_vector(127 downto 0);

begin
    ps2_component: ps2 port map(keyboard_clk, keyboard_data, clock, reset, scan_code, scan_readyo, hist3, hist2, hist1, hist0);
    mc_to_ascii_component: mc_to_ascii port map(clock, reset, mc2asciiread, hist3, hist2, hist1, hist0, asciikey);
    keyprocess_component: keyprocessing port map(asciikey, keyormsg, mc2asciiread, full1, clock, reset, cipherkey, din, send1, wr_en1);
    keyexpansion_component: keyexpansion port map(clock, reset, cipherkey, send1, keyset);
    data2aes_fifo: fifo port map(clock,clock, reset, rd_en1, wr_en1, din, dout_fifo, full1, empty1);
    aes128_full_component: aes128_full port map(clock, reset, full1, dout_fifo, rd_en1, keyset, empty1, message_out, wr_en2);
    full2lcd_fifo: fifo port map(clock, clock, reset, rd_en2, wr_en2, message_out, lcd_message, full2, empty2);
    output_ctrl : output_control port map(clock, reset, nextd, empty2, lcd_message, rd_en2, lcd_message_final);
    lcdde: de2lcd port map(reset, clock, LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED, LCD_RW, DATA_BUS, lcd_message_final);

end architecture structural;