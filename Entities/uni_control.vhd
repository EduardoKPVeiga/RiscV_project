library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uni_control is
    port (    
        instruction     : in  unsigned(15 downto 0);
        next_reg_pc_sum : in  unsigned(15 downto 0);
        next_reg_pc     : out unsigned(15 downto 0);
        wr_en_pc        : out std_logic;
        state_mch       : in  unsigned(1 downto 0)
    );
end entity;

architecture a_uni_control of uni_control is
    
    signal jump_en_s    : std_logic;
    signal opcode_s     : unsigned(5 downto 0);

begin
    wr_en_pc    <=  '1'  when    state_mch = "10"  else
                    '0';

    next_reg_pc <=  "00000000000" & instruction(4 downto 0)     when    jump_en_s = '1' and state_mch = "10"    else
                    next_reg_pc_sum when    state_mch = "10"    else
                    "0000000000000000";

     -- Decodificação 
    opcode_s    <=  instruction(10 downto 5);

    jump_en_s   <=  '1' when opcode_s = "000011"  else
                    '0';
end architecture;
