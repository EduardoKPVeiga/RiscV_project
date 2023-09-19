library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula is
    port (
        x,y         : in  unsigned(15 downto 0);
        op_code     : in  unsigned(1 downto 0);
        res         : out unsigned(15 downto 0)
    );
end entity;

architecture a_ula of ula is
    
    signal a              : unsigned(15 downto 0) := x + y;
    signal b             : unsigned(15 downto 0) := x - y;
    signal mult             : unsigned(31 downto 0) := x * y;
    signal c    : unsigned(15 downto 0);
    signal mux_out          : unsigned(15 downto 0);
    
    component mux16bits is
        port(
            op_code         : in  unsigned(1 downto 0);
            a,b,c           : in  unsigned(15 downto 0);
            mux_out         : out unsigned(15 downto 0)
        );
    end component;

begin
    a <= x;
    b <= y;
    c <= resize(mult, 15);
    uut: mux16bits port map(
        op_code => op_code,
        a       => a,
        b       => b,
        c       => c,
        mux_out => mux_out
    );
    res <= mux_out;
end architecture;