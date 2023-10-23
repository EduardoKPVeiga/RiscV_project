------------------------------------------------------------------------------- 
--
-- OLD VERSION OF banco_de_regs
--
------------------------------------------------------------------------------- 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_de_regs_tb is
end;

architecture a_banco_de_regs_tb of banco_de_regs_tb is

    constant reg0           : unsigned(15 downto 0) := "0000000000000000";
    constant reg1           : unsigned(15 downto 0) := "0000000000000001";
    constant reg2           : unsigned(15 downto 0) := "0000000000000010";
    constant reg3           : unsigned(15 downto 0) := "0000000000000011";
    constant reg4           : unsigned(15 downto 0) := "0000000000000100";
    constant reg5           : unsigned(15 downto 0) := "0000000000000101";
    constant reg6           : unsigned(15 downto 0) := "0000000000000110";
    constant reg7           : unsigned(15 downto 0) := "0000000000000111";

    component banco_de_regs
        port(
            read_reg1           : in unsigned(15 downto 0);
            read_reg2           : in unsigned(15 downto 0);
            value               : in unsigned(15 downto 0);
            write_reg           : in unsigned(15 downto 0);
            write_en            : in std_logic;
            clk                 : in std_logic;
            rst                 : in std_logic;
            read_data1          : out unsigned(15 downto 0);
            read_data2          : out unsigned(15 downto 0)
        );
    end component;

    signal  read_reg1_s         : unsigned(15 downto 0);
    signal  read_reg2_s         : unsigned(15 downto 0);
    signal  value_s             : unsigned(15 downto 0);
    signal  write_reg_s         : unsigned(15 downto 0);
    signal  write_en_s          : std_logic;
    signal  clk_s               : std_logic;
    signal  rst_s               : std_logic;
    signal  read_data1_s        : unsigned(15 downto 0);
    signal  read_data2_s        : unsigned(15 downto 0);

begin
    uut : banco_de_regs
    port map(
        read_reg1   => read_reg1_s,
        read_reg2   => read_reg2_s,
        value       => value_s,
        write_reg   => write_reg_s,
        write_en    => write_en_s,
        clk         => clk_s,
        rst         => rst_s,
        read_data1  => read_data1_s,
        read_data2  => read_data2_s
    );

    process
    begin
        clk_s       <= '0';
        write_en_s  <= '1';
        rst_s       <= '1';
        wait for 50 fs;

        rst_s       <= '0';
        wait for 50 fs;

        write_reg_s <= reg0;
        
        clk_s       <= '1';
        wait for 50 fs;
        
        clk_s       <= '0';
        value_s     <= "0000000000001100";                                              -- 12
        wait for 50 fs;
        
        clk_s       <= '1';
        wait for 50 fs;
        
        clk_s       <= '0';
        write_reg_s <= reg1;
        wait for 50 fs;

        value_s     <= "0000000111111101";                                              -- 509
        wait for 50 fs;

        clk_s       <= '1';
        wait for 50 fs;
        
        clk_s       <= '0';
        write_reg_s <= reg2;
        read_reg1_s <= reg0;
        read_reg2_s <= reg1;
        wait for 50 fs;
        
        clk_s       <= '1';
        wait for 50 fs;

        wait;
    end process;
end architecture;