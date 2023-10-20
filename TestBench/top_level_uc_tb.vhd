library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level_uc_tb is
end entity;

architecture a_top_level_uc_tb of top_level_uc_tb is
    
    component top_level_uc
        port (
            clk_tluc                         : in std_logic;
            rst_tluc                         : in std_logic;
            instruction                 : in  unsigned(15 downto 0);
            top_level_uc_instruction    : in  std_logic
        );
    end component;

    constant period_time                : time      := 100 ns;
    signal finished                     : std_logic := '0';

    signal clk_s                        : std_logic := '0';
    signal rst_s                        : std_logic := '1'; -- Inicia com reset ativado
    signal top_level_uc_instruction_s   : std_logic := '1';
    signal instruction_s                : unsigned(15 downto 0);

begin
    uut: top_level_uc
        port map (
            clk_tluc                        => clk_s,
            rst_tluc                        => rst_s,
            top_level_uc_instruction        => top_level_uc_instruction_s,
            instruction                     => instruction_s
        );

    -- Processo de clock
    clk_proc: process
    begin
        while finished /= '1' loop
            clk_s    <= '0';
            wait for period_time / 2;
            clk_s    <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    geral: process
    begin
        rst_s <= '0';
        instruction_s <= "1111000000000000";
        wait for period_time;
        top_level_uc_instruction_s <= '0';
        wait for period_time * 22;
        finished <= '1';
        wait;
    end process;

end architecture;
