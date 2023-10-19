library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity main_tb is
end entity;

architecture sim of main_tb is
    component main
        port (
            clk       : in std_logic;
            reset     : in std_logic;
            state     : out std_logic;
            instruction: out unsigned(15 downto 0)
        );
    end component;
    constant period_time    : time      := 100 ns;
    signal finished         : std_logic := '0';
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '1'; -- Inicia com reset ativado
    signal state        : std_logic;
    signal instruction  : unsigned(15 downto 0);

begin
    uut: main
        port map (
            clk         => clk,
            reset       => reset,
            state       => state,
            instruction => instruction
        );

    -- Processo de clock


    clk_proc: process
    begin
        while finished /= '1' loop
            clk    <= '0';
            wait for period_time / 2;
            clk    <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;
    geral: process
    begin
        instruction <= "0000000000001111";
        wait for period_time * 15;
        finished <= '1';
        wait;
    end process;

end architecture;
