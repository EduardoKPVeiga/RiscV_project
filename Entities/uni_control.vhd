library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uni_control is
    port (
        clk       : in std_logic;     
        rst       : in std_logic;      
        instruction: out unsigned(15 downto 0) 
    );
end entity;

architecture a_uni_control of uni_control is
    signal data_s           : unsigned(15 downto 0);
    signal state_s          : std_logic;
    signal address_s        : unsigned(6 downto 0);
    signal opcode           : unsigned(3 downto 0); 
    signal jump_en          : std_logic; 
    signal pc               : unsigned(15 downto 0) := "0000000000000001";
    signal register_in_s    : unsigned(15 downto 0);
    signal register_out_s   : unsigned(15 downto 0);
    signal clk_pc_s         : std_logic; 
    signal data_in_pc_s     : unsigned(15 downto 0);   
    signal data_out_pc_s    : unsigned(15 downto 0);       
    signal wr_en_pc_s       : std_logic;  
    signal clk_s            :std_logic := clk;  
    

    component state_machine
        port (
            clk     : in std_logic;
            state   : out std_logic;
            rst     : in std_logic
        );
    end component;

    component rom
        port (
            clk     : in std_logic;
            address : in unsigned(6 downto 0);
            data    : out unsigned(15 downto 0)
        );
    end component;

    component pc_sum
    port (
        register_in  : in unsigned(15 downto 0);
        register_out : out unsigned(15 downto 0)
    );
    end component;

    component program_counter
    port (
        clk_pc          : in std_logic;
        wr_en_pc        : in std_logic;
        data_in_pc      : in  unsigned(15 downto 0);
        data_out_pc     : out unsigned(15 downto 0)
    );
    end component;

begin
    state_machine_c: state_machine
        port map (
            clk     => clk_s,
            state   => state_s,
            rst     => rst
        );

    rom_c: rom
        port map (
            clk     => clk_s,
            address => address_s,
            data    => data_s
        );

    pc_sum_c: pc_sum
        port map (
            register_in     => register_in_s,
            register_out    => register_out_s
        );
    
    program_counter_c: program_counter
        port map (
            clk_pc          => clk_s,    
            data_in_pc      => data_in_pc_s, 
            data_out_pc     => data_out_pc_s, 
            wr_en_pc        => wr_en_pc_s
        );

    data_in_pc_s <= register_out_s;
    process(clk)
    begin
        address_s <= register_out_s;
        if rising_edge(clk) then
            if state_s = '0' then
                wr_en_pc_s <= '0';
                instruction <= data_s;
            else 
                wr_en_pc_s <= '1';
                --register_in_s <= register_in_s + pc;
            end if;
            if jump_en = '1' then 
                data_s <= (others => '0') & instruction(15 downto 4); -- reedirecionado o data_s para o endereço passado na instrução
                -- a logica usada foi que os 4 ultimos bits são o opcode e o resto do codigo é o endereço
                -- completando com 0 na esquerda os 4 bits faltantes
            end if;
        end if;
    end process;
         -- Decodificação 
        jump_en <= '1' when opcode = "1111" else
                            '0';
        opcode <= instruction(3 downto 0);
    

end architecture;
