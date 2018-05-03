LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ps2 is
	port( 	keyboard_clk, keyboard_data, clock_50MHz ,
			reset : in std_logic;--, read : in std_logic;
			scan_code : out std_logic_vector( 7 downto 0 );
			scan_readyo : out std_logic;
			hist3 : out std_logic_vector(7 downto 0);
			hist2 : out std_logic_vector(7 downto 0);
			hist1 : out std_logic_vector(7 downto 0);
			hist0 : out std_logic_vector(7 downto 0)
		);
end entity ps2;


architecture structural of ps2 is

component keyboard IS
	PORT( 	keyboard_clk, keyboard_data, clock_50MHz ,
			reset, read : IN STD_LOGIC;
			scan_code : OUT STD_LOGIC_VECTOR( 7 DOWNTO 0 );
			scan_ready : OUT STD_LOGIC);
end component keyboard;

component oneshot is
port(
	pulse_out : out std_logic;
	trigger_in : in std_logic; 
	clk: in std_logic );
end component oneshot;

signal scan2 : std_logic;
signal scan_code2 : std_logic_vector( 7 downto 0 );
signal history3 : std_logic_vector(7 downto 0);
signal history2 : std_logic_vector(7 downto 0);
signal history1 : std_logic_vector(7 downto 0);
signal history0 : std_logic_vector(7 downto 0);
signal read : std_logic;
signal flag : std_logic;
signal key : std_logic_vector(7 downto 0);
signal asciikey : std_logic_vector(7 downto 0);

begin

keyprocess : process
begin
case(flag) is
when '0' =>
if (history1 = X"12") or (history1 = X"59") then
	case(key) is
		when X"0E" =>
			asciikey <= X"60";
		when X"16" =>
			asciikey <= X"31";
		when X"1E" =>
			asciikey <= X"32";
		when X"26" =>
			asciikey <= X"33";
		when X"25" =>
			asciikey <= X"34";
		when X"2E" =>
			asciikey <= X"35";
		when X"36" =>
			asciikey <= X"36";
		when X"3D" =>
			asciikey <= X"37";
		when X"3E" =>
			asciikey <= X"38";
		when X"46" =>
			asciikey <= X"39";
		when X"45" =>
			asciikey <= X"30";
		when X"4E" =>
			asciikey <= X"2D";
		when X"55" =>
			asciikey <= X"3D";
		when X"66" =>
			asciikey <= X"08";
		when X"0D" =>
			asciikey <= X"09"; --'horizontal tab'
		when X"15" => --Q
			asciikey <= X"51";
		when X"1D" => --W
			asciikey <= X"57";
		when X"24" => --E
			asciikey <= X"45";
		when X"2D" => --R
			asciikey <= X"52";
		when X"2C" => --T
			asciikey <= X"54";
		when X"35" => --Y
			asciikey <= X"59";
		when X"3C" => --U
			asciikey <= X"55";
		when X"43" => --I
			asciikey <= X"49";
		when X"44" => --O
			asciikey <= X"4F";
		when X"4D" => --P
			asciikey <= X"50";
		when X"54" => --[
			asciikey <= X"5B";
		when X"5B" => --]
			asciikey <= X"5D";
		when X"5D" => --\
			asciikey <= X"5C";
		when X"58" => --Caps lock
			asciikey <= X"80";
		when X"1C" => --A
			asciikey <= X"41";
		when X"1B" => --S
			asciikey <= X"53";
		when X"23" => --D
			asciikey <= X"44";
		when X"2B" => --F
			asciikey <= X"46";
		when X"34" => --G
			asciikey <= X"47";
		when X"33" => --H
			asciikey <= X"48";
		when X"3B" => --J
			asciikey <= X"4A";
		when X"42" => --K
			asciikey <= X"4B";
		when X"4B" => --L
			asciikey <= X"4C";
		when X"4C" => --;
			asciikey <= X"3B";
		when X"52" => --'
			asciikey <= X"27";
		when X"5A" => --Enter
			asciikey <= X"81";
		when X"12" => --Left shift
			asciikey <= X"82";
		when X"1A" => --Z
			asciikey <= X"5A";
		when X"22" => --X
			asciikey <= X"58";
		when X"21" => --C
			asciikey <= X"43";
		when X"2A" => --V
			asciikey <= X"56";
		when X"32" => --B
			asciikey <= X"42";
		when X"31" => --N
			asciikey <= X"4E";
		when X"3A" => --M
			asciikey <= X"4D";
		when X"41" => --,
			asciikey <= X"41";
		when X"49" => --.
			asciikey <= X"49";
		when X"4A" => --/
			asciikey <= X"4A";
		when X"59" => --Right shift
			asciikey <= X"83";
		when X"14" => --Left ctl
			asciikey <= X"84";
		when X"11" => --Left alt
			asciikey <= X"85";
		when X"29" => --Space bar
			asciikey <= X"20";
		when X"70" => --0
			asciikey <= X"30";
		when X"71" => --.
			asciikey <= X"2E";
		when X"69" => --1
			asciikey <= X"31";
		when X"72" => --2
			asciikey <= X"32";
		when X"7A" => --3
			asciikey <= X"33";
		when X"6B" => --4
			asciikey <= X"34";
		when X"73" => --5
			asciikey <= X"35";
		when X"74" => --6
			asciikey <= X"36";
		when X"6C" => --7
			asciikey <= X"37";
		when X"75" => --8
			asciikey <= X"38";
		when X"7D" => --9
			asciikey <= X"39";
		when others =>
	end case;
