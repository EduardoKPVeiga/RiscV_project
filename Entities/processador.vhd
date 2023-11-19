------------------------------------------------------------------------------- 
--
-- Last Version
-- Date: 13/11/2023
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

    -- Op Codes
    constant add_op_code_const  : unsigned(5 downto 0)  := "001110";
    constant addi_op_code_const : unsigned(5 downto 0)  := "010010";
    constant sub_op_code_const  : unsigned(5 downto 0)  := "001101";
    constant bch_op_code_const  : unsigned(5 downto 0)  := "101100";
    constant jmp_op_code_const  : unsigned(5 downto 0)  := "000011";
    constant cmp_op_code_const  : unsigned(5 downto 0)  := "000111";
    constant mov_op_code_const  : unsigned(5 downto 0)  := "000000";
    constant ldh_op_code_const  : unsigned(5 downto 0)  := "111001";
    constant sth_op_code_const  : unsigned(5 downto 0)  := "111011";
    constant nop_op_code_const  : unsigned(5 downto 0)  := "000000";

    component top_level_uc
        port (
            clk_tluc                    : in  std_logic;
            rst_tluc                    : in  std_logic;
            instruction_from_rom        : out unsigned(15 downto 0);
            tp_next_reg_pc_sum          : in  unsigned(15 downto 0);
            state_tluc                  : in  unsigned(1 downto 0)
        );
    end component;

    component ula
        port (
            x,y     : in  unsigned(15 downto 0);
            op_code : in  unsigned(1 downto 0);
            res     : out unsigned(15 downto 0);
            carry   : out std_logic
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

    component ram
        port(
            clk         : in  std_logic;
            data_in     : in  unsigned(15 downto 0);
            address     : in  unsigned(6 downto 0);
            wr_en       : in  std_logic;
            data_out    : out unsigned(15 downto 0)
        );
    end component;

    signal op_code_s    : unsigned(5 downto 0);

    -- State Machine
    signal state_s  : unsigned(1 downto 0);

    -- Top Level UC
    signal instruction_from_rom_s   : unsigned(15 downto 0);
    signal tp_next_reg_pc_sum_s     : unsigned(15 downto 0);

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
    signal  carry_ula_s : std_logic;

    -- Signal branch
    signal branch_s : unsigned(15 downto 0);

    --cmp
    signal flag_cmp     : std_logic;

    -- RAM signals
    signal data_in_ram_s    : unsigned(15 downto 0);
    signal address_ram_s    : unsigned(6 downto 0);
    signal wr_en_ram_s      : std_logic;
    signal data_out_ram_s   : unsigned(15 downto 0);

begin

    top_level_uc_c : top_level_uc
    port map (
        clk_tluc                =>  clk_proc_s,
        rst_tluc                =>  rst_proc_s,
        instruction_from_rom    =>  instruction_from_rom_s,
        state_tluc              =>  state_s,
        tp_next_reg_pc_sum      =>  tp_next_reg_pc_sum_s
    );

    ula_c : ula
    port map (
        x       =>  value1_ula_s,
        y       =>  value2_ula_s,
        res     =>  result_ula_s,
        op_code =>  opcode_ula_s,
        carry   =>  carry_ula_s
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

    ram_c : ram
    port map(
        clk         =>  clk_proc_s,
        data_in     =>  data_in_ram_s,
        address     =>  address_ram_s,
        wr_en       =>  wr_en_ram_s,
        data_out    =>  data_out_ram_s
    );

    -- Decode message
    op_code_s     <=    add_op_code_const   when    ((instruction_from_rom_s(10 downto 5) = add_op_code_const))             and state_s = "01"  else
                        addi_op_code_const  when    ((instruction_from_rom_s(10 downto 5) = addi_op_code_const))            and state_s = "01"  else
                        sub_op_code_const   when    ((instruction_from_rom_s(10 downto 5) = sub_op_code_const))             and state_s = "01"  else
                        bch_op_code_const   when    (((instruction_from_rom_s(10 downto 7) & "00") = bch_op_code_const))    and state_s = "01"  else
                        jmp_op_code_const   when    ((instruction_from_rom_s(10 downto 5) = jmp_op_code_const))             and state_s = "01"  else
                        cmp_op_code_const   when    ((instruction_from_rom_s(10 downto 5) = cmp_op_code_const))             and state_s = "01"  else
                        ldh_op_code_const   when    ((instruction_from_rom_s(10 downto 5) = ldh_op_code_const))             and state_s = "01"  else
                        nop_op_code_const   when    ((instruction_from_rom_s(10 downto 5) = nop_op_code_const))             and state_s = "01"  else
                        sth_op_code_const   when    ((instruction_from_rom_s(10 downto 5) = sth_op_code_const))             and state_s = "01";

                        
    register1_bdr_s   <=    (reg_concatenation & instruction_from_rom_s(4 downto 0))    when    (op_code_s = add_op_code_const) and (state_s = "01")  else
                            (reg_concatenation & instruction_from_rom_s(4 downto 0))    when    (op_code_s = cmp_op_code_const) and (state_s = "01")  else
                            (reg_concatenation & instruction_from_rom_s(4 downto 0))    when    (op_code_s = sub_op_code_const) and (state_s = "01")  else
                            (reg_concatenation & instruction_from_rom_s(4 downto 0))    when    (op_code_s = ldh_op_code_const) and (state_s = "01")  else  -- RAM
                            (reg_concatenation & instruction_from_rom_s(4 downto 0))    when    (op_code_s = sth_op_code_const) and (state_s = "01")  else  -- RAM
                            ("0000000000000"   & instruction_from_rom_s(12 downto 11) & instruction_from_rom_s(4) )    when    (op_code_s = bch_op_code_const) and (state_s = "01")  else
                            invalid_register;

    register2_bdr_s   <=    (reg_concatenation & instruction_from_rom_s(15 downto 11))      when    (op_code_s = add_op_code_const)     and (state_s = "01")    else
                            (reg_concatenation & instruction_from_rom_s(15 downto 11))      when    (op_code_s = addi_op_code_const)    and (state_s = "01")    else
                            (reg_concatenation & instruction_from_rom_s(15 downto 11))      when    (op_code_s = cmp_op_code_const)     and (state_s = "01")    else
                            (reg_concatenation & instruction_from_rom_s(15 downto 11))      when    (op_code_s = sub_op_code_const)     and (state_s = "01")    else
                            (reg_concatenation & instruction_from_rom_s(15 downto 11))      when    (op_code_s = ldh_op_code_const)     and (state_s = "01")    else
                            (reg_concatenation & instruction_from_rom_s(15 downto 11))      when    (op_code_s = sth_op_code_const)     and (state_s = "01")    else
                            ("0000000000000"   & instruction_from_rom_s(15 downto 13))      when    (op_code_s = bch_op_code_const)     and (state_s = "01")    else
                            invalid_register;
                            
    value_bdr_s <=  (value_concatenation & instruction_from_rom_s(4 downto 0))  when    (op_code_s = addi_op_code_const)    else
                    register2_data_bdr_s    when    op_code_s = bch_op_code_const   else
                   data_out_ram_s          when    op_code_s = ldh_op_code_const   else
                    register2_data_bdr_s    when    op_code_s = sth_op_code_const   else
                    result_ula_s;

    flag_cmp <= '0' when (op_code_s = cmp_op_code_const)   and (result_ula_s = "0000000000000000")  and (state_s = "01") else
                '1' when (op_code_s = cmp_op_code_const)   and (result_ula_s(15) = '1')             and (state_s = "01")          else
                '0' when (op_code_s = cmp_op_code_const)   and (state_s = "01");

    -- See page 416 and 419 of the datasheet
    opcode_ula_s    <=  op_code_s(1 downto 0)   when    (op_code_s = add_op_code_const)   and (state_s = "01")  else
                        op_code_s(1 downto 0)   when    (op_code_s = addi_op_code_const)  and (state_s = "01")  else
                        op_code_s(1 downto 0)   when    (op_code_s = sub_op_code_const)   and (state_s = "01")  else
                        "01"                    when    (op_code_s = cmp_op_code_const)   and (state_s = "01")  else
                        "00";

    value1_ula_s    <=  register2_data_bdr_s;
    value2_ula_s    <=  register1_data_bdr_s;

    branch_s <= ("11111111" & (instruction_from_rom_s(15 downto 11) & instruction_from_rom_s(6 downto 4))) when  (instruction_from_rom_s(15) = '1') and (op_code_s = bch_op_code_const) else
                ("00000000" & (instruction_from_rom_s(15 downto 11) & instruction_from_rom_s(6 downto 4))) when  (op_code_s = bch_op_code_const) else
                "0000000000000000";
    -- trocar para apenas soma no top level e apenas complementar tudo com "1" caso seja signed caso contrario com "1"

                                                                                                                         --mudar para cmp_flag                                       
    tp_next_reg_pc_sum_s <=  branch_s                                           when (op_code_s = bch_op_code_const) and (flag_cmp = '1') and (state_s = "10") else
                            "00000000000"  & instruction_from_rom_s(4 downto 0) when (op_code_s = jmp_op_code_const) and (state_s = "10") else
                            "0000000000000000";
-- +1

    write_reg_bdr_s <=  register2_bdr_s when   ( state_s = "01") and (op_code_s /= cmp_op_code_const)  else
                        invalid_register;

    -- RAM
    wr_en_ram_s <=  '1' when    op_code_s = sth_op_code_const   else
                    '0';
    address_ram_s   <= register1_data_bdr_s(6 downto 0)    when   ( op_code_s = sth_op_code_const   or  op_code_s = ldh_op_code_const) and (state_s = "01");
    data_in_ram_s   <= register2_data_bdr_s                when   ( op_code_s = sth_op_code_const   or  op_code_s = ldh_op_code_const) and (state_s = "01"); -- mudar aqui 

    clk_proc_s      <=  clk_proc;
    rst_proc_s      <=  rst_proc;

end architecture;
