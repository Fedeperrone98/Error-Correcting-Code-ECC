library ieee;
use ieee.std_logic_1164.all;


entity Error_Detect is
    port( 
        data_encoded : in std_logic_vector(15 downto 0);
        c : out std_logic_vector(3 downto 0);
        p : out std_logic
	);
			
end Error_Detect;

architecture beh of Error_Detect is   
    signal c1 : std_logic;
    signal c2 : std_logic;
    signal c4 : std_logic;
    signal c8 : std_logic;

    begin
        -- generation of control bits
        c1 <= (data_encoded(0) xor data_encoded(2)) xor (data_encoded(4) xor data_encoded(6)) xor (data_encoded(8) xor data_encoded(10)) xor (data_encoded(12) xor data_encoded(14));
        c2 <= (data_encoded(1) xor data_encoded(2)) xor (data_encoded(5) xor data_encoded(6)) xor (data_encoded(9) xor data_encoded(10)) xor (data_encoded(13) xor data_encoded(14));
        c4 <= (data_encoded(3) xor data_encoded(4)) xor (data_encoded(5) xor data_encoded(6)) xor (data_encoded(11) xor data_encoded(12)) xor (data_encoded(13) xor data_encoded(14));
        c8 <= (data_encoded(7) xor data_encoded(8)) xor (data_encoded(9) xor data_encoded(10)) xor (data_encoded(11) xor data_encoded(12)) xor (data_encoded(13) xor data_encoded(14));

        p <= (data_encoded(0) xor data_encoded(1)) xor (data_encoded(2) xor data_encoded(3)) xor (data_encoded(4) xor data_encoded(5)) xor (data_encoded(6) xor data_encoded(7)) xor
             (data_encoded(8) xor data_encoded(9)) xor (data_encoded(10) xor data_encoded(11)) xor (data_encoded(12) xor data_encoded(13)) xor (data_encoded(14) xor data_encoded(15));

        c <= c8 & c4 & c2 & c1;
        
    end beh;