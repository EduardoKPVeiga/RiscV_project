library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uni_control is
    port (    
        instruction     : in  unsigned(15 downto 0);
        next_reg_pc_sum : in unsigned(15 downto 0);
        next_reg_pc     : out unsigned(15 downto 0);
        wr_en_pc        : out std_logic;
        state_mch       : in unsigned(1 downto 0)
    );
end entity;

architecture a_uni_control of uni_control is
    
    signal jump_en_s    : std_logic;
    signal opcode_s     : unsigned(3 downto 0);


begin
    wr_en_pc    <=  '0'  when    state_mch = "00"  else
                    '1';

    next_reg_pc <=  instruction     when jump_en_s = '1'    else
                    next_reg_pc_sum;

    -- a logica usada foi que os 4 ultimos bits são o opcode e o resto do codigo é o endereço
    -- completando com 0 na esquerda os 4 bits faltantes

     -- Decodificação 
    opcode_s    <=  instruction(15 downto 12);
    jump_en_s   <=  '1' when opcode_s = "1111"    else
                    '0';
end architecture;