else
	case(key) is
		when X"0E" =>
			asciikey <= X"60";
		when X"16" =>
			asciikey <= X"31";
		when X"1E" =>
			asciikey <= X"32";
		when X"26" =>
			asciikey <= X"33";
		when X"25" =>
			asciikey <= X"34";
		when X"2E" =>
			asciikey <= X"35";
		when X"36" =>
			asciikey <= X"36";
		when X"3D" =>
			asciikey <= X"37";
		when X"3E" =>
			asciikey <= X"38";
		when X"46" =>
			asciikey <= X"39";
		when X"45" =>
			asciikey <= X"30";
		when X"4E" =>
			asciikey <= X"2D";
		when X"55" =>
			asciikey <= X"3D";
		when X"66" =>
			asciikey <= X"08";
		when X"0D" =>
			asciikey <= X"09"; --'horizontal tab'
		when X"15" => --Q
			asciikey <= X"71";
		when X"1D" => --W
			asciikey <= X"77";
		when X"24" => --E
			asciikey <= X"65";
		when X"2D" => --R
			asciikey <= X"72";
		when X"2C" => --T
			asciikey <= X"74";
		when X"35" => --Y
			asciikey <= X"79";
		when X"3C" => --U
			asciikey <= X"75";
		when X"43" => --I
			asciikey <= X"69";
		when X"44" => --O
			asciikey <= X"6F";
		when X"4D" => --P
			asciikey <= X"70";
		when X"54" => --[
			asciikey <= X"5B";
		when X"5B" => --]
			asciikey <= X"5D";
		when X"5D" => --\
			asciikey <= X"5C";
		when X"58" => --Caps lock
			asciikey <= X"80";
		when X"1C" => --A
			asciikey <= X"61";
		when X"1B" => --S
			asciikey <= X"73";
		when X"23" => --D
			asciikey <= X"64";
		when X"2B" => --F
			asciikey <= X"66";
		when X"34" => --G
			asciikey <= X"67";
		when X"33" => --H
			asciikey <= X"68";
		when X"3B" => --J
			asciikey <= X"6A";
		when X"42" => --K
			asciikey <= X"6B";
		when X"4B" => --L
			asciikey <= X"6C";
		when X"4C" => --;
			asciikey <= X"3B";
		when X"52" => --'
			asciikey <= X"27";
		when X"5A" => --Enter
			asciikey <= X"81";
		when X"12" => --Left shift
			asciikey <= X"82";
		when X"1A" => --Z
			asciikey <= X"7A";
		when X"22" => --X
			asciikey <= X"78";
		when X"21" => --C
			asciikey <= X"63";
		when X"2A" => --V
			asciikey <= X"76";
		when X"32" => --B
			asciikey <= X"62";
		when X"31" => --N
			asciikey <= X"6E";
		when X"3A" => --M
			asciikey <= X"6D";
		when X"41" => --,
			asciikey <= X"41";
		when X"49" => --.
			asciikey <= X"49";
		when X"4A" => --/
			asciikey <= X"4A";
		when X"59" => --Right shift
			asciikey <= X"83";
		when X"14" => --Left ctl
			asciikey <= X"84";
		when X"11" => --Left alt
			asciikey <= X"85";
		when X"29" => --Space bar
			asciikey <= X"20";
		when X"70" => --0
			asciikey <= X"30";
		when X"71" => --.
			asciikey <= X"2E";
		when X"69" => --1
			asciikey <= X"31";
		when X"72" => --2
			asciikey <= X"32";
		when X"7A" => --3
			asciikey <= X"33";
		when X"6B" => --4
			asciikey <= X"34";
		when X"73" => --5
			asciikey <= X"35";
		when X"74" => --6
			asciikey <= X"36";
		when X"6C" => --7
			asciikey <= X"37";
		when X"75" => --8
			asciikey <= X"38";
		when X"7D" => --9
			asciikey <= X"39";
		when others =>
	end case;

end if;
when '1' =>
when others =>
end case;
end process;

u1: keyboard port map(	
				keyboard_clk => keyboard_clk,
				keyboard_data => keyboard_data,
				clock_50MHz => clock_50MHz,
				reset => reset,
				read => read,
				scan_code => scan_code2,
				scan_ready => scan2
			);

pulser: oneshot port map(
   pulse_out => read,
   trigger_in => scan2,
   clk => clock_50MHz
			);

scan_readyo <= scan2;
scan_code <= scan_code2;

hist0<=history0;
hist1<=history1;
hist2<=history2;
hist3<=history3;

a1 : process(scan2)
begin
	if(rising_edge(scan2)) then
	history3 <= history2;
	history2 <= history1;
	history1 <= history0;
	history0 <= scan_code2;
		if (history1 = history0) then
		flag <= '1';
		else
		flag <= '0';
			if history3 = X"5A" -- Enter key was pressed + released
			key <= history0;
			elsif history2 = X"F0" then -- eg 29 F0 29 28 -> key=28
			key <= history0;
			end if;
		end if;
	end if;
end process a1;


end architecture structural;