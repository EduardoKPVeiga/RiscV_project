library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level is
    port(
        bit_selector            : in unsigned(1 downto 0);
        value_top_level         : in unsigned(15 downto 0)
    );
end entity;

architecture a_top_level of top_level is
    signal value_top_level_s    :  unsigned(15 downto 0);
    signal read_reg1_s          :  unsigned(15 downto 0);
    signal read_reg2_s          :  unsigned(15 downto 0);
    signal value_s              :  unsigned(15 downto 0);
    signal write_reg_s          :  unsigned(15 downto 0);
    signal write_en_s           :  std_logic;
    signal clk_s                :  std_logic;
    signal rst_s                :  std_logic;
    signal read_data1_s         :  unsigned(15 downto 0);
    signal read_data2_s         :  unsigned(15 downto 0);
    signal x_s                  :  unsigned(15 downto 0);
    signal y_s                  :  unsigned(15 downto 0);
    signal op_code_ula_s        :  unsigned(1  downto 0);
    signal ula_res_s            :  unsigned(15 downto 0);
    signal op_code_mux_s        :  unsigned(1  downto 0);
    signal a_s                  :  unsigned(15 downto 0);
    signal b_s                  :  unsigned(15 downto 0);
    signal mux_out_s            :  unsigned(15 downto 0);
    signal adress_s             :  unsigned(6  downto 0);
    signal data_s               :  unsigned(15 downto 0);
    --clk da rom?
    signal register_in_s        :  unsigned(15 downto 0);
    signal register_out_s       :  unsigned(15 downto 0);





    component banco_de_regs
    port(
        read_reg1               : in unsigned(15 downto 0);
        read_reg2               : in unsigned(15 downto 0);
        value                   : in unsigned(15 downto 0);
        write_reg               : in unsigned(15 downto 0);
        write_en                : in std_logic;
        clk                     : in std_logic;
        rst                     : in std_logic;
        read_data1              : out unsigned(15 downto 0);
        read_data2              : out unsigned(15 downto 0)
    );
    end component;

    component ula
    port (
        x,y                     : in  unsigned(15 downto 0);
        op_code                 : in  unsigned(1 downto 0);
        res                     : out unsigned(15 downto 0)
    );
    end component;

    component mux16bits
    port (
        op_code                 : in  unsigned(1 downto 0);
        a,b                     : in  unsigned(15 downto 0);
        mux_out                 : out unsigned(15 downto 0)
    );
    end component;

    component program_counter
    end component;

    
    component pc_sum
    port(
        register_in     : in  unsigned(15 downto 0);
        register_out    : out unsigned(15 downto 0)
    );
    end component;

    component rom
    port(
        clk     : in std_logic;  --n sei como conectar esse clock no atual
        address : in unsigned(6 downto 0); --vai receber a saida do rom 
        data    : out unsigned(15 downto 0)
    );

    end component;
    begin
    ula_c : ula
        port map (
            x       => x_s,
            y       => y_s,
            op_code => op_code_ula_s,
            res     => ula_res_s
        );

    banco_de_regs_c : banco_de_regs
    port map (
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
    
    mux16bits_c : mux16bits
    port map (
        op_code     =>  op_code_mux_s,        
        a           =>  a_s,
        b           =>  b_s,      
        mux_out     =>  mux_out_s        
    );

    rom_c : rom
    port map(
        address   => address_s,
        data   => data_s
        --clk?
    );
    pc_sum_c : pc_sum
    port map(
        register_in   => register_in_s,
        register_out   => register_out_s
    );

    value_top_level_s   <= value_top_level;

    --Mux
    a_s                 <= value_top_level_s;
    b_s                 <= ula_res_s;
    op_code_mux_s       <= bit_selector;
    value_s             <=  mux_out_s;

    --Ula
    x_s                 <=  read_data1_s;
    y_s                 <=  read_data2_s;
    op_code_ula_s       <=  "00";

    --rom < - > PC
    adress_s <=  register_out_s
end architecture;

    