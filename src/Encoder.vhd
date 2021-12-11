library ieee;
use ieee.std_logic_1164.all;


entity Encoder is
    port( 
        data_in : in std_logic_vector(10 downto 0);
        data_encoded : out std_logic_vector(15 downto 0)
	);
			
end Encoder;

architecture beh of Encoder is   
    signal p_uno : std_logic;
    signal p_due : std_logic;
    signal p_quattro : std_logic;
    signal p_otto : std_logic;
    signal p_extra : std_logic;

    begin
        -- generation of parity bits
        p_uno <= data_in(0) xor data_in(1) xor data_in(3) xor data_in(4) xor data_in(6) xor data_in(8) xor data_in(10);
        p_due <= data_in(0) xor data_in(2) xor data_in(3) xor data_in(5) xor data_in(6) xor data_in(9) xor data_in(10);
        p_quattro <= data_in(1) xor data_in(2) xor data_in(3) xor data_in(7) xor data_in(8) xor data_in(9) xor data_in(10);
        p_otto <= data_in(4) xor data_in(5) xor data_in(6) xor data_in(7) xor data_in(8) xor data_in(9) xor data_in(10);

        -- generation of extra parity bit
        p_extra <= data_in(0) xor data_in(1) xor data_in(2) xor data_in(3) xor data_in(4) xor data_in(5) xor data_in(6)
                xor data_in(7) xor data_in(8) xor data_in(9) xor data_in(10)
                xor p_uno xor p_due xor p_quattro xor p_otto;

        --set output bits
        data_encoded <= (p_uno, p_due , data_in(0), p_quattro, data_in(1), data_in(2), data_in(3), p_otto, data_in(4), data_in(5), data_in(6),
                    data_in(7), data_in(8), data_in(9), data_in(10), p_extra);

        --data_encoded <= p_extra & data_in(10) & data_in(9) & data_in(8) & data_in(7) & data_in(6) & data_in(5) & data_in(4)
                        --& p_otto & data_in(3) & data_in(2) & data_in(1) & p_quattro & data_in(0) & p_due & p_uno;
    end beh;