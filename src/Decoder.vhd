library ieee;
use ieee.std_logic_1164.all;

entity Decoder is
    port( 
        data_encoded : in std_logic_vector(15 downto 0);
        data_out : out std_logic_vector(10 downto 0);
        NE_bit : out std_logic;
        SEC_bit : out std_logic;
        DED_bit : out std_logic
	);
			
end Decoder;

architecture beh of Decoder is
    signal c1 : std_logic;
    signal c2 : std_logic;
    signal c4 : std_logic;
    signal c8 : std_logic;
    signal p : std_logic;
    signal c : std_logic_vector(3 downto 0);
    signal temp_cw : std_logic_vector(15 downto 0);

    begin
        -- generation of control bits
        c1 <= (data_encoded(0) xor data_encoded(2)) xor (data_encoded(4) xor data_encoded(6)) xor (data_encoded(8) xor data_encoded(10)) xor (data_encoded(12) xor data_encoded(14));
        c2 <= (data_encoded(1) xor data_encoded(2)) xor (data_encoded(5) xor data_encoded(6)) xor (data_encoded(9) xor data_encoded(10)) xor (data_encoded(13) xor data_encoded(14));
        c4 <= (data_encoded(3) xor data_encoded(4)) xor (data_encoded(5) xor data_encoded(6)) xor (data_encoded(11) xor data_encoded(12)) xor (data_encoded(13) xor data_encoded(14));
        c8 <= (data_encoded(7) xor data_encoded(8)) xor (data_encoded(9) xor data_encoded(10)) xor (data_encoded(11) xor data_encoded(12)) xor (data_encoded(13) xor data_encoded(14));

        p <= (data_encoded(0) xor data_encoded(1)) xor (data_encoded(2) xor data_encoded(3)) xor (data_encoded(4) xor data_encoded(5)) xor (data_encoded(6) xor data_encoded(7)) xor
             (data_encoded(8) xor data_encoded(9)) xor (data_encoded(10) xor data_encoded(11)) xor (data_encoded(12) xor data_encoded(13)) xor (data_encoded(14) xor data_encoded(15));

        c <= c8 & c4 & c2 & c1;

        -- when c=0 and p=1 there was an error in p16
        temp_cw(15) <= not(data_encoded(15)) when c="0000" and p='1' else data_encoded(15);

        --it must be taken into account that the position of the bits in data_encoded is shifted by 1 as it goes from 0 to 15
        
        --when c="1111" (15) there was an error in 14-bit
        temp_cw(14) <= not(data_encoded(14)) when c="1111" and p='1' else data_encoded(14);

        --when c="1110" (14) there was an error in 13-bit
        temp_cw(13) <= not(data_encoded(13)) when c="1110" and p='1' else data_encoded(13);
 
        --when c="1101" (13) there was an error in 12-bit
        temp_cw(12) <= not(data_encoded(12)) when c="1101" and p='1' else data_encoded(12);
 
        --when c="1100" (12) there was an error in 11-bit
        temp_cw(11) <= not(data_encoded(11)) when c="1100" and p='1' else data_encoded(11);
 
        --when c="1011" (11) there was an error in 10-bit
        temp_cw(10) <= not(data_encoded(10)) when c="1011" and p='1' else data_encoded(10);
 
        --when c="1010" (10) there was an error in 9-bit
        temp_cw(9) <= not(data_encoded(9)) when c="1010" and p='1' else data_encoded(9);
 
        --when c="1001" (9) there was an error in 8-bit
        temp_cw(8) <= not(data_encoded(8)) when c="1001" and p='1' else data_encoded(8);

        --when c="0111" (7) there was an error in 6-bit
        temp_cw(6) <= not(data_encoded(6)) when c="0111" and p='1' else data_encoded(6);
 
        --when c="0110" (6) there was an error in 5-bit
        temp_cw(5) <= not(data_encoded(5)) when c="0110" and p='1' else data_encoded(5);
 
        --when c="0101" (5) there was an error in 4-bit
        temp_cw(4) <= not(data_encoded(4)) when c="0101" and p='1' else data_encoded(4);
 
        --when c="0011" (3) there was an error in 2-bit
        temp_cw(2) <= not(data_encoded(2)) when c="0011" and p='1' else data_encoded(2);
 
        temp_cw(7) <= data_encoded(7);
        temp_cw(3) <= data_encoded(3);
        temp_cw(1 downto 0) <= data_encoded(1 downto 0);
 
 
        --set data_out with the correction
        data_out <= temp_cw(14 downto 8) & temp_cw(6 downto 4) & temp_cw(2);

        NE_bit <= '1' when c="0000" and p='0' else '0';
        SEC_bit <= '1' when (c/="0000" and p='1') or (c="0000" and p='1') else '0';
        DED_bit <= '1' when c/="0000" and p='0' else '0';
        
    end beh;