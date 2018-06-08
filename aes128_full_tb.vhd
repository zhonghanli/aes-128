LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;
USE WORK.aes_const.all;

entity aes128_full_tb is
end entity aes128_full_tb;

architecture behavior of aes128_full_tb is
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


    constant clk_half_period : time := 1 ns;
    signal clock: std_logic:= '0';
    signal reset, input_fifo_empty, rd_en, output_fifo_full, wr_en : std_logic;
    signal input_fifo_data, output_fifo_data : std_logic_vector(127 downto 0);
    signal roundkeys : quadword_arr(0 to 10);
begin   
    clock <= not clock after clk_half_period;

    dut: aes128_full port map(
        clock,
        reset,
        input_fifo_empty,
        input_fifo_data,
        rd_en,
        roundkeys,
        output_fifo_full,
        output_fifo_data,
        wr_en
    );
    
    test : process
    begin
        -- reset <= '0';
        input_fifo_empty <= '0';

        -- roundkeys(0 to 10)<= (
        -- x"4865726D696F6E65204772616E676572",
        -- x"CC2832F2A5475C9785002EF6EB674B84",
        -- x"4B9B6D1BEEDC318C6BDC1F7A80BB54FE",
        -- x"A5BBD6D64B67E75A20BBF820A000ACDE", 
        -- x"CE2ACB36854D2C6CA5F6D44C05F67892", 
        -- x"9C96845D19DBA831BC2D7C7DB9DB04EF", 
        -- x"05645B0B1CBFF33AA0928F4719498BA8", 
        -- x"7E5999DF62E66AE5C274E5A2DB3D6E0A", 
        -- x"D9C6FE66BB20948379547121A2691F2B", 
        -- x"3B060F5C80269BDFF972EAFE5B1BF5D5", 
        -- x"A2E00C6522C697BADBB47D4480AF8891"
        -- );

        --hermione granger
        roundkeys(0 to 10)<= (
        x"6865726D696F6E65206772616E676572",
        x"EC2832F285475C97A5202EF6CB474B84",
        x"4E9B6DEDCBDC317A6EFC1F8CA5BB5408",
        x"A0BB5DEB6B676C91059B731DA0202715", 
        x"1F77040B7410689A718B1B87D1AB3C92", 
        x"6D9C4B35198C23AF68073828B9AC04BA", 
        x"DC6EBF63C5E29CCCADE5A4E41449A05E", 
        x"A78EE799626C7B55CF89DFB1DBC07FEF", 
        x"9D5C3820FF30437530B99CC4EB79E32B", 
        x"304DC9C9CF7D8ABCFFC4167814BDF553", 
        x"7CAB2433B3D6AE8F4C12B8F758AF4DA4"
        );
        input_fifo_data <= x"6578706563746f20706174726f6e756d";--expecto patronum



        --TEST2
        -- input_fifo_data <= X"54776F204F6E65204E696E652054776F"; 
        -- roundkeys(0 to 10) <= (
        --     x"5468617473206D79204B756E67204675",
        --     x"E232FCF191129188B159E4E6D679A293",
        --     x"56082007C71AB18F76435569A03AF7FA",
        --     x"D2600DE7157ABC686339E901C3031EFB",
        --     x"A11202C9B468BEA1D75157A01452495B",
        --     x"B1293B3305418592D210D232C6429B69",
        --     x"BD3DC287B87C47156A6C9527AC2E0E4E",
        --     x"CC96ED1674EAAA031E863F24B2A8316A",
        --     x"8E51EF21FABB4522E43D7A0656954B6C",
        --     x"BFE2BF904559FAB2A16480B4F7F1CBD8",
        --     x"28FDDEF86DA4244ACCC0A4FE3B316F26"
        -- );


        --TEST1
        -- input_fifo_data <= x"00112233445566778899AABBCCDDEEFF";
        -- roundkeys <=(
        --     x"000102030405060708090A0B0C0D0E0F",
        --     x"D6AA74FDD2AF72FADAA678F1D6AB76FE",
        --     x"B692CF0B643DBDF1BE9BC5006830B3FE",
        --     x"B6FF744ED2C2C9BF6C590CBF0469BF41",
        --     x"47F7F7BC95353E03F96C32BCFD058DFD",
        --     x"3CAAA3E8A99F9DEB50F3AF57ADF622AA",
        --     x"5E390F7DF7A69296A7553DC10AA31F6B",
        --     x"14F9701AE35FE28C440ADF4D4EA9C026",
        --     x"47438735A41C65B9E016BAF4AEBF7AD2",
        --     x"549932D1F08557681093ED9CBE2C974E",
        --     x"13111D7FE3944A17F307A78B4D2B30C5"
        -- );

        output_fifo_full <= '0';

        -- wait for 2 ns;

        reset <= '1';

        wait for 2 ns;

        reset <= '0';

        wait for 200 ns;

    end process;

    
end architecture behavior;