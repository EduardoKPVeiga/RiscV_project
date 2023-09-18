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

    signal a, b, res    : unsigned(15 downto 0);
    signal op_code      : unsigned(1 downto 0);

begin
    uut: ula port map(
        a       <= a,
        b       <= b,
        res     <= res,
        op_code <= op_code
    );

    testbench_ula : process()
    begin
        a       <= "0000000000100000";
        b       <= "1010000001010010";
        op_code <= '00';
        wait for 50 ns;

        a       <= "0000000000100000";
        b       <= "1010000001010010";
        op_code <= '01';
        wait for 50 ns;

        a       <= "0000000000100000";
        b       <= "1010000001010010";
        op_code <= '10';
        wait for 50 ns;
    end process testbench_ula;
end architecture;