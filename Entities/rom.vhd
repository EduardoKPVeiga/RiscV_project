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
        -- caso endereco => conteudo
        0   => "0000001001001111", -- addi R0,zero,15
        1   => "0000101001000011", -- addi R1,zero,3
        2   => "0000000110100001", -- sub  R0,R0,R1
        3   => "0001101001010000", -- addi R2,zero,16
        4   => "0001100111000000", -- add  R2,R2,R0
        5   => "0000000000000000", -- nop
        6   => "0000000000000000", -- nop
        7   => "0000000000000000", -- nop
        8   => "0000000000000000", -- nop
        9   => "0000000000000000", -- nop
        10  => "1111000000000000", -- jmp  R0
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