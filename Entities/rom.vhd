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
        0   => "0000000000100001", -- 0d33
        1   => "1000000000000000", -- 0d32768
        2   => "0000000000000001", -- 0d1
        3   => "0000000000000101", -- 0d5
        4   => "1000000000001111", -- 0d32783
        5   => "0000000000100011", -- 0d35
        6   => "1111000000111010", -- 0d61498
        7   => "0000000000100000", -- 0d32
        8   => "0000000000101100", -- 0d44
        9   => "0000000000000000", -- 0d0
        10  => "0000000000001100", -- 0d12
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