entity mux2x1 is
    port(
        sel             :   in std_logic;
        entr0, entr1    :   in std_logic;
        saida           :   out std_logic
    );
end entity;