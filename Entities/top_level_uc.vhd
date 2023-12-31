------------------------------------------------------------------------------- 
--
-- Last Version
-- Date: 25/10/2023
--
------------------------------------------------------------------------------- 

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level_uc is
    port (
        clk_tluc                    : in  std_logic;
        rst_tluc                    : in  std_logic;
        instruction_from_rom        : out unsigned(15 downto 0);
        state_tluc                  : in  unsigned(1 downto 0);
        tp_next_reg_pc_sum          : in  unsigned(15 downto 0)
    );
end entity;

architecture a_top_level_uc of top_level_uc is

    constant zero                   : unsigned(15 downto 0) := "0000000000000000";
    constant first_instruction      : unsigned(15 downto 0) := "1111000000000000";
    constant initial_pc_sum_result  : unsigned(15 downto 0) := "1111111111111111";

    --unidade de controle
    signal uc_instruction_s         : unsigned(15 downto 0);
    signal uc_next_reg_pc_s         : unsigned(15 downto 0);
    signal uc_next_reg_pc_sum_s     : unsigned(15 downto 0);
    signal uc_wr_en_pc_s            : std_logic;

    --maquina de estados
    signal state_s                  : unsigned(1 downto 0);
    
    --rom
    signal rom_address_s            : unsigned(6 downto 0);
    signal rom_data_s               : unsigned(15 downto 0);
    signal last_rom_data_s          : unsigned(15 downto 0);
    signal opcode                   : unsigned(3 downto 0);

    --pc sum
    signal pc_sum_register_in_s     : unsigned(15 downto 0);
    signal pc_sum_register_out_s    : unsigned(15 downto 0);

    --pc counter
    signal data_in_pc_s             : unsigned(15 downto 0);
    signal data_out_pc_s            : unsigned(15 downto 0);
    signal wr_en_pc_s               : std_logic;

    --global
    signal clk_s                    : std_logic;
    signal rst_s                    : std_logic;


    --signal
    signal branch_sum               : unsigned(16 downto 0);

    component uni_control
        port (    
            instruction     : in  unsigned(15 downto 0);
            next_reg_pc_sum : in  unsigned(15 downto 0);
            next_reg_pc     : out unsigned(15 downto 0);
            wr_en_pc        : out std_logic;
            state_mch       : in  unsigned(1 downto 0)
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
            next_reg_pc_sum => uc_next_reg_pc_sum_s,
            wr_en_pc        => uc_wr_en_pc_s,
            state_mch       => state_s
        );

    rom_c: rom
        port map (
            clk     => clk_s,
            address => rom_address_s,
            data    => rom_data_s
        );

    pc_sum_c: pc_sum
        port map (
            register_in     => pc_sum_register_in_s,
            register_out    => pc_sum_register_out_s
        );
    
    program_counter_c: program_counter
        port map (
            clk_pc      => clk_s,
            data_in_pc  => data_in_pc_s,
            data_out_pc => data_out_pc_s,
            wr_en_pc    => wr_en_pc_s
        );

        state_s <=  state_tluc;
        clk_s                   <=  clk_tluc;
        rst_s                   <=  rst_tluc;

        wr_en_pc_s              <=  '1' when  rst_tluc = '1'    else
                                    uc_wr_en_pc_s   when    state_s = "10"  else
                                    '0';
        branch_sum <= ("0" & pc_sum_register_out_s) + ("0" & tp_next_reg_pc_sum) when (uc_instruction_s(10 downto 7) = "1011");
        uc_next_reg_pc_sum_s    <=  zero                                         when    rst_tluc = '1'  else
                                    tp_next_reg_pc_sum                           when (uc_instruction_s(10 downto 5) = "000011") else
                                    branch_sum(15 downto 0)                      when (uc_instruction_s(10 downto 7) = "1011") else
                                    pc_sum_register_out_s;
        

        uc_instruction_s        <=  first_instruction   when    rst_tluc = '1'  else
                                    rom_data_s;

        pc_sum_register_in_s    <=  zero                               when    rst_tluc = '1'  else
                                    data_out_pc_s;

        data_in_pc_s            <=  zero    when    rst_tluc = '1'  else
                                    uc_next_reg_pc_s;

        rom_address_s           <=  data_out_pc_s(6 downto 0);

        instruction_from_rom    <=  rom_data_s;
end architecture;
