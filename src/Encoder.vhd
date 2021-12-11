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
        -- generation of parity bits
        p1 <= data_in(0) xor data_in(1) xor data_in(3) xor data_in(4) xor data_in(6) xor data_in(8) xor data_in(10);
        p2 <= data_in(0) xor data_in(2) xor data_in(3) xor data_in(5) xor data_in(6) xor data_in(9) xor data_in(10);
        p4 <= data_in(1) xor data_in(2) xor data_in(3) xor data_in(7) xor data_in(8) xor data_in(9) xor data_in(10);
        p8 <= data_in(4) xor data_in(5) xor data_in(6) xor data_in(7) xor data_in(8) xor data_in(9) xor data_in(10);

        -- generation of extra parity bit
        p16 <= data_in(0) xor data_in(1) xor data_in(2) xor data_in(3) xor data_in(4) xor data_in(5) xor data_in(6)
                xor data_in(7) xor data_in(8) xor data_in(9) xor data_in(10)
                xor p1 xor p2 xor p4 xor p8;

        --set output bits
        data_out <= p1 & p2 & data_in(0) & p4 & data_in(1) & data_in(2) & data_in(3) & p8 & data_in(4) & data_in(5) & data_in(6)
                    & data_in(7) & data_in(8) & data_in(9) & data_in(10) & p16;
    end beh;