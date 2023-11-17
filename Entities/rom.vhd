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
        
        0   => B"00000_010010_11111", -- addi R0,zero,31
        1   => B"00000_111011_00100", -- sth R0,R4
        2   => B"00001_010010_11111", -- addi R1,zero,31
        3   => B"00010_111001_00100", -- ldh R0,R4
        4   => B"00011_010010_11111", -- addi R3,zero,31



        --salva no end da ram 4 pq é o r4 31 pq é o valor de r0 
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