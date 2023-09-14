library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux2x1 is
    port(
        sel             :   in std_logic;
        entr0, entr1    :   in std_logic;
        saida           :   out std_logic
    );
end entity;

architecture a_mux2x1 of mux2x1 is
begin
    saida   <=  entr0   when    sel='0' else
                entr1   when    sel='1' else
                '0';
end architecture;
