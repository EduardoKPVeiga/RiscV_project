------------------------------------------------------------------------------- 
--
-- Last Version
-- Date: 22/10/2023
--
------------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity state_machine is
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        state   : out unsigned(1 downto 0)
    );
end entity;

architecture a_state_machine of state_machine is

    signal state_s  : unsigned(1 downto 0);

begin
    process(clk, rst)
    begin
        if rst = '1' then
            state_s <= "00";
        elsif rising_edge(clk) then
            if state_s = "10" then
                state_s <= "00";
            else
                state_s <= state_s + 1;
            end if;
        end if;
    end process;

    state <= state_s;
end architecture;