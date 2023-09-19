library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula is
    port (
        a,b         : in  unsigned(15 downto 0);
        op_code     : in  unsigned(1 downto 0);
        res         : out unsigned(15 downto 0)
    );
end entity;

architecture a_ula of ula is
    
    signal sum              : unsigned(15 downto 0) := a + b;
    signal subt             : unsigned(15 downto 0) := a - b;
    signal mult             : unsigned(31 downto 0) := a * b;
    signal mult_truncate    : unsigned(15 downto 0);
    signal res_mux          : unsigned(15 downto 0);
    
    component mux16bits is
        port(
            op_code         : in  unsigned(1 downto 0);
            a,b,c           : in  unsigned(15 downto 0);
            mux_out         : out unsigned(15 downto 0)
        );
    end component;

begin
    mult_truncate <= resize(mult, 15);
    uut: mux16bits port map(
        op_code => op_code,
        a       => sum,
        b       => subt,
        c       => mult_truncate,
        mux_out => res_mux
    );
    res <= res_mux;
end architecture;