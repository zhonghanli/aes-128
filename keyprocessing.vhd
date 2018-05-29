LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.numeric_std.all;
 
entity keyprocessing is
  port(  asciikey : in std_logic_vector(7 downto 0);
      keyormsg, read, full : in std_logic;
      -- If keyormsg = 0, key. If keyormsg = 1, msg.
      -- Only send msg if 'full' (from fifo) is 0
      clock, reset : in std_logic;
      cipherkey, din : out std_logic_vector(127 downto 0);
      send_key_out : out std_logic;
      wr_enable_out : out std_logic
  );
end keyprocessing;
 
architecture behavior of keyprocessing is
  signal tempvector, tempvector_c : std_logic_vector(127 downto 0);
  -- signal counter, counter_c : std_logic_vector(3 downto 0);
  signal cipherkey_c, cipherkey_t, din_c, din_t : std_logic_vector(127 downto 0);
  signal sent, sent_c, send_key, wr_enable, send_key_c, wr_enable_c : std_logic;
  signal counter, counter_c : integer range 0 to 15;
  type state_type is (s0, s1, s2);
  signal state, next_state : state_type;
-- s0: waiting for sth to happen
-- s1: fill any remaining bytes with space bar (if msg/key is less than 16 bytes)
-- s2: send key/msg
begin
 
  key_fsm : process (asciikey, counter, tempvector, state, cipherkey_t, din_t, read, keyormsg, full)
  begin
    tempvector_c <= tempvector;
	counter_c <= counter;
    next_state <= state;
    sent_c <= sent;
    send_key_c <= '0';
    wr_enable_c <= '0';
    cipherkey_c <= cipherkey_t;
    din_c <= din_t;
    case(state) is
      when s0 =>
      -- check if read is 1;
        if (read = '1') then
          if (asciikey /= X"81") then -- fill the next byte if system is ready to read and the key is not enter
            -- cast counter to integer before using it
            sent_c <= '0';
            tempvector_c(127-counter*8 downto 128-(counter+1)*8) <= asciikey;
            if (counter = 15) then
              next_state <= s2; -- tempvector_c is filled: send it
            else
              counter_c <= counter + 1;
            end if;
          elsif (asciikey = X"81") and (sent_c = '0') then -- Enter has been pressed
            if counter = 15 then
                	next_state <= s2; -- tempvector_c is filled: send it
            else
                	next_state <= s1; -- fill tempvector_c
            end if;
          end if;
        end if;
          when s1 => -- 'Enter' has been pressed: fill tempvector_c if counter is not 15 (i.e. tempvector is not filled with 16 bytes)
            if counter /= 15 then
              for ii in 0 to 15 loop -- left off here
                -- e.g. if counter = 2, first three bytes have been filled, so fill bytes 103 downto 0
                -- want first iteration (ii = counter+1 = 3) to be: 127-ii*8 = 103 downto 127-(ii+1)*8+1 = 96
					 if (ii >= counter) then
						tempvector_c(127-(ii*8) downto 127-(ii+1)*8+1) <= X"20";
					 end if;
              end loop;
            end if;
            next_state <= s2; --tempvector_c is now filled: send it
          when s2 => -- assign tempvector_c to cipherkey or message
          --If keyormsg = 0, key. If keyormsg = 1, msg.
            if keyormsg = '0' then
              cipherkey_c <= tempvector;
              send_key_c <= '1'; -- send key to processor
            elsif keyormsg = '1' and full = '0' then
              din_c <= tempvector;
              wr_enable_c <= '1'; -- send message to data fifo
            end if;
            next_state <= s0;
            counter_c <= 0;
            sent_c <= '1';
          when others =>
          	send_key_c <= 'X';
        end case;
      end process key_fsm;

        
  clocked_process : process(reset,clock)
  begin
    if (reset = '1') then
      state <= s0;
      counter <= 0;
      tempvector <= (others => '0');
      send_key <= '0';
      wr_enable <= '0';
      din_t <= (others => '0');
      cipherkey_t <= (others => '0');
      sent <= '0';
    elsif(rising_edge(clock)) then
      state <= next_state;
      counter <= counter_c;
      tempvector <= tempvector_c;
      send_key <= send_key_c;
      wr_enable <= wr_enable_c;
      cipherkey_t <= cipherkey_c;
      din_t <= din_c;
      sent <= sent_c;
    end if;
  end process;
 
 cipherkey <= cipherkey_t;
 din <= din_t;
 send_key_out <= send_key;
 wr_enable_out <= wr_enable;
 
 
end behavior;

	
	-- state: key or message. If key, go to
	-- key:
	-- fsm states: s1 s2 s3 ... to get 8 bits to whatever you need to send
	-- if they hit enter, jump to finishing state, set start to 1, nextstate to s0
	-- at s0, set send_key to 0
	-- key state: moment you hit 16 bytes, send_key becomes 1
	-- if someone only uses 4 byte, e.g. 'pool', key becomes pool|12 zeros
	-- start bit only 1 for one clock cycle
	
	--
	-- message:
	-- 128 bits, connect to fifo 
	-- fifo input to module is full (want full to be 0 before you output -> if full 0)
	-- fifo inputs (message outputs) are din, wr_enable (equivalent to start for key)
	-- if full = 1, wr_enable is 1
	
	-- behavior:
	-- if enter pressed -> terminate early (fill the rest of 128 with zeros)
	-- if 16 bytes reached, go to end state
	-- 