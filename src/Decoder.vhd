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
        c1 <= ;
        c2 <= ;
        c4 <= ;
        c8 <= ;

        p <= ;

        c <= (c1 and c2) and (c4 and c8);

        
    end beh;