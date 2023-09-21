library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg16bits_tb is
end entity;

architecture a_reg16bits_tb of reg16bits_tb is
    component reg16bits
        port(
            clk         : in std_logic;
            rst         : in std_logic;
            wr_en       : in std_logic; 
            data_in     : in  unsigned(15 downto 0);
            data_out    : out unsigned(15 downto 0)
        );
    end component;

    constant period_time    : time      := 100 ns;
    signal finished         : std_logic := '0';

    signal clk_s            : std_logic;
    signal rst_s            : std_logic;
    signal wr_en_s          : std_logic;
    signal data_in_s        : unsigned(15 downto 0);
    signal data_out_s       : unsigned(15 downto 0);

begin
    uut : reg16bits
    port map(
        clk         => clk_s,
        rst         => rst_s,
        wr_en       => wr_en_s,
        data_in     => data_in_s
    );

    reset_global: process
    begin
        rst_s   <= '1';
        wait for period_time * 2;                       -- Wait for 2 clocks
        rst_s   <= '0';
        wait;
    end process reset_global;

    sim_time_proc: process
    begin
        wait for 10 us;                                 -- Total Simulation Time
        finished    <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin
        while finished /= '1' loop
            clk_s   <= '0';
            wait for period_time / 2;
            clk_s   <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    data_in_proc: process
    begin                                       
        wait for 200 ns;
        wr_en_s     <= '0';
        data_in_s   <= "0000000011111111";
        wait for 100 ns;
        wr_en_s     <= '1';
        data_in_s   <= "0000000010001101";
        wait;
     end process data_in_proc;
end architecture;