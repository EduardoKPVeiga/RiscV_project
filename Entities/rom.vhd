------------------------------------------------------------------------------- 
--
-- Last Version
-- Date: 13/11/2023
--
------------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rom is
    port (
        clk     : in std_logic;
        address : in unsigned(6 downto 0);
        data    : out unsigned(15 downto 0)
    );
end entity;

architecture a_rom of rom is

    type mem is array (0 to 127) of unsigned(15 downto 0);

    constant conteudo_rom : mem := (
        -- caso endereco => conteudo //nossos registradores são iniciados com zero
        
        1   => B"00000_010010_11111", -- addi R0,zero,31
        2   => B"00001_010010_11011", -- addi R1,zero,27
        3   => B"00010_010010_00111", -- addi R2,zero,7
        4   => B"00011_010010_00011", -- addi R3,zero,3
        5   => B"00100_010010_00100", -- addi R4,zero,4
        6   => B"00101_010010_10111", -- addi R5,zero,23
        7   => B"00000_111011_00100", -- sth R0,R4
        -- abaixo: casos omissos => (zero em todos os bits)
        others => (others => '0')
    );

begin
    process(clk)
    begin
        if(rising_edge(clk)) then
            data <= conteudo_rom(to_integer(address));
        end if;
    end process;
end architecture;