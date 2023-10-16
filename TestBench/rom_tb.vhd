library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity;

architecture a_rom_tb of rom_tb is
    component rom
        port (
            clk             : in std_logic;
            address         : in unsigned(6 downto 0);
            data            : out unsigned(15 downto 0)
        );
    end component;

    -- Signals for the component
    signal clk_s            : std_logic;
    signal address_s        : unsigned(6 downto 0);
    signal data_s           : unsigned(15 downto 0);

    -- For process
    constant period_time    : time      := 100 ns;
    signal finished_s         : std_logic := '0';

begin
    uut : rom
    port map (
        clk     => clk_s,
        address => address_s,
        data    => data_s
    );

    clk_proc: process
    begin
        while finished_s /= '1' loop
            clk_s   <= '0';
            wait for period_time / 2;
            clk_s   <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    address_proc: process
    begin
        address_s <= "0000000"; -- address = 0
        wait for 100 ns;
        address_s <= "0000001"; -- address = 1
        wait for 100 ns;
        address_s <= "0000010"; -- address = 2
        wait for 100 ns;
        address_s <= "0000011"; -- address = 3
        wait for 100 ns;
        address_s <= "0000100"; -- address = 4
        wait for 100 ns;
        address_s <= "0000101"; -- address = 5
        wait for 100 ns;
        address_s <= "0000110"; -- address = 6
        wait for 100 ns;
        address_s <= "0000111"; -- address = 7
        wait for 100 ns;
        address_s <= "0001000"; -- address = 8
        wait for 100 ns;
        address_s <= "0001001"; -- address = 9
        wait for 100 ns;
        address_s <= "0001010"; -- address = 10
        wait for 100 ns;
        finished_s <= '1';
        wait;
    end process;

end architecture;