------------------------------------------------------------------------------- 
--
-- Last Version
-- Date: 22/10/2023
--
------------------------------------------------------------------------------- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine_tb is
end entity;

architecture a_state_machine_tb of state_machine_tb is
    component state_machine
        port (
            clk             : in std_logic;
            state           : out unsigned(1 downto 0);
            rst             : in std_logic
        );
    end component;

    signal clk_s            : std_logic;
    signal state_s          : unsigned(1 downto 0)  := "00";
    signal rst_s            : std_logic;

    constant period_time    : time      := 100 ns;
    signal finished_s       : std_logic := '0';

begin
    uut : state_machine
    port map (
        clk     => clk_s,
        state   => state_s,
        rst     => rst_s
    );

    clk_proc : process
    begin
        while finished_s /= '1' loop
            clk_s   <= '0';
            wait for period_time / 2;
            clk_s   <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    rst_proc : process
    begin
        rst_s <= '0';
        wait for period_time * 3;
        rst_s <= '1';
        wait for period_time;
        rst_s <= '0';
        wait for period_time * 3;
        finished_s <= '1';
        wait;
    end process rst_proc;
    
end architecture;