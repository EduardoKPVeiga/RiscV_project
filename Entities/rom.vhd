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
        0   => "0000001001000000", -- addi R0,zero,1
        1   => "0000101001000001", -- addi R1,zero,31
        2   => "0000000101111110", -- bch
        3   => "0001101001000001", -- addi R2,zero,1
        4   => "0001101001000011", -- addi R2,zero,5
        5   => "0000000001100001", -- jmp 1



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