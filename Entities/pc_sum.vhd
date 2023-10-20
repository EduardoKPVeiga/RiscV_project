library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pc_sum is
    port (
        register_in     : in  unsigned(15 downto 0);
        register_out    : out unsigned(15 downto 0)
    );
end entity;

architecture a_pc_sum of pc_sum is
    
    constant cte_sum    : unsigned(15 downto 0) := "0000000000000001";

begin
    register_out <= register_in + cte_sum;
end architecture;