library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity state_machine is
    port (
        clk     : in std_logic;
        state   : out bit;
        rst     : in std_logic
    );
end entity;

architecture a_state_machine of state_machine is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            state <= '0';
        elsif rising_edge(clk) then
            state <= not state;
        end if;
    end process;
end architecture;