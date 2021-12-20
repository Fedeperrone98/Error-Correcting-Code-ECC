library ieee;
use ieee.std_logic_1164.all;

--entity declaration
entity ECC_tb is
end ECC_tb;
    
--architecture body
architecture rtl of ECC_tb is
    
    constant clk_period : time := 8 ns;
    
    component ECC is
        port( 
            clk : in std_logic;
            resetn : in std_logic;
            data_in : in std_logic_vector(10 downto 0);
            data_out : out std_logic_vector(10 downto 0);
            NE_bit : out std_logic;
            SEC_bit : out std_logic;
            DED_bit : out std_logic
	    );		
    end Component;
    
    signal clk : std_logic := '0';
    signal resetn : std_logic := '0';
    signal data_in: std_logic_vector(10 downto 0) := (others => '0');
    signal data_out: std_logic_vector(10 downto 0);
    signal NE_bit : std_logic;
    signal SEC_bit : std_logic;
    signal DED_bit : std_logic;
    signal testing : boolean := true;
    
    begin
        clk <= not clk after clk_period/2 when testing else '0';
    
        dut: ECC
        port map(
            clk => clk,
            resetn => resetn,
            data_in => data_in,
            data_out => data_out, 
            NE_bit => NE_bit,
            SEC_bit => SEC_bit,
            DED_bit => DED_bit
        );
    
        stimulus : process
        begin
            data_in <= (others => '0');
            resetn <= '0';
			wait for 32 ns;
            resetn <= '1';
            wait for 32 ns;
            data_in <= "00000000000";            
            wait for 32 ns;
            data_in <= "11111111111";
            wait for 32 ns;
            data_in <= "01010101010";
            wait for 32 ns;
            data_in <= "11110000000";
            wait for 32 ns;
            wait until rising_edge(clk);
            testing <= false;
        end process;
        
        end rtl;