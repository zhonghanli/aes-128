library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package aes_const is
    type rijndael_vector is array(255 downto 0) of std_logic_vector(7 downto 0);
    type quadword_arr is array (natural range <>) of std_logic_vector(127 downto 0);
    type fourbit_arr is array (natural range <>) of std_logic_vector(3 downto 0);
    type byte_arr is array(natural range <>) of std_logic_vector(7 downto 0);

    constant mixcol_const : byte_arr(15 downto 0) :=(
        x"02",x"01",x"01", x"03",x"03",x"02",x"01",x"01",x"01",x"03",x"02",x"01",x"01",x"01",x"03",x"02"
    );


	constant step_arr_const : fourbit_arr(0 to 11) :=(
        X"0",X"1",X"2",X"3",X"4",X"5",X"6",X"7",X"8",X"9",X"A", X"B"
    );

    constant sbox : rijndael_vector := (
        X"63", X"7C", X"77", X"7B", X"F2", X"6B", X"6F", X"C5", X"30", X"01", X"67", X"2B", X"FE", X"D7", X"AB", X"76", 
        X"CA", X"82", X"C9", X"7D", X"FA", X"59", X"47", X"F0", X"AD", X"D4", X"A2", X"AF", X"9C", X"A4", X"72", X"C0", 
        X"B7", X"FD", X"93", X"26", X"36", X"3F", X"F7", X"CC", X"34", X"A5", X"E5", X"F1", X"71", X"D8", X"31", X"15", 
        X"04", X"C7", X"23", X"C3", X"18", X"96", X"05", X"9A", X"07", X"12", X"80", X"E2", X"EB", X"27", X"B2", X"75", 
        X"09", X"83", X"2C", X"1A", X"1B", X"6E", X"5A", X"A0", X"52", X"3B", X"D6", X"B3", X"29", X"E3", X"2F", X"84", 
        X"53", X"D1", X"00", X"ED", X"20", X"FC", X"B1", X"5B", X"6A", X"CB", X"BE", X"39", X"4A", X"4C", X"58", X"CF", 
        X"D0", X"EF", X"AA", X"FB", X"43", X"4D", X"33", X"85", X"45", X"F9", X"02", X"7F", X"50", X"3C", X"9F", X"A8", 
        X"51", X"A3", X"40", X"8F", X"92", X"9D", X"38", X"F5", X"BC", X"B6", X"DA", X"21", X"10", X"FF", X"F3", X"D2", 
        X"CD", X"0C", X"13", X"EC", X"5F", X"97", X"44", X"17", X"C4", X"A7", X"7E", X"3D", X"64", X"5D", X"19", X"73", 
        X"60", X"81", X"4F", X"DC", X"22", X"2A", X"90", X"88", X"46", X"EE", X"B8", X"14", X"DE", X"5E", X"0B", X"DB", 
        X"E0", X"32", X"3A", X"0A", X"49", X"06", X"24", X"5C", X"C2", X"D3", X"AC", X"62", X"91", X"95", X"E4", X"79", 
        X"E7", X"C8", X"37", X"6D", X"8D", X"D5", X"4E", X"A9", X"6C", X"56", X"F4", X"EA", X"65", X"7A", X"AE", X"08", 
        X"BA", X"78", X"25", X"2E", X"1C", X"A6", X"B4", X"C6", X"E8", X"DD", X"74", X"1F", X"4B", X"BD", X"8B", X"8A", 
        X"70", X"3E", X"B5", X"66", X"48", X"03", X"F6", X"0E", X"61", X"35", X"57", X"B9", X"86", X"C1", X"1D", X"9E", 
        X"E1", X"F8", X"98", X"11", X"69", X"D9", X"8E", X"94", X"9B", X"1E", X"87", X"E9", X"CE", X"55", X"28", X"DF", 
        X"8C", X"A1", X"89", X"0D", X"BF", X"E6", X"42", X"68", X"41", X"99", X"2D", X"0F", X"B0", X"54", X"BB", X"16"
    );

    
    constant rcon : rijndael_vector := (
    	X"8d", X"01", X"02", X"04", X"08", X"10", X"20", X"40", X"80", X"1b", X"36", X"6c", X"d8", X"ab", X"4d", X"9a",
    	X"2f", X"5e", X"bc", X"63", X"c6", X"97", X"35", X"6a", X"d4", X"b3", X"7d", X"fa", X"ef", X"c5", X"91", X"39",
    	X"72", X"e4", X"d3", X"bd", X"61", X"c2", X"9f", X"25", X"4a", X"94", X"33", X"66", X"cc", X"83", X"1d", X"3a",
    	X"74", X"e8", X"cb", X"8d", X"01", X"02", X"04", X"08", X"10", X"20", X"40", X"80", X"1b", X"36", X"6c", X"d8",
    	X"ab", X"4d", X"9a", X"2f", X"5e", X"bc", X"63", X"c6", X"97", X"35", X"6a", X"d4", X"b3", X"7d", X"fa", X"ef",
    	X"c5", X"91", X"39", X"72", X"e4", X"d3", X"bd", X"61", X"c2", X"9f", X"25", X"4a", X"94", X"33", X"66", X"cc",
    	X"83", X"1d", X"3a", X"74", X"e8", X"cb", X"8d", X"01", X"02", X"04", X"08", X"10", X"20", X"40", X"80", X"1b",
    	X"36", X"6c", X"d8", X"ab", X"4d", X"9a", X"2f", X"5e", X"bc", X"63", X"c6", X"97", X"35", X"6a", X"d4", X"b3",
    	X"7d", X"fa", X"ef", X"c5", X"91", X"39", X"72", X"e4", X"d3", X"bd", X"61", X"c2", X"9f", X"25", X"4a", X"94",
    	X"33", X"66", X"cc", X"83", X"1d", X"3a", X"74", X"e8", X"cb", X"8d", X"01", X"02", X"04", X"08", X"10", X"20",
    	X"40", X"80", X"1b", X"36", X"6c", X"d8", X"ab", X"4d", X"9a", X"2f", X"5e", X"bc", X"63", X"c6", X"97", X"35",
    	X"6a", X"d4", X"b3", X"7d", X"fa", X"ef", X"c5", X"91", X"39", X"72", X"e4", X"d3", X"bd", X"61", X"c2", X"9f",
    	X"25", X"4a", X"94", X"33", X"66", X"cc", X"83", X"1d", X"3a", X"74", X"e8", X"cb", X"8d", X"01", X"02", X"04",
    	X"08", X"10", X"20", X"40", X"80", X"1b", X"36", X"6c", X"d8", X"ab", X"4d", X"9a", X"2f", X"5e", X"bc", X"63",
    	X"c6", X"97", X"35", X"6a", X"d4", X"b3", X"7d", X"fa", X"ef", X"c5", X"91", X"39", X"72", X"e4", X"d3", X"bd",
    	X"61", X"c2", X"9f", X"25", X"4a", X"94", X"33", X"66", X"cc", X"83", X"1d", X"3a", X"74", X"e8", X"cb", X"8d"
    );




    function subBytes(x : std_logic_vector(7 downto 0))
        return std_logic_vector;
    
    function mult(x,y : std_logic_vector(7 downto 0))
        return std_logic_vector;

    function hex2ascii(x : std_logic_vector(3 downto 0))
        return std_logic_vector;
        
    end aes_const;




    package body aes_const is

    function subBytes(x : std_logic_vector(7 downto 0))
                return std_logic_vector is
        variable y_pos, x_pos, pos : integer;
        variable ret : std_logic_vector(7 downto 0) := "00000000";
    begin
        y_pos := to_integer(unsigned(x(7 downto 4)));
        x_pos := to_integer(unsigned(x(3 downto 0)));
        pos := 255-(16*y_pos+x_pos);

        ret(7 downto 0) := sbox(pos);
        return ret;
    end subBytes;


    function mult(x,y : std_logic_vector(7 downto 0))
            return std_logic_vector is
        variable result : std_logic_vector(7 downto 0) := "00000000";
    begin 
        case y is
            when x"01" =>
                result := x;
            when x"02" =>
                --galois field
                if x(7) = '1' then
                    result := std_logic_vector(unsigned(x(6 downto 0) & '0') xor "00011011");
                else
                    result := x(6 downto 0) & '0';
                end if;
            when x"03" =>
                if x(7) = '1' then
                    result := std_logic_vector(unsigned(x(6 downto 0) & '0') xor "00011011" xor unsigned(x));
                else         
                    result := std_logic_vector((unsigned(x) sll 1) xor unsigned(x));
                end if;
            when others =>
                result := x;
        end case;
        return result;
    end mult;

    function hex2ascii(x : std_logic_vector(3 downto 0))
                    return std_logic_vector is
        variable result : std_logic_vector(7 downto 0) := "00000000";
    begin
        case x is
            when x"0" => 
                result := x"30";
            when x"1" =>
                result := x"31";
            when x"2" =>
                result := x"32";
            when x"3" =>
                result := x"33";
            when x"4" =>
                result := x"34";
            when x"5" =>
                result := x"35";
            when x"6" =>
                result := x"36";
            when x"7" =>
                result := x"37";
            when x"8" =>
                result := x"38";
            when x"9" =>
                result := x"39";
            when x"A" =>
                result := x"41";
            when x"B" =>
                result := x"42";
            when x"C" =>
                result := x"43";
            when x"D" =>
                result := x"44";
            when x"E" =>
                result := x"45";
            when x"F" =>
                result := x"46";
            when others =>
                result := x"00";
        end case;
        return result;

    end hex2ascii;

    end package body aes_const;