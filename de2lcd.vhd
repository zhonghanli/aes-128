LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;
USE WORK.aes_const.all;

ENTITY de2lcd IS
	PORT(reset, clk_50Mhz				: IN	STD_LOGIC;
		 LCD_RS, LCD_E, LCD_ON, RESET_LED, SEC_LED		: OUT	STD_LOGIC;
		 LCD_RW						: BUFFER STD_LOGIC;
		 DATA_BUS        : INOUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		 data : in std_logic_vector(127 downto 0) 
		 );
END de2lcd;

ARCHITECTURE a OF de2lcd IS
	-- TYPE STATE_TYPE IS (HOLD, FUNC_SET, DISPLAY_ON, MODE_SET, WRITE_CHAR1,
	-- WRITE_CHAR2, WRITE_CHAR3, WRITE_CHAR4, WRITE_CHAR5, WRITE_CHAR6, WRITE_CHAR7,
	-- WRITE_CHAR8, WRITE_CHAR9, WRITE_CHAR10, WRITE_CHAR11, WRITE_CHAR12, WRITE_CHAR13, WRITE_CHAR14, 
	-- WRITE_CHAR15, WRITE_CHAR16, WRITE_CHAR17, WRITE_CHAR18, WRITE_CHAR19, WRITE_CHAR20, WRITE_CHAR21,
	-- WRITE_CHAR22, WRITE_CHAR23, WRITE_CHAR24, WRITE_CHAR25, WRITE_CHAR26, WRITE_CHAR27, WRITE_CHAR28, 
	-- WRITE_CHAR29, WRITE_CHAR30, WRITE_CHAR31, WRITE_CHAR32, LCD_CH_LINE, RETURN_HOME, TOGGLE_E, RESET1, RESET2, 
	-- RESET3, DISPLAY_OFF, DISPLAY_CLEAR);

	TYPE STATE_TYPE IS (HOLD, FUNC_SET, DISPLAY_ON, MODE_SET, WRITE_CHAR, RETURN_HOME, TOGGLE_E, RESET1, RESET2, 
	RESET3, DISPLAY_OFF, DISPLAY_CLEAR);

	SIGNAL state, next_command: STATE_TYPE;
	SIGNAL DATA_BUS_VALUE: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL CLK_COUNT_400HZ: STD_LOGIC_VECTOR(19 DOWNTO 0);
	SIGNAL CLK_400HZ : STD_LOGIC;
	signal counter, counter_c : integer;
	signal data128 : std_logic_vector(7 downto 0);

BEGIN

	RESET_LED <= NOT RESET;
-- BIDIRECTIONAL TRI STATE LCD DATA BUS
	DATA_BUS <= DATA_BUS_VALUE WHEN LCD_RW = '0' ELSE "ZZZZZZZZ";

-- clock period adjustment for timing on lcd state diagram
	PROCESS
	BEGIN
	 WAIT UNTIL CLK_50MHZ'EVENT AND CLK_50MHZ = '1';
		IF RESET = '0' THEN
		 CLK_COUNT_400HZ <= X"00000";
		 CLK_400HZ <= '0';
		 counter <= 0;
		ELSE
				counter <= counter_c;
				IF CLK_COUNT_400HZ < X"0F424" THEN 
				 CLK_COUNT_400HZ <= CLK_COUNT_400HZ + 1;
				ELSE
		    	 CLK_COUNT_400HZ <= X"00000";
				 CLK_400HZ <= NOT CLK_400HZ;
				END IF;
		END IF;
	END PROCESS;
--sensitive to new clock
	PROCESS (CLK_400HZ, reset, data)
	variable init: std_logic:='0';
	variable try : std_logic_vector(3 downto 0);
	BEGIN
		try := data(127 downto 124);
		LCD_ON <= '1';
		IF init = '0' THEN
			init := '1';
			state <= RESET1;
			DATA_BUS_VALUE <= X"38";
			next_command <= RESET2;
			LCD_E <= '1';
			LCD_RS <= '0';
			LCD_RW <= '0';
			counter_c<=0;

		ELSIF CLK_400HZ'EVENT AND CLK_400HZ = '1' THEN
			data128 <= hex2ascii(data(127 downto 124));

			counter_c<=counter;
			CASE state IS
-- Set Function to 8-bit transfer and 2 line display with 5x8 Font size
-- see Hitachi HD44780 family data sheet for LCD command and timing details
				WHEN RESET1 =>
						LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"38";
						state <= TOGGLE_E;
						next_command <= RESET2;
				WHEN RESET2 =>
						LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"38";
						state <= TOGGLE_E;
						next_command <= RESET3;
				WHEN RESET3 =>
						LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"38";
						state <= TOGGLE_E;
						next_command <= FUNC_SET;
				WHEN FUNC_SET =>
						LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"38";
						state <= TOGGLE_E;
						next_command <= DISPLAY_OFF;
-- Turn off Display and Turn off cursor
				WHEN DISPLAY_OFF =>
						LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"08";
						state <= TOGGLE_E;
						next_command <= DISPLAY_CLEAR;
-- Turn on Display and Turn off cursor
				WHEN DISPLAY_CLEAR =>
						LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"01";
						state <= TOGGLE_E;
						next_command <= DISPLAY_ON;
