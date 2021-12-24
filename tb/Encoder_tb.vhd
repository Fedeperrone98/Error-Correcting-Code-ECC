library ieee;
use ieee.std_logic_1164.all;

--entity declaration
entity Encoder_tb is
end Encoder_tb;
    
--architecture body
architecture rtl of Encoder_tb is
    
    constant clk_period : time := 8 ns;
    
    component Encoder is
        port( 
            data_in : in std_logic_vector(10 downto 0);
            data_encoded : out std_logic_vector(15 downto 0)
        );
    end component;
    
    signal clk : std_logic := '0';
    signal data_in: std_logic_vector(10 downto 0) := (others => '0');
    signal data_encoded: std_logic_vector(15 downto 0);
    signal testing : boolean := true;
    
    begin
        clk <= not clk after clk_period/2 when testing else '0';
    
        dut: Encoder
        port map(
            data_in => data_in,
            data_encoded => data_encoded
        );
    
        stimulus : process
        begin
            data_in <= (others => '0');
			wait for 16 ns;

            data_in <= "01010101011";
            --expected output "0010101011010101" -> 10965
            wait for 16 ns;

            data_in <= "11100011100";
            --expected output "1111000101101000" -> 61800
            wait for 16 ns;

            data_in <= "10101010101";
            --expected output "0101010100101101" -> 21805
            wait for 16 ns;

            data_in <= "00000000000";
            --expected output "0000000000000000" -> 0
            wait for 16 ns;

            data_in <= "11111111111";
            --expected output "1111111111111111" -> 65535
            wait for 16 ns;
            
            wait until rising_edge(clk);
            testing <= false;
        end process;
        
        end rtl;