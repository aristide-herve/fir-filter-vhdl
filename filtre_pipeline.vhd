--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--
--entity filtre_pipeline is
--    Port (
--        clk   : in  std_logic;
--        rst   : in  std_logic;
--        x_in  : in  signed(15 downto 0);
--        y_out : out signed(19 downto 0)
--    );
--end filtre_pipeline;
--
--architecture rtl of filtre_pipeline is
--
--    -----------------------------------------------------------------
--    -- Déclaration des signaux
--    -----------------------------------------------------------------
--    -- Registres d’entrée (4 échantillons)
--    signal x0, x1, x2, x3 : signed(15 downto 0);
--
--    -- Coefficients (7, 5, 3, 1)
--    constant a0 : signed(3 downto 0) := to_signed(7, 4);
--    constant a1 : signed(3 downto 0) := to_signed(5, 4);
--    constant a2 : signed(3 downto 0) := to_signed(3, 4);
--    constant a3 : signed(3 downto 0) := to_signed(1, 4);
--
--    -- Étape 1 : résultats des multiplications
--    signal p0, p1, p2, p3 : signed(19 downto 0);
--
--    -- Pipeline registers entre étape 1 et 2
--    signal p0_reg, p1_reg, p2_reg, p3_reg : signed(19 downto 0);
--
--    -- Étape 2 : somme et résultat
--    signal sum_reg : signed(19 downto 0);
--
--begin
--
--    -----------------------------------------------------------------
--    -- Étape 0 : mise à jour des échantillons (décalage)
--    -----------------------------------------------------------------
--    process(clk, rst)
--    begin
--        if rst = '1' then
--            x0 <= (others => '0');
--            x1 <= (others => '0');
--            x2 <= (others => '0');
--            x3 <= (others => '0');
--        elsif rising_edge(clk) then
--            x3 <= x2;
--            x2 <= x1;
--            x1 <= x0;
--            x0 <= x_in;
--        end if;
--    end process;
--
--    -----------------------------------------------------------------
--    -- Étape 1 : multiplications parallèles
--    -----------------------------------------------------------------
--    p0 <= x0*a0;
--    p1 <= x1*a1;
--    p2 <= x2*a2;
--    p3 <= x3*a3;
--
--    -----------------------------------------------------------------
--    -- Pipeline registers : séparation entre Étape 1 et Étape 2
--    -----------------------------------------------------------------
--    process(clk, rst)
--    begin
--        if rst = '1' then
--            p0_reg <= (others => '0');
--            p1_reg <= (others => '0');
--            p2_reg <= (others => '0');
--            p3_reg <= (others => '0');
--        elsif rising_edge(clk) then
--            p0_reg <= p0;
--            p1_reg <= p1;
--            p2_reg <= p2;
--            p3_reg <= p3;
--        end if;
--    end process;
--
--    -----------------------------------------------------------------
--    -- Étape 2 : somme des produits
--    -----------------------------------------------------------------
--    process(clk, rst)
--    begin
--        if rst = '1' then
--            sum_reg <= (others => '0');
--        elsif rising_edge(clk) then
--            sum_reg <= p0_reg + p1_reg + p2_reg + p3_reg;
--        end if;
--    end process;
--
--    -----------------------------------------------------------------
--    -- Sortie avec division par 16
--    -----------------------------------------------------------------
--    y_out <= "0000"&sum_reg(19 downto 4) ;
--
--end rtl;

