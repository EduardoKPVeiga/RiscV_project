library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity soma_e_subtrai_tb is
end entity;

architecture a_soma_e_subtrai_tb of soma_e_subtrai_tb is
    component soma_e_subtrai
        port (   
        x,y       :  in unsigned(7 downto 0);
        soma,subt :  out unsigned(7 downto 0)
        );
    end component;
    signal x, y, soma, subt: unsigned(7 downto 0);

begin
    uut : soma_e_subtrai
    port map(
        x   => x,
        y   => y,
        soma => soma,
        subt => subt);
    process
    begin
        x <= "00001001";  -- 9
        y <= "00000101";  -- 5

        wait for 50 ns;

        x <= "11111001";  -- -7 (signed)
        y <= "00001011";  -- 11

        wait for 50 ns;
        wait;
        end process;
    end architecture;