library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
    component ula
        port(
            x,y         : in  unsigned(15 downto 0);
            op_code     : in  unsigned(1 downto 0);
            res         : out unsigned(15 downto 0)
        );
    end component;

    signal x, y, res                 : unsigned(15 downto 0);
    signal op_code                   : unsigned(1 downto 0);

begin
    uut : ula
    port map(
        x       => x,
        y       => y,
        res     => res,
        op_code => op_code
    );

    process
    --dois casos para cada situação:
    -- 1° x e y positivos
    -- 2° x positivo e y negativo
    begin
        x       <= "0000000000001010"; --10
        y       <= "0000000000011110"; --30
        op_code <= "00";--soma
        wait for 50 ns;
        x       <= "0000000000001010"; --10
        y       <= "1111111111111000"; -- -8
        wait for 50 ns;
        x       <= "0000000000001010"; --10
        y       <= "0000000000011110"; --30
        op_code <= "01";--subs
        wait for 50 ns;
        x       <= "0000000000001010"; --10
        y       <= "1111111111111000"; -- -8
        wait for 50 ns;
        x       <= "0000000000000001"; --10
        y       <= "0000000000000001"; -- -8
        op_code <= "10";--multi

        wait;
    end process;
end architecture;