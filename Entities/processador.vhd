------------------------------------------------------------------------------- 
--
-- Last Version
-- Date: 25/10/2023
--
------------------------------------------------------------------------------- 

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
    constant add_op_code_mask_const     : unsigned(15 downto 0) :=  B"00000_001110_00000";
    constant addi_op_code_mask_const    : unsigned(15 downto 0) :=  B"00000_010010_00000";
    constant sub_op_code_mask_const     : unsigned(15 downto 0) :=  B"00000_001101_00000";
    constant nop_mask_const             : unsigned(15 downto 0) :=  B"00000_000000_00000";

    -- Op Codes
    constant add_op_code_const  : unsigned(5 downto 0)  := "001110";
    constant addi_op_code_const : unsigned(5 downto 0)  := "010010";
    constant sub_op_code_const  : unsigned(5 downto 0)  := "001101";
    constant nop_op_code_const  : unsigned(5 downto 0)  := "000000";

    component top_level_uc
        port (
            clk_tluc                    : in  std_logic;
            rst_tluc                    : in  std_logic;
            instruction_from_rom        : out unsigned(15 downto 0);
            state_tluc                  : in  unsigned(1 downto 0)
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
    
    component state_machine
        port (
            clk     : in  std_logic;
            state   : out unsigned(1 downto 0);
            rst     : in  std_logic
        );
    end component;

    signal op_code_s    : unsigned(5 downto 0);

    -- State Machine
    signal state_s  : unsigned(1 downto 0);

    -- Top Level UC
    signal instruction_from_rom_s   : unsigned(15 downto 0);

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

    top_level_uc_c : top_level_uc
    port map (
        clk_tluc                =>  clk_proc_s,
        rst_tluc                =>  rst_proc_s,
        instruction_from_rom    =>  instruction_from_rom_s,
        state_tluc              =>  state_s
    );

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
        value       =>  value_bdr_s,
        write_reg   =>  write_reg_bdr_s,
        write_en    =>  write_en_bdr_s, -- Not used
        clk         =>  clk_proc_s,
        rst         =>  rst_proc_s,
        read_data1  =>  register1_data_bdr_s,
        read_data2  =>  register2_data_bdr_s
    );

    state_machine_c : state_machine
    port map (
        clk     =>  clk_proc_s,
        state   =>  state_s,
        rst     =>  rst_proc_s
    );

    -- Decode message
    op_code_s     <=    add_op_code_const   when    ((instruction_from_rom_s(10 downto 5) = add_op_code_const))      and state_s = "01"  else
                        addi_op_code_const  when    ((instruction_from_rom_s(10 downto 5) = addi_op_code_const))    and state_s = "01"  else
                        sub_op_code_const   when    ((instruction_from_rom_s(10 downto 5) = sub_op_code_const))      and state_s = "01"  else
                        nop_op_code_const;

    register1_bdr_s   <=    (reg_concatenation & instruction_from_rom_s(4 downto 0))    when    (op_code_s = add_op_code_const) and (state_s = "01")  else
                            (reg_concatenation & instruction_from_rom_s(4 downto 0))    when    (op_code_s = sub_op_code_const) and (state_s = "01")  else
                            invalid_register;

    register2_bdr_s   <=    (reg_concatenation & instruction_from_rom_s(15 downto 11))      when    (op_code_s = add_op_code_const)   and (state_s = "01")  else
                            (reg_concatenation & instruction_from_rom_s(15 downto 11))      when    (op_code_s = addi_op_code_const)  and (state_s = "01")  else
                            (reg_concatenation & instruction_from_rom_s(15 downto 11))      when    (op_code_s = sub_op_code_const)   and (state_s = "01")  else
                            invalid_register;
                            
    value_bdr_s <=  (value_concatenation & instruction_from_rom_s(4 downto 0))  when    (op_code_s = addi_op_code_const)    else
                    result_ula_s;

    -- See page 416 and 419 of the datasheet
    opcode_ula_s    <=  op_code_s(1 downto 0)   when    (op_code_s = add_op_code_const)   and (state_s = "01")  else
                        op_code_s(1 downto 0)   when    (op_code_s = addi_op_code_const)  and (state_s = "01")  else
                        op_code_s(1 downto 0)   when    (op_code_s = sub_op_code_const)   and (state_s = "01")  else
                        "00";

    value1_ula_s    <=  register2_data_bdr_s;

    value2_ula_s    <=  register1_data_bdr_s;

    write_reg_bdr_s <=  register2_bdr_s when    state_s = "01"  else
                        invalid_register;

    clk_proc_s  <= clk_proc;
    rst_proc_s  <= rst_proc;

end architecture;