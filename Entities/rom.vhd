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
        3   => B"00000_001110_00010", -- add R1,R2
        4   => B"00000_001110_00010", -- add R1,R2
        5   => B"00001_111011_00001", -- sth R1,R1
        6   => B"00001_001110_00010", -- add R1,R2
        7   => B"00001_000111_00000", -- cmp R1,R0
        8   => B"11111_1011_100_1010", -- bne -4 
        ---------ddddd_oooo_ddd_cccc
----------------------------------------------------------preenchido a ram até o end 32
        9    => B"00001_010010_00100", -- addi R1,zero,4
        10   => B"00010_010010_00010", -- addi R2,zero,2
        11   => B"00111_111011_00001", -- sth R7,R1   
        12   => B"00001_001110_00010", -- add R1,R2
        13   => B"00001_000111_00000", -- cmp R1,R0
        14   => B"11111_1011_100_1010", -- bne -4 
----------------------------------------------------------TIRADO MULTIPLOS DE 2
        15   => B"00001_010010_00110", -- addi R1,zero,6
        16   => B"00010_010010_00011", -- addi R2,zero,3
        17   => B"00111_111011_00001", -- sth R7,R1   
        18   => B"00001_001110_00010", -- add R1,R2
        19   => B"00001_000111_00000", -- cmp R1,R0
        20   => B"11111_1011_100_1010", -- bne -4 
----------------------------------------------------------TIRADO MULTIPLOS DE 3
        21   => B"00001_010010_01010", -- addi R1,zero,10
        22   => B"00010_010010_00101", -- addi R2,zero,5
        23   => B"00111_111011_00001", -- sth R7,R1   
        24   => B"00001_001110_00010", -- add R1,R2
        25   => B"00001_000111_00000", -- cmp R1,R0
        26   => B"11111_1011_100_1010", -- bne -4 
----------------------------------------------------------TIRADO MULTIPLOS DE 5
        27   => B"00001_010010_00010", -- addi R1,zero,2
        28   => B"00010_010010_00001", -- addi R2,zero,1
        30   => B"00111_111001_00001", -- ldh R7,R1   
        31   => B"00001_001110_00010", -- add R1,R2
        32   => B"00001_000111_00000", -- cmp R1,R0
        33   => B"11111_1011_100_1010", -- bne -4 









        --   => B"00000_111011_00100", -- sth R0,R4
        --  => B"00000_111001_00110", -- ldh R2,R4 -> R0 <= RAM[R4];



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
