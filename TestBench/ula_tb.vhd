library ieee;
use ieee.std_logic_1164.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
    component ula
        port(
            a,b         : in  unsigned(15 downto 0);
            op_code     : in  unsigned(1 downto 0);
            res         : out unsigned(15 downto 0)
        );
    end component;

    signal a_signal, b_signal, res_signal   : unsigned(15 downto 0);
    signal op_code_signal                   : unsigned(1 downto 0);

begin
    uut: ula port map(
        a       => a_signal,
        b       => b_signal,
        res     => res_signal,
        op_code => op_code_signal
    );

    process
    begin
        a_signal       <= "0000000000100000";
        b_signal       <= "1010000001010010";
        op_code_signal <= "00";
        wait for 50 ns;

        a_signal       <= "0000000000100000";
        b_signal       <= "1010000001010010";
        op_code_signal <= "01";
        wait for 50 ns;

        a_signal       <= "0000000000100000";
        b_signal       <= "1010000001010010";
        op_code_signal <= "10";
        wait for 50 ns;
    end process;
end architecture;