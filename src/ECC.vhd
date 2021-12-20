library ieee;
use ieee.std_logic_1164.all;

entity ECC is
    port( 
        clk : in std_logic;
        resetn : in std_logic;
        data_in : in std_logic_vector(10 downto 0);
        data_out : out std_logic_vector(10 downto 0);
        NE_bit : out std_logic;
        SEC_bit : out std_logic;
        DED_bit : out std_logic
	);
			
end ECC;

architecture beh of ECC is  
    signal output_inputreg : std_logic_vector(10 downto 0);
    signal output_encoder : std_logic_vector(15 downto 0);
    signal output_encoder_reg : std_logic_vector(15 downto 0);
    signal output_decoder_data : std_logic_vector(10 downto 0);
    signal output_decoder_NE : std_logic_vector(0 downto 0);
    signal output_decoder_SEC : std_logic_vector(0 downto 0);
    signal output_decoder_DED : std_logic_vector(0 downto 0);
    signal output_decoderreg_data : std_logic_vector(10 downto 0);
    signal output_decoderreg_NE : std_logic_vector(0 downto 0);
    signal output_decoderreg_SEC : std_logic_vector(0 downto 0);
    signal output_decoderreg_DED : std_logic_vector(0 downto 0);

    component Encoder is
        port( 
            data_in : in std_logic_vector(10 downto 0);
            data_encoded : out std_logic_vector(15 downto 0)
	    );			
    end component Encoder;

    component Decoder is
        port( 
            data_encoded : in std_logic_vector(15 downto 0);
            data_out : out std_logic_vector(10 downto 0);
            NE_bit : out std_logic;
            SEC_bit : out std_logic;
            DED_bit : out std_logic
        );			
    end component Decoder;

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

        --register for data_in bit
        input_reg: DFF_N
        generic map( N => 11)
        port map( 
            clk     => clk,
            a_rstn =>  resetn,
            en      => '1',
            d       => data_in,
            q       => output_inputreg
        );
        
        --encoder
        encoder_block: Encoder
        port map( 
            data_in => output_inputreg,
            data_encoded => output_encoder
        );

        --register for output of the encoder
        out_encoder_reg: DFF_N
        generic map( N => 16)
        port map( 
            clk     => clk,
            a_rstn =>  resetn,
            en      => '1',
            d       => output_encoder,
            q       => output_encoder_reg
        );

        --decoder
        decoder_block: Decoder 
        port map( 
            data_encoded => output_encoder_reg,
            data_out => output_decoder_data,
            NE_bit => output_decoder_NE(0),
            SEC_bit => output_decoder_SEC(0),
            DED_bit => output_decoder_DED(0)
        );

        --register for output of the decoder (data)
        out_decoder_reg_data: DFF_N
        generic map( N => 11)
        port map( 
            clk     => clk,
            a_rstn =>  resetn,
            en      => '1',
            d       => output_decoder_data,
            q       => output_decoderreg_data
        );

        data_out <= output_decoderreg_data;

        --register for output of the decoder (NE)
        out_decoder_reg_NE: DFF_N
        generic map( N => 1)
        port map( 
            clk     => clk,
            a_rstn =>  resetn,
            en      => '1',
            d       => output_decoder_NE,
            q       => output_decoderreg_NE
        );

        NE_bit <= output_decoderreg_NE(0);

        --register for output of the decoder (SEC)
        out_decoder_reg_SEC: DFF_N
        generic map( N => 1)
        port map( 
            clk     => clk,
            a_rstn =>  resetn,
            en      => '1',
            d       => output_decoder_SEC,
            q       => output_decoderreg_SEC
        );

        SEC_bit <= output_decoderreg_SEC(0);

        --register for output of the decoder (DED)
        out_decoder_reg_DED: DFF_N
        generic map( N => 1)
        port map( 
            clk     => clk,
            a_rstn =>  resetn,
            en      => '1',
            d       => output_decoder_DED,
            q       => output_decoderreg_DED
        );

        DED_bit <= output_decoderreg_DED(0);

    end beh;