-- Turn on Display and Turn off cursor
				WHEN DISPLAY_ON =>
						LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"0C";
						state <= TOGGLE_E;
						next_command <= MODE_SET;
-- Set write mode to auto increment address and move cursor to the right
				WHEN MODE_SET =>
						LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"06";
						state <= TOGGLE_E;
						next_command <= WRITE_CHAR;
--Write ASCII hex character in first LCD character location
-- 				WHEN WRITE_CHAR1 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= hex2ascii(x"d");
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR2;
-- -- Write ASCII hex character in second LCD character location
-- 				WHEN WRITE_CHAR2 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= x"41";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR3;
-- -- Write ASCII hex character in third LCD character location
-- 				WHEN WRITE_CHAR3 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= x"41";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR4;
-- -- Write ASCII hex character in fourth LCD character location
-- 				WHEN WRITE_CHAR4 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= x"41";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR5;
-- -- Write ASCII hex character in fifth LCD character location
-- 				WHEN WRITE_CHAR5 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= x"41";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR6;
-- -- Write ASCII hex character in sixth LCD character location
-- 				WHEN WRITE_CHAR6 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= x"41";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR7;
-- -- Write ASCII hex character in seventh LCD character location
-- 				WHEN WRITE_CHAR7 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= x"41";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR8;
-- -- Write ASCII hex character in eighth LCD character location
-- 				WHEN WRITE_CHAR8 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= x"41";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR9;
-- 				WHEN WRITE_CHAR9 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"41";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR10;
-- 				WHEN WRITE_CHAR10 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <=X"41";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR11;
-- 				WHEN WRITE_CHAR11 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"41";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR12;
-- 				WHEN WRITE_CHAR12 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"41";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR13;
-- 				WHEN WRITE_CHAR13 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"41";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR14;
-- 				WHEN WRITE_CHAR14 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"41";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR15;
-- 				WHEN WRITE_CHAR15 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"41";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR16;
-- 				WHEN WRITE_CHAR16 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= x"41";
-- 						state <= TOGGLE_E;
-- 						next_command <= LCD_CH_LINE;
-- -- Move to second line of LCD
-- 			WHEN LCD_CH_LINE =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '0';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"C0";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR17;
-- --Characters of 2nd line
-- 				WHEN WRITE_CHAR17 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR18;
-- 				WHEN WRITE_CHAR18 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR19;
-- 				WHEN WRITE_CHAR19 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR20;
-- 				WHEN WRITE_CHAR20 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR21;
-- 				WHEN WRITE_CHAR21 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR22;
-- 				WHEN WRITE_CHAR22 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR23;
-- 				WHEN WRITE_CHAR23 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR24;
-- 				WHEN WRITE_CHAR24 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR25;
-- 				WHEN WRITE_CHAR25 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR26;
-- 				WHEN WRITE_CHAR26 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR27;
-- 				WHEN WRITE_CHAR27 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR28;
-- 				WHEN WRITE_CHAR28 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR29;
-- 				WHEN WRITE_CHAR29 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR30;
-- 				WHEN WRITE_CHAR30 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR31;
-- 				WHEN WRITE_CHAR31 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= WRITE_CHAR32;
-- 				WHEN WRITE_CHAR32 =>
-- 						LCD_E <= '1';
-- 						LCD_RS <= '1';
-- 						LCD_RW <= '0';
-- 						DATA_BUS_VALUE <= X"6e";
-- 						state <= TOGGLE_E;
-- 						next_command <= RETURN_HOME;

-- Return write address to first character postion
				WHEN RETURN_HOME =>
						LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"80";
						state <= TOGGLE_E;
						next_command <= WRITE_CHAR;
-- The next two states occur at the end of each command to the LCD
-- Toggle E line - falling edge loads inst/data to LCD controller
				WHEN TOGGLE_E =>
						LCD_E <= '0';
						state <= HOLD;
-- Hold LCD inst/data valid after falling edge of E line				
				WHEN HOLD =>
						state <= next_command;

				---------------------------
				WHEN WRITE_CHAR =>
					next_command <= WRITE_CHAR;
					if ( counter = 16 ) then
						LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"C0";
					elsif ( counter = 32 ) then
						LCD_E <= '1';
						LCD_RS <= '0';
						LCD_RW <= '0';
						DATA_BUS_VALUE <= X"80";
						counter_c <= 0;
					else
						counter_c <= counter +1;
						--fifo_rd_en <= '1';
						LCD_E <= '1';
						LCD_RS <= '1';
						LCD_RW <= '0';
						--the below line does not work:
						-- DATA_BUS_VALUE <= hex2ascii(data(127-counter*4 downto 128-(counter+1)*4));
						--This line works:
					
						DATA_BUS_VALUE <= data128;
			
					end if;
					state <= TOGGLE_E;

				-- WHEN LCD_CH_LINE =>
				-- 	LCD_E <= '1';
				-- 	LCD_RS <= '0';
				-- 	LCD_RW <= '0';
				-- 	DATA_BUS_VALUE <= X"C0";
				-- 	state <= TOGGLE_E;
				-- 	next_command <= WRITE_CHAR;
						
			END CASE;
		END IF;
	END PROCESS;
END a;
