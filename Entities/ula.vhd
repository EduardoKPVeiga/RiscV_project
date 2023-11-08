library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula is
    port (
        x,y         : in  unsigned(15 downto 0);
        op_code     : in  unsigned(1 downto 0);
        res         : out unsigned(15 downto 0);
        carry       : out std_logic
    );
end entity;
architecture a_ula of ula is
    signal mult        : unsigned(31 downto 0);
    signal x_17, y_17, soma_17: unsigned(16 downto 0);
begin
    x_17 <= '0' & x;      
    y_17 <= '0' & y;
    soma_17 <= x_17 +  y_17;
    carry <= soma_17(16) when op_code = "10" else
             '0' when (op_code = "01") and (x >=y ) else
             '1'  when (op_code = "01");
    mult    <=  x * y;
    res     <=  soma_17(15 downto 0)    when op_code = "10" else
                x - y                   when op_code = "01" else
                mult(15 downto 0)       when op_code = "11" else
                "0000000000000000";
end architecture;