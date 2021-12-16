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
    signal c : std_logic_vector;

    begin
        -- generation of control bits
        c1 <= (data_encoded(0) xor data_encoded(2)) xor (data_encoded(4) xor data_encoded(6)) xor (data_encoded(8) xor data_encoded(10)) xor (data_encoded(12) xor data_encoded(14));
        c2 <= (data_encoded(1) xor data_encoded(2)) xor (data_encoded(5) xor data_encoded(6)) xor (data_encoded(9) xor data_encoded(10)) xor (data_encoded(13) xor data_encoded(14));
        c4 <= (data_encoded(3) xor data_encoded(4)) xor (data_encoded(5) xor data_encoded(6)) xor (data_encoded(11) xor data_encoded(12)) xor (data_encoded(13) xor data_encoded(14));
        c8 <= (data_encoded(7) xor data_encoded(8)) xor (data_encoded(9) xor data_encoded(10)) xor (data_encoded(11) xor data_encoded(12)) xor (data_encoded(13) xor data_encoded(14));

        p <= (data_encoded(0) xor data_encoded(1)) xor (data_encoded(2) xor data_encoded(3)) xor (data_encoded(4) xor data_encoded(5)) xor (data_encoded(6)) xor data_encoded(7)) xor
        (data_encoded(8) xor data_encoded(9)) xor (data_encoded(10) xor data_encoded(11)) xor (data_encoded(12) xor data_encoded(13)) xor (data_encoded(14) xor data_encoded(15));

        c <= (c1 and c2) and (c4 and c8);

        
    end beh;