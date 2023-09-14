library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux8bits is
    port(
        entr0       :   in unsigned(7 downto 0);
        entr1       :   in unsigned(7 downto 0);
        entr2       :   in unsigned(7 downto 0);
        entr3       :   in unsigned(7 downto 0);
        sel         :   in unsigned(7 downto 0);
        saida       :   out unsigned(7 downto 0)
    );
end entity;

architecture a_mux8bits of mux8bits is
    begin
    saida   <=  entr0   when    sel="00"    else
                entr1   when    sel="01"    else
                entr2   when    sel="10"    else
                entr3   when    sel="11"    else
                "00000000";
end architecture;