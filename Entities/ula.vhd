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
    signal mult        : unsigned(31 downto 0);
begin
    mult    <=  x * y;
    res     <=  x + y    when op_code = "00" else
                x - y    when op_code = "01" else
                mult(15 downto 0) when op_code = "10" else
                "0000000000000000";
end architecture;