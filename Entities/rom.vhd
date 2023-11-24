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
        1   => B"00001_010010_00001", -- addi R1,zero,1
        2   => B"00010_010010_00001", -- addi R2,zero,1
        3   => B"00011_010010_00010", -- addi R3,zero,2
        4   => B"00100_010010_00001", -- addi R4,zero,1
        5   => B"00001_111011_00001", -- sth R1,R1
        6   => B"00001_001110_00010", -- add R1,R2
        7   => B"00001_000111_00000", -- cmp R1,R0
        8   => B"11111_1011_100_1010", -- bne -4 
        ---------ddddd_oooo_ddd_cccc
----------------------------------------------------------preenchido a ram até o end 32
        9    => B"00001_010010_00001", -- addi R1,zero,1
        10   => B"00010_010010_00001", -- addi R2,zero,1
        11   => B"00011_010010_00000", -- addi R3,zero,0
        12   => B"00110_010010_00111", -- addi R6,zero,0

        13   => B"00001_001110_00010", -- add R1,R2
        14   => B"00011_111001_00001", -- ldh R3,R1   
        15   => B"00011_000111_00010", -- cmp R3,R2  -> VE SE N É 0
        16   => B"11111_1011_100_1010", -- bne -4 
-----------------------------------------------------------------------------------------------------
        17   => B"00100_010010_00000", -- addi R4,zero,0
        18   => B"00100_001110_00011", -- add R4,R3
        19   => B"00100_001110_00011", -- add R4,R3
        20   => B"00111_111011_00100", -- sth R7,R1
        21   => B"00100_000111_00000", -- cmp R4,R0
        22   => B"11111_1011_100_1010", -- bne -4 
        23   => B"00011_000111_00110", -- cmp R3,R6
        24   => B"11110_1011_100_1010", -- bne -12  11110 100
------------------------------------------------------------------------------------------------
        34   => B"00001_010010_00010", -- addi R1,zero,2
        35   => B"00010_010010_00001", -- addi R2,zero,1
        36   => B"00111_111001_00001", -- ldh R7,R1   
        37   => B"00001_001110_00010", -- add R1,R2
        38   => B"00001_000111_00000", -- cmp R1,R0
        39   => B"11111_1011_100_1010", -- bne -4 
----------------------------------------------------------Colocando no R7 os nros primos

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
