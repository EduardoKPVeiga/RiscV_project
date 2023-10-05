library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity banco_de_regs is
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
end entity;

architecture a_banco_de_regs of banco_de_regs is

    constant reg0           : unsigned(15 downto 0) := "0000000000000000";
    constant reg1           : unsigned(15 downto 0) := "0000000000000001";
    constant reg2           : unsigned(15 downto 0) := "0000000000000010";
    constant reg3           : unsigned(15 downto 0) := "0000000000000011";
    constant reg4           : unsigned(15 downto 0) := "0000000000000100";
    constant reg5           : unsigned(15 downto 0) := "0000000000000101";
    constant reg6           : unsigned(15 downto 0) := "0000000000000110";
    constant reg7           : unsigned(15 downto 0) := "0000000000000111";
    constant zero           : unsigned(15 downto 0) := "0000000000000000";
    constant erro_value     : unsigned(15 downto 0) := "1111111111111111";

    component reg16bits
        port(
            clk             : in std_logic;
            rst             : in std_logic;
            wr_en           : in std_logic;
            data_in         : in  unsigned(15 downto 0);
            data_out        : out unsigned(15 downto 0)
        );
    end component;

    component ula
        port(
            x, y            : in  unsigned(15 downto 0);
            op_code         : in  unsigned(1 downto 0);
            res             : out unsigned(15 downto 0)
        );
    end component;

    signal ula_res_s        : unsigned(15 downto 0) := zero;
    signal value_s          : unsigned(15 downto 0);
    signal read_data1_s     : unsigned(15 downto 0);
    signal read_data2_s     : unsigned(15 downto 0);

    signal x_s, y_s         : unsigned(15 downto 0);
    signal op_code_s        : unsigned(1 downto 0);

    -- Single clock, reset and only write in 1 register per time
    signal clk_s, rst_s     : std_logic;    
    signal data_in_s        : unsigned(15 downto 0);

    -- Register 0
    signal wr_en_0_s        : std_logic;
    signal data_out_0_s     : unsigned(15 downto 0);

    -- Register 1
    signal wr_en_1_s        : std_logic;
    signal data_out_1_s     : unsigned(15 downto 0);

    -- Register 2
    signal wr_en_2_s        : std_logic;
    signal data_out_2_s     : unsigned(15 downto 0);

    -- Register 3
    signal wr_en_3_s        : std_logic;
    signal data_out_3_s     : unsigned(15 downto 0);

    -- Register 4
    signal wr_en_4_s        : std_logic;
    signal data_out_4_s     : unsigned(15 downto 0);

    -- Register 5
    signal wr_en_5_s        : std_logic;
    signal data_out_5_s     : unsigned(15 downto 0);

    -- Register 6
    signal wr_en_6_s        : std_logic;
    signal data_out_6_s     : unsigned(15 downto 0);

    -- Register 7
    signal wr_en_7_s        : std_logic;
    signal data_out_7_s     : unsigned(15 downto 0);

begin
    ula_c : ula
    port map(
        x           => x_s,
        y           => y_s,
        op_code     => op_code_s,
        res         => ula_res_s
    );

    register_0_c : reg16bits
    port map(
        clk         => clk_s,
        rst         => rst_s,
        wr_en       => wr_en_0_s,
        data_in     => data_in_s,
        data_out    => data_out_0_s
    );

    register_1_c : reg16bits
    port map(
        clk         => clk_s,
        rst         => rst_s,
        wr_en       => wr_en_1_s,
        data_in     => data_in_s,
        data_out    => data_out_1_s
    );

    register_2_c : reg16bits
    port map(
        clk         => clk_s,
        rst         => rst_s,
        wr_en       => wr_en_2_s,
        data_in     => data_in_s,
        data_out    => data_out_2_s
    );

    register_3_c : reg16bits
    port map(
        clk         => clk_s,
        rst         => rst_s,
        wr_en       => wr_en_3_s,
        data_in     => data_in_s,
        data_out    => data_out_3_s
    );

    register_4_c : reg16bits
    port map(
        clk         => clk_s,
        rst         => rst_s,
        wr_en       => wr_en_4_s,
        data_in     => data_in_s,
        data_out    => data_out_4_s
    );

    register_5_c : reg16bits
    port map(
        clk         => clk_s,
        rst         => rst_s,
        wr_en       => wr_en_5_s,
        data_in     => data_in_s,
        data_out    => data_out_5_s
    );

    register_6_c : reg16bits
    port map(
        clk         => clk_s,
        rst         => rst_s,
        wr_en       => wr_en_6_s,
        data_in     => data_in_s,
        data_out    => data_out_6_s
    );

    register_7_c : reg16bits
    port map(
        clk         => clk_s,
        rst         => rst_s,
        wr_en       => wr_en_7_s,
        data_in     => data_in_s,
        data_out    => data_out_7_s
    );

------------------------------------------------------------------------------------
    value_s     <= value;
    clk_s       <= clk;

    -- Enables
    wr_en_0_s   <=  '1' when    write_reg = reg0 else '0';
    wr_en_1_s   <=  '1' when    write_reg = reg1 else '0';
    wr_en_2_s   <=  '1' when    write_reg = reg2 else '0';
    wr_en_3_s   <=  '1' when    write_reg = reg3 else '0';
    wr_en_4_s   <=  '1' when    write_reg = reg4 else '0';
    wr_en_5_s   <=  '1' when    write_reg = reg5 else '0';
    wr_en_6_s   <=  '1' when    write_reg = reg6 else '0';
    wr_en_7_s   <=  '1' when    write_reg = reg7 else '0';

    read_data1_s    <=  data_out_0_s    when    read_reg1 = reg0    else
                        data_out_1_s    when    read_reg1 = reg1    else
                        data_out_2_s    when    read_reg1 = reg2    else
                        data_out_3_s    when    read_reg1 = reg3    else
                        data_out_4_s    when    read_reg1 = reg4    else
                        data_out_5_s    when    read_reg1 = reg5    else
                        data_out_6_s    when    read_reg1 = reg6    else
                        data_out_7_s    when    read_reg1 = reg7    else
                        zero;

    read_data2_s    <=  data_out_0_s    when    read_reg2 = reg0    else
                        data_out_1_s    when    read_reg2 = reg1    else
                        data_out_2_s    when    read_reg2 = reg2    else
                        data_out_3_s    when    read_reg2 = reg3    else
                        data_out_4_s    when    read_reg2 = reg4    else
                        data_out_5_s    when    read_reg2 = reg5    else
                        data_out_6_s    when    read_reg2 = reg6    else
                        data_out_7_s    when    read_reg2 = reg7    else
                        zero;
    
    read_data1  <=  read_data1_s;
    read_data2  <=  read_data2_s;

    -- ULA
    x_s         <=  read_data1_s;
    y_s         <=  read_data2_s;
    op_code_s   <=  "00";

    data_in_s   <=  ula_res_s   when    ula_res_s /= zero else    value_s;

end architecture;