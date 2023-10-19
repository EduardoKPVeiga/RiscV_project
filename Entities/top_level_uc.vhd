library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level_uc is
    port (
        clk_tluc                    : in std_logic;
        rst_tluc                    : in std_logic;
        instruction                 : in  unsigned(15 downto 0);
        top_level_uc_instruction    : in  std_logic
    );
end entity;

architecture a_uni_control of uni_control is

    --unidade de controle
    signal uc_instruction_s         : unsigned(15 downto 0);
    signal uc_next_reg_pc_s         : unsigned(15 downto 0);
    signal uc_next_reg_pc_sum_s     : unsigned(6 downto 0);
    signal uc_wr_en_pc_s            : std_logic;

    --maquina de estados
    signal rom_data_s               : unsigned(15 downto 0);
    signal state_s                  : std_logic;

    --rom
    signal rom_address_s            : unsigned(6 downto 0);
    signal opcode                   : unsigned(3 downto 0);

    --pc sum
    signal pc_sum_register_out_s    : unsigned(15 downto 0);

    --pc counter
    signal data_out_pc_s            : unsigned(15 downto 0);
    signal wr_en_pc_s               : std_logic;

    --global
    signal clk_s                    : std_logic;
    signal rst_s                    : std_logic;

    component uni_control
        port (    
            instruction     : in  unsigned(15 downto 0);
            next_reg_pc_sum : in  unsigned(6 downto 0);
            next_reg_pc     : out unsigned(15 downto 0);
            wr_en_pc        : out std_logic;
            state_mch   : in  std_logic
        );
    end component;

    component state_machine
        port (
            clk     : in  std_logic;
            state   : out std_logic;
            rst     : in  std_logic
        );
    end component;

    component rom
        port (
            clk     : in  std_logic;
            address : in  unsigned(6 downto 0);
            data    : out unsigned(15 downto 0)
        );
    end component;

    component pc_sum
    port (
        register_in  : in  unsigned(15 downto 0);
        register_out : out unsigned(15 downto 0)
    );
    end component;

    component program_counter
    port (
        clk_pc      : in  std_logic;
        wr_en_pc    : in  std_logic;
        data_in_pc  : in  unsigned(15 downto 0);
        data_out_pc : out unsigned(15 downto 0)
    );
    end component;

begin
    uni_control_c: uni_control
        port map(
            instruction     => uc_instruction_s,
            next_reg_pc     => uc_next_reg_pc_s,
            next_reg_pc_sum => pc_sum_register_out_s(6 downto 0),
            wr_en_pc        => uc_wr_en_pc_s,
            state_mch       => state_s
        );

    state_machine_c: state_machine
        port map (
            clk     => clk_s,
            state   => state_s,
            rst     => rst_s
        );

    rom_c: rom
        port map (
            clk     => clk_s,
            address => rom_address_s,
            data    => rom_data_s
        );

    pc_sum_c: pc_sum
        port map (
            register_in     => data_out_pc_s,
            register_out    => pc_sum_register_out_s
        );
    
    program_counter_c: program_counter
        port map (
            clk_pc      => clk_s,
            data_in_pc  => uc_next_reg_pc_s,
            data_out_pc => data_out_pc_s,
            wr_en_pc    => uc_wr_en_pc_s
        );

        clk_s               <=  clk_tluc;
        rst_s               <=  rst_tluc;

        uc_instruction_s    <=  instruction   when  top_level_uc_instruction = '1'    else
                                rom_data_s;

        rom_address_s       <=  data_out_pc_s(6 downto 0);
end architecture;
