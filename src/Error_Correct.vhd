library ieee;
use ieee.std_logic_1164.all;


entity Error_Correct is
    port( 
        data_encoded : in std_logic_vector(15 downto 0);
        c : in std_logic_vector(3 downto 0);
        p : in std_logic;
        data_out : out std_logic_vector(10 downto 0)
	);
			
end Error_Correct;

architecture beh of Error_Correct is   

    signal temp_cw : std_logic_vector(15 downto 0);

    begin

        -- when c=0 and p=1 there was an error in p16
        temp_cw(15) <= not data_encoded(15) when c="0000" and p='1' else data_encoded(15);
        
        --when c="1110" (14) there was an error in 14-bit
        temp_cw(14) <= not data_encoded(14) when c="1110" and p='1' else data_encoded(14);

        --when c="1101" (13) there was an error in 13-bit
        temp_cw(13) <= not data_encoded(13) when c="1101" and p='1' else data_encoded(13);

        --when c="1100" (12) there was an error in 12-bit
        temp_cw(12) <= not data_encoded(12) when c="1100" and p='1' else data_encoded(12);

        --when c="1011" (11) there was an error in 11-bit
        temp_cw(11) <= not data_encoded(11) when c="1011" and p='1' else data_encoded(11);

        --when c="1010" (10) there was an error in 10-bit
        temp_cw(10) <= not data_encoded(10) when c="1010" and p='1' else data_encoded(10);

        --when c="1001" (9) there was an error in 9-bit
        temp_cw(9) <= not data_encoded(9) when c="1001" and p='1' else data_encoded(9);

        --when c="1000" (8) there was an error in 8-bit
        temp_cw(8) <= not data_encoded(8) when c="1000" and p='1' else data_encoded(8);

        --when c="0110" (6) there was an error in 6-bit
        temp_cw(6) <= not data_encoded(6) when c="0110" and p='1' else data_encoded(6);

        --when c="0101" (5) there was an error in 5-bit
        temp_cw(5) <= not data_encoded(5) when c="0101" and p='1' else data_encoded(5);

        --when c="0100" (4) there was an error in 4-bit
        temp_cw(4) <= not data_encoded(4) when c="0100" and p='1' else data_encoded(4);

        --when c="0010" (2) there was an error in 2-bit
        temp_cw(2) <= not data_encoded(2) when c="0010" and p='1' else data_encoded(2);

        temp_cw(7) <= data_encoded(7);
        temp_cw(3) <= data_encoded(3);
        temp_cw(1 downto 0) <= data_encoded(1 downto 0);


        --set data_out with the correction
        data_out <= temp_cw(14 downto 8) & temp_cw(6 downto 4) & temp_cw(2);
        
    end beh;