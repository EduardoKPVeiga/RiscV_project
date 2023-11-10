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
        
        0   => "0000001001000001", -- addi R0,zero,1
        1   => "0011001001011110", -- addi R6,zero,30 
        2   => "0010000111000011", -- add R4,R4,R3
        3   => "0001100111000000", -- add R3,R3,R0
        4   => "0001100011100110", -- cmp R3 < R6    0001100011100110  , vou tentar inverter os registradores 0011000011100011
        5   => "1111110111011010", -- bne -3  101100
        6   => "0010100111000100", -- add R5,R5,R4 a
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