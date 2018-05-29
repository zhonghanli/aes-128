LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mc_to_ascii is
	port( 	clock : in std_logic;
			reset : in std_logic;
			read : out std_logic;
			hist3 : in std_logic_vector(7 downto 0);
			hist2 : in std_logic_vector(7 downto 0);
			hist1 : in std_logic_vector(7 downto 0);
			hist0 : in std_logic_vector(7 downto 0);
			asciikey : out std_logic_vector(7 downto 0)
		);
end entity mc_to_ascii;


architecture structural of mc_to_ascii is

signal makecode : std_logic_vector(7 downto 0);
signal flag : std_logic;
signal sent : std_logic;

begin

-- keyprocess : process(flag, makecode, hist1, asciikey)
-- begin
-- asciikey <= asciikey;
-- 	case(flag) is
-- 		when '1' =>
-- 			-- moved to clocked_process
-- 		when '0' =>
-- 			asciikey <= X"00";
-- 		when others =>
-- 			asciikey <= X"00";
-- 	end case;
-- end process;

-- a1 : process(scan2)
-- begin
-- 	if(rising_edge(scan2)) then
-- 		if (hist1 = hist0) then
-- 		flag <= '1';
-- 		else
-- 		flag <= '0';
-- 			if (hist3 = X"5A") then -- Enter key was pressed + released -> initial case
-- 			key <= hist0;
-- 			elsif (hist2 = X"F0") then -- eg 29 F0 29 28 -> key=28
-- 			key <= hist0;
-- 			end if;
-- 		end if;
-- 	end if;
-- end process a1;

clocked_process : process(reset,clock,hist0,hist1,hist2,sent)
begin
	if (reset = '1') then
		flag <= '0';
		sent <= '0';
		makecode <= X"00";
		asciikey <= X"00";
	elsif(rising_edge(clock)) then
		flag <= '0'; -- set flag back to 0
		if (hist1 /= X"F0") then -- something new is being entered, set sent to 0
			sent <= '0';
		end if;
		if (hist1 = X"F0") and (sent = '0') then -- if a new key is released, set flag to 1, then sent to 1
			flag <= '1'; -- tells mc_to_ascii to look at hist0
			sent <= '1';
			makecode <= hist0;
			if (hist2 = X"12") or (hist2 = X"59") then -- Shift key also released: use capital letter
				case(hist0) is
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
						asciikey <= X"00";
				end case;
			elsif ((hist0 = X"12") or (hist0 = X"59")) and (hist2 /= X"12") and (hist2 /= X"59") then
			-- Another capital letter case, but where shift key was released first
				case(hist2) is
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
						asciikey <= X"00";
					end case;
			else
			-- lower case
				case(hist0) is
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
						asciikey <= X"00";
				end case;
			end if;
		elsif (hist1 = X"F0") then -- a new key is not being released
			sent <= '1';
			-- sent = 1 if hist1 is staying at F0, or is not F0
		end if;
		read <= flag;
	end if;
end process clocked_process;


end architecture structural;