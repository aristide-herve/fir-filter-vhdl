
-- A lire absolument en entier avant toute compilation



-----------------------------------------------------------------------
--    Attention, cette implementation contient 3 version du filtre parallele. 
--	 
--	 Une premiere dans laquelle les coefficients du filtre sont definis comme des 
--	 vecteurs d'entree sans utiliser le mot cle constante, une deuxieme dans laquelle 
--	 ces derniers sont definits avec le mot cle constante de vhdl et une troisieme 
--	 identique a la precedente sauf que les mutliplications sont faites par des IP pour forcer
--	 l'utlisation des DSP car avec les constantes, les parametrages quartus ne suffisent plus 
--	 pour forcer l utilisation des DSP pour la multiplication

--
-- Tres Important pour utliser chaque implementation du filtre, decommenter seulement la partie correspondante
--et commenter les autres. Faire attention a utiliser le testbench correspondant. Les tests bench sont ecrits aussi 
--dans le meme ordre
--------------------------------------------------------------------------  
	
	
	
	
	
	
	
	
	-----------------------------------------------------------------------
    --  Filtre 1: Les coefficients sont declarees comme des vecteurs d entree
   --------------------------------------------------------------------------

	 
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL; --- contient la definition des operations arithmetique entre vecteurs sans quoi le produit entre vecteurs ne serait pas reconnu il faudrait alors convertir en signe ou non  signe avant de faire la mutilplication
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity filtre_parallele is
    Port (
        clk   : in  std_logic;
        rst   : in  std_logic;

        a0,a1,a2,a3 : in std_logic_vector(3 downto 0);
        x_in        : in std_logic_vector(15 downto 0);
        y_out       : out std_logic_vector(19 downto 0)
    );
end filtre_parallele;

architecture rtl of filtre_parallele is

    signal x_reg0, x_reg1, x_reg2, x_reg3 : std_logic_vector(15 downto 0);
    signal y_comb : std_logic_vector(19 downto 0);
    signal y_reg  : std_logic_vector(19 downto 0);

begin

    -------------------------------------------------------------------------
    -- Décalage des échantillons
    -------------------------------------------------------------------------
    process(clk, rst)
    begin
        if rst = '1' then
            x_reg0 <= (others => '0');
            x_reg1 <= (others => '0');
            x_reg2 <= (others => '0');
            x_reg3 <= (others => '0');
            y_out  <= (others => '0');

        elsif rising_edge(clk) then
            x_reg3 <= x_reg2;
            x_reg2 <= x_reg1;
            x_reg1 <= x_reg0;
            x_reg0 <= x_in;

            y_out <= y_reg;
        end if;
    end process;

    -------------------------------------------------------------------------
    -- Calcul du filtre
    -------------------------------------------------------------------------
    y_comb <= a0*x_reg0
            + a1*x_reg1
            + a2*x_reg2
            + a3*x_reg3;

    y_reg <= "0000" & y_comb(19 DOWNTO 4);

end rtl;












    ------------------------------------------------------------------------
    -- Filtre 2 : Sans Utilisation du block IP de multiplication, avec des constantes bien declarees 
    -------------------------------------------------------------------------
--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--
--entity filtre_parallele is
--    Port (
--        clk   : in  std_logic;
--        rst   : in  std_logic;
--		  x_in  : in  signed(15 downto 0);
--        y_out : out signed(19 downto 0)
--    );
--end filtre_parallele;
--
--architecture rtl of filtre_parallele is
--
--
--    type sample_array is array (0 to 3) of signed(15 downto 0);
--
--
--    constant a0 : signed(3 downto 0) := to_signed(7,4);
--    constant a1 : signed(3 downto 0) := to_signed(5,4);
--    constant a2 : signed(3 downto 0) := to_signed(3,4);
--    constant a3 : signed(3 downto 0) := to_signed(1,4);
--
--    signal x_reg : sample_array := (others => (others => '0'));
--
--	 
--    signal y_comb : signed(19 downto 0);
--
--	 
--    signal y_reg  : signed(19 downto 0);
--	 
--	 signal p0, p1, p2, p3 : signed(19 downto 0) := (others => '0');
--
--begin
--
-- 
--    process(clk, rst)
--    begin
--        if rst = '1' then
--            x_reg <= (others => (others => '0'));
--				y_out <= (others => '0');
--
--
--        elsif rising_edge(clk) then
--           
--           
--			 
--				x_reg(3) <= x_reg(2);
--            x_reg(2) <= x_reg(1);
--            x_reg(1) <= x_reg(0);
--            x_reg(0) <= x_in;
--				y_out <= y_reg;
--				
--
--        end if;
--		 
--	 end process;
--	 
--	 y_comb <= a0*x_reg(0)+ a1* x_reg(1) + a2* x_reg(2) + a3* x_reg(3);
--	 y_reg <= "0000" & y_comb(19 DOWNTO 4);
--    
--end rtl;

