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
    signal resetn : std_logic := '0';
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
            reset <= '0';
            data_in <= (others => '0');
            data_encoded_in <= (others => '0');
            wait for 32 ns;

            reset <= '1';
            wait for 32 ns;
            
            --assume that there was not an error
            -- expected out -> data_out= "01010101011" (683), NE=1, SEC=DED=0
            data_in <= "01010101011";
            data_encoded_in <= data_encoded_out;
            wait for 32 ns;

            --assume that there was not an error
            data_in <= "01010101011";
            data_encoded_in <= data_encoded_out;
            wait for 32 ns;

            wait for 32 ns;
            
            wait until rising_edge(clk);
            testing <= false;
        end process;
    
    end rtl;