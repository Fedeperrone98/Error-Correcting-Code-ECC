library ieee;
use ieee.std_logic_1164.all;

--entity declaration
entity Decoder_tb is
end Decoder_tb;
    
--architecture body
architecture rtl of Decoder_tb is
    
    constant clk_period : time := 8 ns;
    
    component Decoder is
        port( 
            data_encoded : in std_logic_vector(15 downto 0);
            data_out : out std_logic_vector(10 downto 0);
            NE_bit : out std_logic;
            SEC_bit : out std_logic;
            DED_bit : out std_logic
	    );		
    end Component;
    
    signal clk : std_logic := '0';
    signal data_encoded: std_logic_vector(15 downto 0) := (others => '0');
    signal data_out: std_logic_vector(10 downto 0);
    signal NE_bit : std_logic;
    signal SEC_bit : std_logic;
    signal DED_bit : std_logic;
    signal testing : boolean := true;
    
    begin
        clk <= not clk after clk_period/2 when testing else '0';
    
        dut: Decoder
        port map(
            data_encoded => data_encoded,
            data_out => data_out, 
            NE_bit => NE_bit,
            SEC_bit => SEC_bit,
            DED_bit => DED_bit
        );
    
        stimulus : process
        begin
            data_encoded <= (others => '0');
			wait for 32 ns;

            -- correct input-> "0010101011010101" (10965)

            --assume that there was not an error
            -- expected out -> data_out= "01010101011" (683), NE=1, SEC=DED=0
            data_encoded <= "0010101011010101";
            wait for 32 ns;

            --assume that there was a single error in p16
            -- expected out -> data_out= "01010101011" (683), NE=0, SEC=1, DED=0
            data_encoded <= "0010101011010100";
            wait for 32 ns;

            --assume that there was a single error in d10
            -- expected out -> data_out= "01010101011" (683), NE=0, SEC=1, DED=0
            data_encoded <= "0000101011010101";
            wait for 32 ns;

            --assume that there was a single error in d11
            -- expected out -> data_out= "01010101011" (683), NE=0, SEC=1, DED=0
            data_encoded <= "0110101011010101";
            wait for 32 ns;

            --assume that there was a single error in d3
            -- expected out -> data_out= "01010101011" (683), NE=0, SEC=1, DED=0
            data_encoded <= "0010101011110101";
            wait for 32 ns;

            --assume that there was a single error in p8
            -- expected out -> data_out= "01010101011" (683), NE=0, SEC=1, DED=0
            data_encoded <= "0010101001010101";
            wait for 32 ns;

            --assume that there was a double error in p8 and d1
            -- expected out -> data_out=invalid info, NE=0, SEC=0, DED=1
            data_encoded <= "0010101001010001";
            wait for 32 ns;

            --assume that there was a double error in d10 and d9
            -- expected out -> data_out=invalid info, NE=0, SEC=0, DED=1
            data_encoded <= "0010110011010101";
            wait for 32 ns;

            wait until rising_edge(clk);
            testing <= false;
        end process;
        
        end rtl;