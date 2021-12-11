library ieee;
use ieee.std_logic_1164.all;


entity Encoder is
    port( 
        data_in : in std_logic_vector(10 downto 0);
        data_out : out std_logic_vector(15 downto 0)
	);
			
end Encoder;

architecture beh of Encoder is   
    signal p1 : std_logic;
    signal p2 : std_logic;
    signal p4 : std_logic;
    signal p8 : std_logic;
    signal p16 : std_logic;

    begin
        p1 <= data_in(0) xor data_in(1) xor data_in(3) xor data_in(4) xor data_in(6) xor data_in(8) xor data_in(10);
    end beh;