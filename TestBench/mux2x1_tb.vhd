library ieee;
use ieee.std_logic_1164.all;

entity mux2x1_tb is
end;

architecture a_mux2x1_tb of mux2x1_tb is
    component mux2x1
        port(
            sel             :   in std_logic;
            entr0, entr1    :   in std_logic;
            saida           :   out std_logic
        );
    end component;

    signal entr0,entr1,sel,saida: std_logic;

    begin
        uut: mux2x1 port map(
            sel   => sel,
            entr0 => entr0,
            entr1 => entr1,
            saida => saida
        );

        process
        begin
            sel <= '0';
            entr0 <= '0';
            entr1 <= '0';
            wait for 50 ns;
            entr0 <= '0';
            entr1 <= '1';
            wait for 50 ns;
            entr0 <= '1';
            entr1 <= '0';
            wait for 50 ns;
            entr0 <= '1';
            entr1 <= '1';
            wait for 50 ns;
            wait;
            sel <= '1';
            entr0 <= '0';
            entr1 <= '0';
            wait for 50 ns;
            entr0 <= '0';
            entr1 <= '1';
            wait for 50 ns;
            entr0 <= '1';
            entr1 <= '0';
            wait for 50 ns;
            entr0 <= '1';
            entr1 <= '1';
            wait for 50 ns;
            wait;
        end process;
    end architecture;

