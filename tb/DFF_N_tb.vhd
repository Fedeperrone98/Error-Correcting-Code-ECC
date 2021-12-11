library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

--entity declaration
entity DFF_N_tb is
end DFF_N_tb;

--architecture body
architecture rtl of DFF_N_tb is

    constant clk_period : time := 100 ns;
    constant Nbit : positive := 8;

    component DFF_N
    generic( N : natural := 8);		
    port( 
      clk     : in std_logic;
      a_rst_n : in std_logic;
      en      : in std_logic;
      d       : in std_logic_vector(N - 1 downto 0);
      q       : out std_logic_vector(N - 1 downto 0)
      );
    end component;

    signal clk : std_logic := '0';
    signal a_rst_n : std_logic := '0';
    signal d: std_logic_vector(Nbit-1 downto 0) := (others => '0');
    signal en : std_logic := '0';
    signal q: std_logic_vector(Nbit-1 downto 0);
    signal testing : boolean := true;

    begin
        clk <= not clk after clk_period/2 when testing else '0';

        dut: DFF_N
        generic map(
            N => Nbit
        )
        port map(
            clk =>clk,
            a_rst_n => a_rst_n,
            d => d,
            en => en,
            q => q
        );

        stimulus : process
        begin
            a_rst_n <= '0';
            en <= '0';
            d <= (others => '0');
            wait for 200 ns;
            a_rst_n <= '1';
            en <= '1';
            wait until rising_edge(clk);
            d <= "00000001";
            wait for 100 ns;
            d <= "00000001";
            wait for 100 ns;
            d <= "00000110";
            wait for 100 ns;
            d <= "11111111";
            wait for 100 ns;
            d <= "00000000";
            wait for 500 ns;
            testing <= false;
        end process;
    
    end rtl;