library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity soma_e_subtrai is
    port (   x,y              :  in unsigned(15 downto 0);
             soma,subt        :  out unsigned(15 downto 0);
             maior,x_negativo : out std_logic
    );
end entity;

architecture a_soma_e_subtrai of soma_e_subtrai is
    begin
       soma <= x+y;
       subt <= x-y;
       maior <= '1' when x>y else
            '0' when x<=y else
            '0';
       x_negativo <= x(15);
end architecture;


 