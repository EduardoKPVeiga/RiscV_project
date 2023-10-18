library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter_tb is
end entity;

architecture a_program_counter_tb of program_counter_tb is

    component program_counter
        port (
            clk_pc          : in std_logic;
            wr_en_pc        : in std_logic;
            data_in_pc      : in  unsigned(15 downto 0);
            data_out_pc     : out unsigned(15 downto 0)
        );
    end component;

    component pc_sum
        port (
            register_in     : in  unsigned(15 downto 0);
            register_out    : out unsigned(15 downto 0)
        );
    end component;

    constant reg0           : unsigned(15 downto 0) := "0000000000000000";
    constant reg1           : unsigned(15 downto 0) := "0000000000000001";
    constant reg2           : unsigned(15 downto 0) := "0000000000000010";
    constant reg3           : unsigned(15 downto 0) := "0000000000000011";
    constant reg4           : unsigned(15 downto 0) := "0000000000000100";
    constant reg5           : unsigned(15 downto 0) := "0000000000000101";
    constant reg6           : unsigned(15 downto 0) := "0000000000000110";
    constant reg7           : unsigned(15 downto 0) := "0000000000000111";

    constant period_time    : time      := 100 ns;
    signal finished         : std_logic := '0';

    signal clk_pc_s         : std_logic;
    signal wr_en_pc_s       : std_logic;
    signal data_in_pc_s     : unsigned(15 downto 0);
    signal data_out_pc_s    : unsigned(15 downto 0);
    signal register_in_s    : unsigned(15 downto 0);
    signal register_out_s   : unsigned(15 downto 0);

begin

    program_counter_c : program_counter
    port map (
        clk_pc          => clk_pc_s,
        wr_en_pc        => wr_en_pc_s,
        data_in_pc      => data_in_pc_s,
        data_out_pc     => data_out_pc_s
    );

    pc_sum_c : pc_sum
    port map (
        register_in     => register_in_s,
        register_out    => register_out_s
    );

    data_in_pc_s        <= register_out_s;
    wr_en_pc_s          <= '1';

    clk_proc: process
    begin
        while finished /= '1' loop
            clk_pc_s    <= '0';
            wait for period_time / 2;
            clk_pc_s    <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    pc_proc: process
    begin
        register_in_s   <= reg0;
        wait for period_time;
        register_in_s   <= register_out_s;
        wait for period_time;
        register_in_s   <= register_out_s;
        wait for period_time;
        register_in_s   <= register_out_s;
        wait for period_time;
        register_in_s   <= register_out_s;
        wait for period_time;
        register_in_s   <= register_out_s;
        wait for period_time;
        wait;
    end process pc_proc;

end architecture;