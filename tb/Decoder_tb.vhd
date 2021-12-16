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
    signal DED_bit : std_logic
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
			wait for 16 ns;
            wait for 16 ns;
            wait for 16 ns;
            wait for 16 ns;
            wait for 16 ns;
            wait for 16 ns;
            wait until rising_edge(clk);
            testing <= false;
        end process;
        
        end rtl;