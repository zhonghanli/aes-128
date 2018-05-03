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
			hist0 : out std_logic_vector(7 downto 0);
			asciikey : out std_logic_vector(7 downto 0)
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
signal tempkey : std_logic_vector(7 downto 0);

begin

keyprocess : process
begin
	case(flag) is
		when '0' =>
			if (history1 = X"12") or (history1 = X"59") then
				case(key) is
					when X"0E" =>
						tempkey <= X"60";
					when X"16" =>
						tempkey <= X"31";
					when X"1E" =>
						tempkey <= X"32";
					when X"26" =>
						tempkey <= X"33";
					when X"25" =>
						tempkey <= X"34";
					when X"2E" =>
						tempkey <= X"35";
					when X"36" =>
						tempkey <= X"36";
					when X"3D" =>
						tempkey <= X"37";
					when X"3E" =>
						tempkey <= X"38";
					when X"46" =>
						tempkey <= X"39";
					when X"45" =>
						tempkey <= X"30";
					when X"4E" =>
						tempkey <= X"2D";
					when X"55" =>
						tempkey <= X"3D";
					when X"66" =>
						tempkey <= X"08";
					when X"0D" =>
						tempkey <= X"09"; --'horizontal tab'
					when X"15" => --Q
						tempkey <= X"51";
					when X"1D" => --W
						tempkey <= X"57";
					when X"24" => --E
						tempkey <= X"45";
					when X"2D" => --R
						tempkey <= X"52";
					when X"2C" => --T
						tempkey <= X"54";
					when X"35" => --Y
						tempkey <= X"59";
					when X"3C" => --U
						tempkey <= X"55";
					when X"43" => --I
						tempkey <= X"49";
					when X"44" => --O
						tempkey <= X"4F";
					when X"4D" => --P
						tempkey <= X"50";
					when X"54" => --[
						tempkey <= X"5B";
					when X"5B" => --]
						tempkey <= X"5D";
					when X"5D" => --\
						tempkey <= X"5C";
					when X"58" => --Caps lock
						tempkey <= X"80";
					when X"1C" => --A
						tempkey <= X"41";
					when X"1B" => --S
						tempkey <= X"53";
					when X"23" => --D
						tempkey <= X"44";
					when X"2B" => --F
						tempkey <= X"46";
					when X"34" => --G
						tempkey <= X"47";
					when X"33" => --H
						tempkey <= X"48";
					when X"3B" => --J
						tempkey <= X"4A";
					when X"42" => --K
						tempkey <= X"4B";
					when X"4B" => --L
						tempkey <= X"4C";
					when X"4C" => --;
						tempkey <= X"3B";
					when X"52" => --'
						tempkey <= X"27";
					when X"5A" => --Enter
						tempkey <= X"81";
					when X"12" => --Left shift
						tempkey <= X"82";
					when X"1A" => --Z
						tempkey <= X"5A";
					when X"22" => --X
						tempkey <= X"58";
					when X"21" => --C
						tempkey <= X"43";
					when X"2A" => --V
						tempkey <= X"56";
					when X"32" => --B
						tempkey <= X"42";
					when X"31" => --N
						tempkey <= X"4E";
					when X"3A" => --M
						tempkey <= X"4D";
					when X"41" => --,
						tempkey <= X"41";
					when X"49" => --.
						tempkey <= X"49";
					when X"4A" => --/
						tempkey <= X"4A";
					when X"59" => --Right shift
						tempkey <= X"83";
					when X"14" => --Left ctl
						tempkey <= X"84";
					when X"11" => --Left alt
						tempkey <= X"85";
					when X"29" => --Space bar
						tempkey <= X"20";
					when X"70" => --0
						tempkey <= X"30";
					when X"71" => --.
						tempkey <= X"2E";
					when X"69" => --1
						tempkey <= X"31";
					when X"72" => --2
						tempkey <= X"32";
					when X"7A" => --3
						tempkey <= X"33";
					when X"6B" => --4
						tempkey <= X"34";
					when X"73" => --5
						tempkey <= X"35";
					when X"74" => --6
						tempkey <= X"36";
					when X"6C" => --7
						tempkey <= X"37";
					when X"75" => --8
						tempkey <= X"38";
					when X"7D" => --9
						tempkey <= X"39";
					when others =>
				end case;
			else
				case(key) is
					when X"0E" =>
						tempkey <= X"60";
					when X"16" =>
						tempkey <= X"31";
					when X"1E" =>
						tempkey <= X"32";
					when X"26" =>
						tempkey <= X"33";
					when X"25" =>
						tempkey <= X"34";
					when X"2E" =>
						tempkey <= X"35";
					when X"36" =>
						tempkey <= X"36";
					when X"3D" =>
						tempkey <= X"37";
					when X"3E" =>
						tempkey <= X"38";
					when X"46" =>
						tempkey <= X"39";
					when X"45" =>
						tempkey <= X"30";
					when X"4E" =>
						tempkey <= X"2D";
					when X"55" =>
						tempkey <= X"3D";
					when X"66" =>
						tempkey <= X"08";
					when X"0D" =>
						tempkey <= X"09"; --'horizontal tab'
					when X"15" => --Q
						tempkey <= X"71";
					when X"1D" => --W
						tempkey <= X"77";
					when X"24" => --E
						tempkey <= X"65";
					when X"2D" => --R
						tempkey <= X"72";
					when X"2C" => --T
						tempkey <= X"74";
					when X"35" => --Y
						tempkey <= X"79";
					when X"3C" => --U
						tempkey <= X"75";
					when X"43" => --I
						tempkey <= X"69";
					when X"44" => --O
						tempkey <= X"6F";
					when X"4D" => --P
						tempkey <= X"70";
					when X"54" => --[
						tempkey <= X"5B";
					when X"5B" => --]
						tempkey <= X"5D";
					when X"5D" => --\
						tempkey <= X"5C";
					when X"58" => --Caps lock
						tempkey <= X"80";
					when X"1C" => --A
						tempkey <= X"61";
					when X"1B" => --S
						tempkey <= X"73";
					when X"23" => --D
						tempkey <= X"64";
					when X"2B" => --F
						tempkey <= X"66";
					when X"34" => --G
						tempkey <= X"67";
					when X"33" => --H
						tempkey <= X"68";
					when X"3B" => --J
						tempkey <= X"6A";
					when X"42" => --K
						tempkey <= X"6B";
					when X"4B" => --L
						tempkey <= X"6C";
					when X"4C" => --;
						tempkey <= X"3B";
					when X"52" => --'
						tempkey <= X"27";
					when X"5A" => --Enter
						tempkey <= X"81";
					when X"12" => --Left shift
						tempkey <= X"82";
					when X"1A" => --Z
						tempkey <= X"7A";
					when X"22" => --X
						tempkey <= X"78";
					when X"21" => --C
						tempkey <= X"63";
					when X"2A" => --V
						tempkey <= X"76";
					when X"32" => --B
						tempkey <= X"62";
					when X"31" => --N
						tempkey <= X"6E";
					when X"3A" => --M
						tempkey <= X"6D";
					when X"41" => --,
						tempkey <= X"41";
					when X"49" => --.
						tempkey <= X"49";
					when X"4A" => --/
						tempkey <= X"4A";
					when X"59" => --Right shift
						tempkey <= X"83";
					when X"14" => --Left ctl
						tempkey <= X"84";
					when X"11" => --Left alt
						tempkey <= X"85";
					when X"29" => --Space bar
						tempkey <= X"20";
					when X"70" => --0
						tempkey <= X"30";
					when X"71" => --.
						tempkey <= X"2E";
					when X"69" => --1
						tempkey <= X"31";
					when X"72" => --2
						tempkey <= X"32";
					when X"7A" => --3
						tempkey <= X"33";
					when X"6B" => --4
						tempkey <= X"34";
					when X"73" => --5
						tempkey <= X"35";
					when X"74" => --6
						tempkey <= X"36";
					when X"6C" => --7
						tempkey <= X"37";
					when X"75" => --8
						tempkey <= X"38";
					when X"7D" => --9
						tempkey <= X"39";
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
asciikey<=tempkey;

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
			if (history3 = X"5A") then -- Enter key was pressed + released -> initial case
			key <= history0;
			elsif (history2 = X"F0") then -- eg 29 F0 29 28 -> key=28
			key <= history0;
			end if;
		end if;
	end if;
end process a1;


end architecture structural;