library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processador is
    port (
        clk_proc    : in std_logic;
        rst_proc    : in std_logic
    );
end entity;

architecture a_processador of processador is

    constant reg_concatenation   : unsigned(10 downto 0) := "00000000000";
    constant invalid_register    : unsigned(15 downto 0) := "1111111111111111";
    
    -- Used to identifie opcodes
    constant add_op_code_mask_const     : unsigned(15 downto 0) :=  "0000000111000000";
    constant addi_op_code_mask_const    : unsigned(15 downto 0) :=  "0000001001000000";
    constant nop_mask_const             : unsigned(15 downto 0) :=  "0000000000000000";

    -- Op Codes
    constant add_op_code_const          : unsigned(5 downto 0)  := "001110";
    constant addi_op_code_const         : unsigned(5 downto 0)  := "010010";
    constant nop_op_code_const          : unsigned(5 downto 0)  := "000000";

    component top_level_uc
        port (
            clk_tluc                    : in  std_logic;
            rst_tluc                    : in  std_logic;
            instruction                 : in  unsigned(15 downto 0);
            top_level_uc_instruction    : in  std_logic;
            instruction_from_rom        : out unsigned(15 downto 0)
        );
    end component;

    component ula
        port (
            x,y         : in  unsigned(15 downto 0);
            op_code     : in  unsigned(1 downto 0);
            res         : out unsigned(15 downto 0)
        );
    end component;

    component banco_de_regs
        port(
            read_reg1   : in unsigned(15 downto 0);
            read_reg2   : in unsigned(15 downto 0);
            value       : in unsigned(15 downto 0);
            write_reg   : in unsigned(15 downto 0);
            write_en    : in std_logic;
            clk         : in std_logic;
            rst         : in std_logic;
            read_data1  : out unsigned(15 downto 0);
            read_data2  : out unsigned(15 downto 0)
        );
    end component;

    signal op_code_s    : unsigned(5 downto 0);

    -- Registers
    signal register1_instruction_s      : unsigned(15 downto 0);
    signal register2_instruction_s      : unsigned(15 downto 0);
    signal register1_data_instruction_s : unsigned(15 downto 0);
    signal register2_data_instruction_s : unsigned(15 downto 0);
    
    signal clk_proc_s   : std_logic;
    signal rst_proc_s   : std_logic;

begin

    banco_de_regs_c : banco_de_regs
    port map (
        read_reg1   =>  register1_instruction,
        read_reg2   =>  register2_instruction,
        clk         =>  clk_proc_s,
        rst         =>  rst_proc_s,

    );

    op_code_s     <=    add_op_code_const    when    (instruction_from_rom and add_op_code_mask_const) = add_op_code_mask_const   else
                        addi_op_code_const   when    (instruction_from_rom and addi_op_code_mask_const) = addi_op_code_mask_const   else
                        nop_op_code_const;

    register1_instruction_s   <=    (reg_concatenation & instruction_from_rom(15 downto 11))    when    op_code_s = add_op_code_const else
                                    invalid_register;

    register2_instruction_s   <=    (reg_concatenation & instruction_from_rom(4 downto 0))      when    op_code_s = add_op_code_const else
                                    (reg_concatenation & instruction_from_rom(4 downto 0))      when    op_code_s = addi_op_code_const else
                                    invalid_register;

    clk_proc_s  <= clk_proc;
    rst_proc_s  <= rst_proc;

end architecture;