--
--
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--
--entity filtre_pipeline is
--    Port (
--        clk   : in  std_logic;
--        rst   : in  std_logic;
--        x_in  : in  signed(15 downto 0);
--        y_out : out signed(19 downto 0)
--    );
--end filtre_pipeline;
--
--architecture rtl of filtre_pipeline is
--
--    -----------------------------------------------------------------
--    -- Coefficients constants
--    -----------------------------------------------------------------
--    constant a0 : signed(3 downto 0) := to_signed(7, 4);
--    constant a1 : signed(3 downto 0) := to_signed(5, 4);
--    constant a2 : signed(3 downto 0) := to_signed(3, 4);
--    constant a3 : signed(3 downto 0) := to_signed(1, 4);
--
--    -----------------------------------------------------------------
--    -- Signaux internes
--    -----------------------------------------------------------------
--    signal x_reg0, x_reg1, x_reg2, x_reg3 : signed(15 downto 0);
--
--    -- Étape 1 : produits des multiplications
--    signal mult0, mult1, mult2, mult3 : signed(19 downto 0);
--
--    -- Étape 2 : registres pipeline pour stocker les produits
--    signal mult0_reg, mult1_reg, mult2_reg, mult3_reg : signed(19 downto 0);
--
--    -- Étape 3 : somme et sortie
--    signal sum_reg : signed(19 downto 0);
--
--begin
--
--    -----------------------------------------------------------------
--    -- Processus séquentiel principal
--    -----------------------------------------------------------------
--    process(clk, rst)
--    begin
--        if rst = '1' then
--            x_reg0 <= (others => '0');
--            x_reg1 <= (others => '0');
--            x_reg2 <= (others => '0');
--            x_reg3 <= (others => '0');
--            mult0_reg <= (others => '0');
--            mult1_reg <= (others => '0');
--            mult2_reg <= (others => '0');
--            mult3_reg <= (others => '0');
--            sum_reg <= (others => '0');
--        elsif rising_edge(clk) then
--
--            ---------------------------------------------------------
--            -- Étape 1 : Décalage des échantillons (FIFO)
--            ---------------------------------------------------------
--            x_reg3 <= x_reg2;
--            x_reg2 <= x_reg1;
--            x_reg1 <= x_reg0;
--            x_reg0 <= x_in;
--
--            ---------------------------------------------------------
--            -- Étape 2 : Calcul des produits (multiplications)
--            ---------------------------------------------------------
--            mult0 <= resize(x_reg0 * a0, 20);
--            mult1 <= resize(x_reg1 * a1, 20);
--            mult2 <= resize(x_reg2 * a2, 20);
--            mult3 <= resize(x_reg3 * a3, 20);
--
--            ---------------------------------------------------------
--            -- Étape 3 : Pipeline — stockage des résultats des multiplications
--            ---------------------------------------------------------
--            mult0_reg <= mult0;
--            mult1_reg <= mult1;
--            mult2_reg <= mult2;
--            mult3_reg <= mult3;
--
--            ---------------------------------------------------------
--            -- Étape 4 : Somme des produits (pipeline stage 2)
--            ---------------------------------------------------------
--            sum_reg <= mult0_reg + mult1_reg + mult2_reg + mult3_reg;
--				
--				 -----------------------------------------------------------------
--				 -- Sortie avec division par 16
--				 -----------------------------------------------------------------
--				 y_out <= sum_reg(19 downto 4) & "0000";
--
--        
--		  
--		  end if;
--    end process;
--
--end rtl;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity filtre_pipeline is
    Port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        x_in  : in  signed(15 downto 0);
        y_out : out signed(19 downto 0)
    );
end filtre_pipeline;

architecture rtl of filtre_pipeline is

    -- Coefficients
    constant a0 : signed(3 downto 0) := to_signed(7, 4);
    constant a1 : signed(3 downto 0) := to_signed(5, 4);
    constant a2 : signed(3 downto 0) := to_signed(3, 4);
    constant a3 : signed(3 downto 0) := to_signed(1, 4);

    -- Registres d’entrée
    signal x_reg0, x_reg1, x_reg2, x_reg3 : signed(15 downto 0) := (others => '0');

    -- Produits
    signal mult0, mult1, mult2, mult3 : signed(19 downto 0) := (others => '0');
    signal mult0_reg, mult1_reg, mult2_reg, mult3_reg : signed(19 downto 0) := (others => '0');

    -- Somme
    signal sum_reg : signed(19 downto 0) := (others => '0');
	 
	     -- Registre de sortie
    signal y_reg  : signed(19 downto 0);

begin

    -----------------------------------------------------------------
    -- Étape 1 : Décalage + multiplications
    -----------------------------------------------------------------
    process(clk, rst)
    begin
        if rst = '1' then
            x_reg0 <= (others => '0');
            x_reg1 <= (others => '0');
            x_reg2 <= (others => '0');
            x_reg3 <= (others => '0');
            mult0 <= (others => '0');
            mult1 <= (others => '0');
            mult2 <= (others => '0');
            mult3 <= (others => '0');
        elsif rising_edge(clk) then
            -- Décalage
            x_reg3 <= x_reg2;
            x_reg2 <= x_reg1;
            x_reg1 <= x_reg0;
            x_reg0 <= x_in;

            -- Multiplications (produits instantanés)
            mult0 <= resize(x_reg0 * a0, 20);
            mult1 <= resize(x_reg1 * a1, 20);
            mult2 <= resize(x_reg2 * a2, 20);
            mult3 <= resize(x_reg3 * a3, 20);
        end if;
    end process;

    -----------------------------------------------------------------
    -- Étape 2 : Pipeline (stockage des produits)
    -----------------------------------------------------------------
    process(clk, rst)
    begin
        if rst = '1' then
            mult0_reg <= (others => '0');
            mult1_reg <= (others => '0');
            mult2_reg <= (others => '0');
            mult3_reg <= (others => '0');
        elsif rising_edge(clk) then
            mult0_reg <= mult0;
            mult1_reg <= mult1;
            mult2_reg <= mult2;
            mult3_reg <= mult3;
        end if;
    end process;

    -----------------------------------------------------------------
    -- Étape 3 : Somme et division
    -----------------------------------------------------------------
    process(clk, rst)
    begin
        if rst = '1' then
           sum_reg <= (others => '0');
			
        elsif rising_edge(clk) then
            sum_reg <= mult0_reg + mult1_reg + mult2_reg + mult3_reg;
				

        end if;
    end process;
	 
	 y_reg <= "0000"&sum_reg(19 downto 4)  ;
	 y_out<= y_reg;
				
    -- Division par 16

end rtl;


