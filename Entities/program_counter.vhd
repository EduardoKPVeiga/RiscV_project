library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity program_counter is
    port (
        clk_pc          : in std_logic;
        wr_en_pc        : in std_logic;
        data_in_pc      : in  unsigned(15 downto 0);
        data_out_pc     : out unsigned(15 downto 0)
    );
end entity;

architecture a_program_counter of program_counter is
    component reg16bits
        port(
            clk         : in std_logic;
            rst         : in std_logic;
            wr_en       : in std_logic; 
            data_in     : in  unsigned(15 downto 0);
            data_out    : out unsigned(15 downto 0)
        );
    end component;

    signal clk_s        : std_logic;
    signal rst_s        : std_logic;
    signal wr_en_s      : std_logic; 
    signal data_in_s    : unsigned(15 downto 0);
    signal data_out_s   : unsigned(15 downto 0);

begin
    register_c : reg16bits
    port map (
        clk         => clk_s,
        rst         => rst_s,
        wr_en       => wr_en_s,
        data_in     => data_in_s,
        data_out    => data_out_s
    );
    
    -- Connecting PC's wires to register's wires
    clk_s           <= clk_pc;
    wr_en_s         <= wr_en_pc;
    data_in_s       <= data_in_pc;
    data_out_pc     <= data_out_s;

    -- Never reset
    rst_s           <= '0';

end architecture;