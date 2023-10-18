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


    -- Teste 1: Reset
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    wait for 10 ns;

    -- Teste 2: Estado 0 (fetch)
    wait for 10 ns;

    -- Teste 3: Estado 1 (decode/execute)
    wait for 10 ns;

    -- Teste 4: Instrução de Salto (opcode 1111)
    instruction <= "1111000000111010";
    wait for 10 ns;
    wait for 10 ns;

    -- Teste 5: Outra Instrução (opcode diferente de 1111)
    instruction <= "0000000000001100";
    wait for 10 ns;
    wait for 10 ns;

    wait;

end architecture;
