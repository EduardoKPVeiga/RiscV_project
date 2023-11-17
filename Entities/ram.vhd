------------------------------------------------------------------------------- 
--
-- Last Version
-- Date: 09/11/2023
--
------------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram is
    port(
        clk         : in  std_logic;
        data_in     : in  unsigned(15 downto 0);
        address     : in  unsigned(6 downto 0);
        wr_en       : in  std_logic;
        data_out    : out unsigned(15 downto 0)
    );
end entity;

architecture a_ram of ram is
    type mem is array (0 to 127) of unsigned(15 downto 0);
    signal content_ram : mem;
begin
    process(clk, wr_en)
    begin
        if rising_edge(clk) then
            if wr_en='1' then
                content_ram(to_integer(address)) <= data_in;
            end if;
        end if;
    end process;
    data_out <= content_ram(to_integer(address));
end architecture;
   