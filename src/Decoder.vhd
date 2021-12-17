library ieee;
use ieee.std_logic_1164.all;

entity Decoder is
    port( 
        clk : in std_logic;
        resetn : in std_logic;
        data_encoded : in std_logic_vector(15 downto 0);
        data_out : out std_logic_vector(10 downto 0);
        NE_bit : out std_logic;
        SEC_bit : out std_logic;
        DED_bit : out std_logic
	);
			
end Decoder;

architecture beh of Decoder is

    signal c_det : std_logic_vector(3 downto 0);
    signal c_corr : std_logic_vector(3 downto 0);
    signal p_det : std_logic;
    signal p_corr : std_logic;
    signal temp_out : std_logic_vector(10 downto 0);

    component Error_Detect is
        port( 
            data_encoded : in std_logic_vector(15 downto 0);
            c : out std_logic_vector(3 downto 0);
            p : out std_logic
	    );			
    end component Error_Detect;

    component Error_Correct is
        port( 
            data_encoded : in std_logic_vector(15 downto 0);
            c : in std_logic_vector(3 downto 0);
            p : in std_logic;
            data_out : out std_logic_vector(10 downto 0)
	    );			
    end component Error_Correct;

    component DFF_N is
        generic( N : natural := 8);   
        port( 
            clk     : in std_logic;
            a_rstn : in std_logic;
            en      : in std_logic;
            d       : in std_logic_vector(N - 1 downto 0);
            q       : out std_logic_vector(N - 1 downto 0)
        );                
    end component DFF_N;

    begin
        --***************************************************************************************************************
                                --ERROR DETECTION
        --***************************************************************************************************************

        detect: Error_Detect 
        port map(
            data_encoded => data_encoded,
            c => c_det,
            p => p_det
        );

        --no error (c=0 and p=0)
        NE_bit <= '1' when c_det="0000" and p_det='0' else '0';
        
        --single error ((c/=0 and p=1) or (c=0 and p=1))
        SEC_bit <= '1' when c_det/="0000" and p_det='1' else 
                    '1' when c_det="0000" and p_det='1' else '0';

        --double error (c/=0 and p=0)
        DED_bit <= '1' when c_det/="0000" and p_det='0' else '0';

        reg_middle_c: DFF_N
        generic map( N => 4)
        port map( 
            clk     => clk,
            a_rstn =>  resetn,
            en      => '1',
            d       => c_det,
            q       => c_corr
        );

        reg_middle_p: DFF_N
        generic map( N => 1)
        port map( 
            clk     => clk,
            a_rstn =>  resetn,
            en      => '1',
            d       => p_det,
            q       => p_corr
        );
        

        --***************************************************************************************************************
                                --ERROR CORRECTION
        --***************************************************************************************************************

        correct: Error_correct 
        port map(
            data_encoded => data_encoded,
            c => c_corr,
            p => p_corr,
            data_out => temp_out
        );

        data_out <= temp_out;
    end beh;