--
--
--
--
--
--
--
--
--
--
   -------------------------------------------------------------------------
    -- Filtre 3: Utilisation du block IP de multiplication avec des constantes bien declarees pour forcer l'utilisation des DSP 
    -------------------------------------------------------------------------

--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--
--entity filtre_parallele is
--    Port (
--        clk   : in  std_logic;
--        rst   : in  std_logic;
--        x_in  : in  std_logic_vector(15 downto 0);
--        y_out : out std_logic_vector(19 downto 0)
--    );
--end filtre_parallele;
--
--architecture rtl of filtre_parallele is
--
--    -----------------------------------------------------------------------
--    -- COEFFICIENTS (format std_logic_vector, compatibles IP)
--    -----------------------------------------------------------------------
--    constant a0 : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(7,4));
--    constant a1 : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(5,4));
--    constant a2 : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(3,4));
--    constant a3 : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(1,4));
--
--    -----------------------------------------------------------------------
--    -- REGISTRES DES ENTRÉES
--    -----------------------------------------------------------------------
--    type sample_array is array (0 to 3) of std_logic_vector(15 downto 0);
--    signal x_reg : sample_array := (others => (others => '0'));
--
--    -----------------------------------------------------------------------
--    -- PRODUITS ET SOMMES (std_logic_vector)
--    -----------------------------------------------------------------------
--    signal p0, p1, p2, p3 : std_logic_vector(19 downto 0);
--    signal y_comb, y_reg  : std_logic_vector(19 downto 0);
--
--    -----------------------------------------------------------------------
--    -- DECLARATION DU MULTIPLICATEUR COMPATIBLE IP
--    -----------------------------------------------------------------------
--    component IP_Mult
--        port (
--            dataa  : in  std_logic_vector(15 downto 0);
--            datab  : in  std_logic_vector(3 downto 0);
--            result : out std_logic_vector(19 downto 0)
--        );
--    end component;
--
--begin
--
--    -----------------------------------------------------------------------
--    -- PIPELINE D’ENTRÉE
--    -----------------------------------------------------------------------
--    process(clk, rst)
--    begin
--        if rst = '1' then
--            x_reg <= (others => (others => '0'));
--            y_out <= (others => '0');
--        elsif rising_edge(clk) then
--            x_reg(3) <= x_reg(2);
--            x_reg(2) <= x_reg(1);
--            x_reg(1) <= x_reg(0);
--            x_reg(0) <= x_in;
--
--            y_out <= y_reg;
--        end if;
--    end process;
--
--    -----------------------------------------------------------------------
--    -- INSTANCIATION DES MULTIPLICATEURS
--    -----------------------------------------------------------------------
--    mult0 : IP_Mult port map (dataa => x_reg(0), datab => a0, result => p0);
--    mult1 : IP_Mult port map (dataa => x_reg(1), datab => a1, result => p1);
--    mult2 : IP_Mult port map (dataa => x_reg(2), datab => a2, result => p2);
--    mult3 : IP_Mult port map (dataa => x_reg(3), datab => a3, result => p3);
--
--    -----------------------------------------------------------------------
--    -- ADDITION DES PRODUITS
--    -----------------------------------------------------------------------
--    y_comb <= std_logic_vector(
--                 unsigned(p0) +
--                 unsigned(p1) +
--                 unsigned(p2) +
--                 unsigned(p3)
--              );
--
--    y_reg <= "0000" & y_comb(19 DOWNTO 4);
--
--end rtl;
