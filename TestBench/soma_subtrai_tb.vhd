library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity soma_e_subtrai_tb is
end entity;

architecture a_soma_e_subtrai_tb of soma_e_subtrai_tb is
    component soma_e_subtrai
        port (   
        x,y              :  in unsigned(15 downto 0);
        soma,subt        :  out unsigned(15 downto 0);
        maior,x_negativo : out std_logic
        );
    end component;
    signal x, y, soma, subt: unsigned(15 downto 0);
    signal maior,x_negativo: std_logic;

begin
    uut : soma_e_subtrai
    port map(
        x   => x,
        y   => y,
        soma => soma,
        subt => subt,
        maior => maior,
        x_negativo => x_negativo
        );
    process
    begin
        x <= "0000000000001001";  -- 9
        y <= "0000000000000101";  -- 5 00000000

        wait for 200 ns;

        x <= "1111111111111101";  -- -3 (signed)
        y <= "0000000000001011";  -- 11

        wait for 200 ns;

        x <= "0000000001100100";  -- 200   0000000011001000
        y <= "0000000011001000";   -- 100
        wait for 200 ns;

        wait;
        end process;
    end architecture;

--Para abranger todos casos:
-- 1°X positivo Y positivo
-- 2°X negativo Y positivo
-- 3°X positivo Y negativo
-- 4°X negativo Y negativo
-- 5°X 10^2 Y comun  -32768 a 32768. -> numeros maximos em 16 bits
-- 6°X 10^3 Y comun  -32768 a 32768. -> numeros maximos em 16 bits
-- 7°X 10^4 Y comun  -32768 a 32768. -> numeros maximos em 16 bits
-- 8°X 10^2 Y comun  -32768 a 32768. -> numeros maximos em 16 bits
-- 9°X 10^3 Y comun  -32768 a 32768. -> numeros maximos em 16 bits
-- 10°X 10^4 Y comun  -32768 a 32768. -> numeros maximos em 16 bits
-- 11°X 10^2 Y 10^2  -32768 a 32768. -> numeros maximos em 16 bits
-- 12°X 10^3 Y 10^3  -32768 a 32768. -> numeros maximos em 16 bits
-- 13°X 10^4 Y 10^3  -32768 a 32768. -> numeros maximos em 16 bits
-- 14°X 10^3 Y 10^4  -32768 a 32768. -> numeros maximos em 16 bits
