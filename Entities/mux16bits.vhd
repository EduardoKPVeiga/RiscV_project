library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux16bits is
    port(
        op_code     : in  unsigned(1 downto 0);
        a,b,c       : in  unsigned(15 downto 0);
        mux_out     : out unsigned(15 downto 0)
    );
end entity;

architecture a_mux16bits of mux16bits is
begin
    mux_out <=  a when op_code = "00" else
                b when op_code = "01" else
                c when op_code = "10" else
                "0000000000000000";
end architecture;