library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_tb is
end entity;

architecture a_ram_tb of ram_tb is

    component ram
        port(
            clk         : in  std_logic;
            data_in     : in  unsigned(15 downto 0);
            address     : in  unsigned(6 downto 0);
            wr_en       : in  std_logic;
            data_out    : out unsigned(15 downto 0)
        );
    end component;

    -- Signals for the component
    signal clk_s        : std_logic;
    signal data_in_s    : unsigned(15 downto 0);
    signal address_s    : unsigned(6 downto 0);
    signal wr_en_s      : std_logic := '0';
    signal data_out_s   : unsigned(15 downto 0);

    -- For process
    constant period_time    : time      := 100 ns;
    signal finished_s       : std_logic := '0';

    -- Address
    constant addrs_63_c     : unsigned(6 downto 0) := B"011_1111";
    constant addrs_67_c     : unsigned(6 downto 0) := B"100_0011";
    constant addrs_90_c     : unsigned(6 downto 0) := B"101_1010";
    constant addrs_107_c    : unsigned(6 downto 0) := B"110_1011";
    constant addrs_26_c     : unsigned(6 downto 0) := B"001_1010";
    constant addrs_37_c     : unsigned(6 downto 0) := B"010_0101";
    constant addrs_50_c     : unsigned(6 downto 0) := B"011_0010";
    constant addrs_92_c     : unsigned(6 downto 0) := B"101_1100";

    -- Values
    constant var_20575_c    : unsigned(15 downto 0) := B"0101_0000_0101_1111";
    constant var_27739_c    : unsigned(15 downto 0) := B"0110_1100_0101_1011";
    constant var_61159_c    : unsigned(15 downto 0) := B"1110_1110_1110_0111";
    constant var_9699_c     : unsigned(15 downto 0) := B"0010_0101_1110_0011";
    constant var_5732_c     : unsigned(15 downto 0) := B"0001_0110_0110_0100";
    constant var_31863_c    : unsigned(15 downto 0) := B"0111_1100_0111_0111";
    constant var_14147_c    : unsigned(15 downto 0) := B"0011_0111_0100_0011";
    constant var_65270_c    : unsigned(15 downto 0) := B"1111_1110_1111_0110";

begin

    uut : ram
    port map (
        clk         =>  clk_s,
        data_in     =>  data_in_s,
        address     =>  address_s,
        wr_en       =>  wr_en_s,
        data_out    =>  data_out_s
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

    ram_proc: process
    begin
        wr_en_s <= '1';
        address_s   <= addrs_63_c;
        data_in_s   <= var_20575_c;
        wait for period_time;

        address_s   <= addrs_67_c;
        data_in_s   <= var_27739_c;
        wait for period_time;

        address_s   <= addrs_90_c;
        data_in_s   <= var_61159_c;
        wait for period_time;

        wr_en_s <= '0';
        address_s   <= addrs_63_c;
        wait for period_time;
        
        wr_en_s <= '1';
        address_s   <= addrs_107_c;
        data_in_s   <= var_9699_c;
        wait for period_time;
        
        address_s   <= addrs_26_c;
        data_in_s   <= var_5732_c;
        wait for period_time;

        wr_en_s <= '0';
        address_s   <= addrs_26_c;
        wait for period_time;
        
        address_s   <= addrs_90_c;
        wait for period_time;

        wr_en_s <= '1';
        address_s   <= addrs_37_c;
        data_in_s   <= var_31863_c;
        wait for period_time;

        address_s   <= addrs_50_c;
        data_in_s   <= var_14147_c;
        wait for period_time;

        address_s   <= addrs_92_c;
        data_in_s   <= var_65270_c;
        wait for period_time;
        finished_s  <= '1';
        wait;
    end process;

end architecture;