library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_filtre_pipeline is
end tb_filtre_pipeline;

architecture sim of tb_filtre_pipeline is

    -----------------------------------------------------------------
    -- Composant à tester
    -----------------------------------------------------------------
    component filtre_pipeline
        Port (
            clk   : in  std_logic;
            rst   : in  std_logic;
            x_in  : in  signed(15 downto 0);
            y_out : out signed(19 downto 0)
        );
    end component;

    -----------------------------------------------------------------
    -- Signaux internes
    -----------------------------------------------------------------
    signal clk   : std_logic := '0';
    signal rst   : std_logic := '1';
    signal x_in  : signed(15 downto 0) := (others => '0');
    signal y_out : signed(19 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin

    -----------------------------------------------------------------
    -- Instanciation du DUT
    -----------------------------------------------------------------
    DUT: filtre_pipeline
        port map (
            clk   => clk,
            rst   => rst,
            x_in  => x_in,
            y_out => y_out
        );

    -----------------------------------------------------------------
    -- Génération de l’horloge
    -----------------------------------------------------------------
    clk_process : process
    begin
        while now < 800 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -----------------------------------------------------------------
    -- Processus de stimulation
    -----------------------------------------------------------------
    stim_process : process
    begin
        -----------------------------------------------------------------
        -- Phase 1 : Reset
        -----------------------------------------------------------------
        rst <= '1';
        wait for 4 * CLK_PERIOD;
        rst <= '0';
 --       wait for CLK_PERIOD;

        -----------------------------------------------------------------
        -- Phase 2 : Séquence d’échantillons
        -----------------------------------------------------------------
        -- 4 échantillons à 10
        x_in <= to_signed(10, 16);
        wait for CLK_PERIOD;
        x_in <= to_signed(10, 16);
        wait for CLK_PERIOD;
        x_in <= to_signed(10, 16);
        wait for CLK_PERIOD;
        x_in <= to_signed(10, 16);
        wait for CLK_PERIOD;

        -- 4 échantillons à 20
        x_in <= to_signed(20, 16);
        wait for CLK_PERIOD;
        x_in <= to_signed(20, 16);
        wait for CLK_PERIOD;
        x_in <= to_signed(20, 16);
        wait for CLK_PERIOD;
        x_in <= to_signed(20, 16);
        wait for CLK_PERIOD;

        -- 4 échantillons à 30
        x_in <= to_signed(30, 16);
        wait for CLK_PERIOD;
        x_in <= to_signed(30, 16);
        wait for CLK_PERIOD;
        x_in <= to_signed(30, 16);
        wait for CLK_PERIOD;
        x_in <= to_signed(30, 16);
        wait for CLK_PERIOD;

        -- Retour à zéro
        x_in <= to_signed(0, 16);
        wait for 4 * CLK_PERIOD;

        -----------------------------------------------------------------
        -- Fin de simulation
        -----------------------------------------------------------------
        wait;
    end process;

end sim;
