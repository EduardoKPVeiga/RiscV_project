library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity main is
    port (
        clk       : in std_logic;      -- Clock de sistema
        rst       : in std_logic;      -- Sinal de reset
        state     : out std_logic;     -- Sinal de estado da máquina de estados (0 ou 1)
        instruction: out unsigned(15 downto 0) -- Instrução lida da ROM
    );
end entity;

architecture a_main of main is
    signal data_s      : unsigned(15 downto 0);
    signal state_s     : std_logic;
    signal address_s   : unsigned(6 downto 0) := "0000000"; -- Endereço inicial da ROM
    signal opcode      : unsigned(3 downto 0); -- Opcode da instrução
    signal jump_en     : std_logic; -- Sinal de controle para instrução de salto

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

begin
    sm_inst: state_machine
        port map (
            clk     => clk,
            state   => state_s,
            rst     => reset
        );

    rom_inst: rom
        port map (
            clk     => clk,
            address => address_s,
            data    => data_s
        );

    -- Atualiza o endereço da ROM com base no estado da máquina
    process(clk)
    begin
        if rising_edge(clk) then
            address_s <= address_s + (1 when state_s = '0' else 0); -- Incrementa no estado 0 (fetch)
        end if;
    end process;

    -- Decodificação do opcode usando when
    process
    begin
        opcode <= data_s(11 downto 8);
        case opcode is
            when "1111" =>
                jump_en <= '1'; -- Instrução de salto
            when others =>
                jump_en <= '0'; -- Outras instruções
        end case;
    end process;

    -- Saídas do módulo principal
    state <= state_s;
    instruction <= data_s;

end architecture;
