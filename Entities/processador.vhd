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

    constant reg_concatenation      : unsigned(10 downto 0) := "00000000000";
    constant value_concatenation    : unsigned(10 downto 0) := "00000000000";
    constant invalid_register       : unsigned(15 downto 0) := "1111111111111111";

    -- Used to identifie opcodes
    constant add_op_code_mask_const     : unsigned(15 downto 0) :=  "0000000111000000";
    constant addi_op_code_mask_const    : unsigned(15 downto 0) :=  "0000001001000000";
    constant nop_mask_const             : unsigned(15 downto 0) :=  "0000000000000000";

    -- Op Codes
    constant add_op_code_const  : unsigned(5 downto 0)  := "001110";
    constant addi_op_code_const : unsigned(5 downto 0)  := "010010";
    constant nop_op_code_const  : unsigned(5 downto 0)  := "000000";

    component top_level_uc
        port (
            clk_tluc                    : in  std_logic;
            rst_tluc                    : in  std_logic;
            instruction_from_rom        : out unsigned(15 downto 0)
        );
    end component;

    component ula
        port (
            x,y     : in  unsigned(15 downto 0);
            op_code : in  unsigned(1 downto 0);
            res     : out unsigned(15 downto 0)
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

    -- Top Level UC


    -- Banco de Regs
    signal register1_bdr_s      : unsigned(15 downto 0);
    signal register2_bdr_s      : unsigned(15 downto 0);
    signal value_bdr_s          : unsigned(15 downto 0);
    signal write_reg_bdr_s      : unsigned(15 downto 0);
    signal write_en_bdr_s       : std_logic;
    signal register1_data_bdr_s : unsigned(15 downto 0);
    signal register2_data_bdr_s : unsigned(15 downto 0);

    signal clk_proc_s   : std_logic;
    signal rst_proc_s   : std_logic;

    -- ULA signals
    signal value1_ula_s : unsigned(15 downto 0);
    signal value2_ula_s : unsigned(15 downto 0);
    signal result_ula_s : unsigned(15 downto 0);
    signal opcode_ula_s : unsigned(1 downto 0);

begin

    ula_c : ula
    port map (
        x       =>  value1_ula_s,
        y       =>  value2_ula_s,
        res     =>  result_ula_s,
        op_code =>  opcode_ula_s
    );

    banco_de_regs_c : banco_de_regs
    port map (
        read_reg1   =>  register1_bdr_s,
        read_reg2   =>  register2_bdr_s,
        write_reg   =>  write_reg_bdr_s,
        write_en    =>  write_en_bdr_s,             -- Not used
        clk         =>  clk_proc_s,
        rst         =>  rst_proc_s,
        read_data1  =>  register1_data_bdr_s,
        read_data2  =>  register2_data_bdr_s
    );

    -- Decode message
    op_code_s     <=    add_op_code_const    when    (instruction_from_rom and add_op_code_mask_const) = add_op_code_mask_const   else
                        addi_op_code_const   when    (instruction_from_rom and addi_op_code_mask_const) = addi_op_code_mask_const   else
                        nop_op_code_const;

    register1_bdr_s   <=    (reg_concatenation & instruction_from_rom(15 downto 11))    when    op_code_s = add_op_code_const else
                            invalid_register;

    register2_bdr_s   <=    (reg_concatenation & instruction_from_rom(4 downto 0))      when    op_code_s = add_op_code_const else
                            (reg_concatenation & instruction_from_rom(4 downto 0))      when    op_code_s = addi_op_code_const else
                            invalid_register;

    value_bdr_s <=  (value_concatenation & instruction_from_rom(15 downto 11))  when    op_code_s = addi_op_code_const  else
                    result_ula_s;

    value1_ula_s    <=  register1_data_bdr_s;
    value2_ula_s    <=  register2_data_bdr_s;

    write_reg_bdr_s <=  register2_bdr_s;

    clk_proc_s  <= clk_proc;
    rst_proc_s  <= rst_proc;

end architecture;