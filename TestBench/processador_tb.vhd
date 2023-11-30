------------------------------------------------------------------------------- 
--
-- Last Version
-- Date: 25/10/2023
--
------------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processador_tb is
end entity;

architecture a_processador_tb of processador_tb is
    
    component processador
        port (
            clk_proc    : in std_logic;
            rst_proc    : in std_logic
        );
    end component;

    constant period_time    : time      := 100 ns;
    signal finished         : std_logic := '0';

    signal clk_s    : std_logic := '0';
    signal rst_s    : std_logic := '1'; -- Inicia com reset ativado

begin
    uut: processador
        port map (
            clk_proc    => clk_s,
            rst_proc    => rst_s
        );

    -- Processo de clock
    clk_process : process
    begin
        while finished /= '1' loop
            clk_s    <= '0';
            wait for period_time / 2;
            clk_s    <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_process;

    global_process : process
    begin
        wait for period_time;
        rst_s <= '0';
        wait for 2600 * period_time;
        finished <= '1';
        wait;
    end process;

end architecture;
