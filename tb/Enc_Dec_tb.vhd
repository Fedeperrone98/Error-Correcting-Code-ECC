library IEEE;
use IEEE.std_logic_1164.all;

--entity declaration
entity Enc_Dec_tb is
end Enc_Dec_tb;

--architecture body
architecture rtl of Enc_Dec_tb is

    constant clk_period : time := 8 ns;

    component Encoder is
        port( 
            data_in : in std_logic_vector(10 downto 0);
            data_encoded : out std_logic_vector(15 downto 0)
	    );			
    end component;

    component Decoder is
        port( 
            data_encoded : in std_logic_vector(15 downto 0);
            data_out : out std_logic_vector(10 downto 0);
            NE_bit : out std_logic;
            SEC_bit : out std_logic;
            DED_bit : out std_logic
        );			
    end component;

    signal clk : std_logic := '0';
    signal data_in: std_logic_vector(10 downto 0) := (others => '0');
    signal data_encoded_out: std_logic_vector(15 downto 0) := (others => '0');
    signal data_encoded_in: std_logic_vector(15 downto 0) := (others => '0');
    signal data_out: std_logic_vector(10 downto 0);
    signal NE_bit : std_logic;
    signal SEC_bit : std_logic;
    signal DED_bit : std_logic;
    signal testing : boolean := true;

    begin
        clk <= not clk after clk_period/2 when testing else '0';

        i_dut1: Encoder
        port map( 
            data_in => data_in,
            data_encoded => data_encoded_out
        );

        i_dut2: Decoder
        port map( 
            data_encoded => data_encoded_in,
            data_out => data_out,
            NE_bit => NE_bit,
            SEC_bit => SEC_bit,
            DED_bit => DED_bit
        );

        stimulus : process
        begin
            data_in <= (others => '0');
            data_encoded_in <= (others => '0');
            wait for 32 ns;
            
            --assume that there was not an error
            -- expected out -> data_out= "01010101011" (683), NE=1, SEC=DED=0
            data_in <= "01010101011";
            data_encoded_in <= data_encoded_out;
            wait for 32 ns;

            --assume that there was a single error in p16
            -- expected out -> data_out= "01010101011" (683), NE=0, SEC=1, DED=0
            data_in <= "01010101011";
            data_encoded_in <= not(data_encoded_out(15)) & data_encoded_out(14 downto 0);
            wait for 32 ns;

            --assume that there was a single error in d10
            -- expected out -> data_out= "01010101011" (683), NE=0, SEC=1, DED=0
            data_in <= "01010101011";
            data_encoded_in <= data_encoded_out(15 downto 14) & not(data_encoded_out(13)) & data_encoded_out(12 downto 0);
            wait for 32 ns;

            --assume that there was a single error in d11
            -- expected out -> data_out= "01010101011" (683), NE=0, SEC=1, DED=0
            data_in <= "01010101011";
            data_encoded_in <= data_encoded_out(15) & not(data_encoded_out(14)) & data_encoded_out(13 downto 0);
            wait for 32 ns;

            --assume that there was a single error in d3
            -- expected out -> data_out= "01010101011" (683), NE=0, SEC=1, DED=0
            data_in <= "01010101011";
            data_encoded_in <= data_encoded_out(15 downto 6) & not(data_encoded_out(5)) & data_encoded_out(4 downto 0);
            wait for 32 ns;

            --assume that there was a single error in p8
            -- expected out -> data_out= "01010101011" (683), NE=0, SEC=1, DED=0
            data_in <= "01010101011";
            data_encoded_in <= data_encoded_out(15 downto 8) & not(data_encoded_out(7)) & data_encoded_out(6 downto 0);
            wait for 32 ns;

            --assume that there was a double error in p8 and d1
            -- expected out -> data_out=invalid info, NE=0, SEC=0, DED=1
            data_in <= "01010101011";
            data_encoded_in <= data_encoded_out(15 downto 8) & not(data_encoded_out(7)) & data_encoded_out(6 downto 3) & not(data_encoded_out(2)) & data_encoded_out(1 downto 0);
            wait for 32 ns;

            --assume that there was a double error in d10 and d9
            -- expected out -> data_out=invalid info, NE=0, SEC=0, DED=1
            data_in <= "01010101011";
            data_encoded_in <= data_encoded_out(15 downto 14) & not(data_encoded_out(13)) & not(data_encoded_out(12)) & data_encoded_out(11 downto 0);
            wait for 32 ns;

            --assume that there was a double error in d4 and d7
            -- expected out -> data_out=invalid info, NE=0, SEC=0, DED=1
            data_in <= "01010101011";
            data_encoded_in <= data_encoded_out(15 downto 11) & not(data_encoded_out(10)) & data_encoded_out(9 downto 7) & not(data_encoded_out(6)) & data_encoded_out(5 downto 0);
            wait for 32 ns;
            
            wait until rising_edge(clk);
            testing <= false;
        end process;
    
    end rtl;