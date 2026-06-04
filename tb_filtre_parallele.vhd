  -----------------------------------------------------------------
--  estbench Filtre 1: Test bench pour la partie sans les IP mais avec des coefficients déclarees comme vecteur
-- et non avec le mot cle constante
  -----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_filtre_parallele is
end tb_filtre_parallele;

architecture sim of tb_filtre_parallele is

  
    component filtre_parallele
        Port (
            clk   : in  std_logic;
            rst   : in  std_logic;
				a0,a1,a2,a3 : in std_logic_vector(3 downto 0);
            x_in  : in  std_logic_vector(15 downto 0);
            y_out : out std_logic_vector(19 downto 0)
        );
    end component;

    signal clk   : std_logic := '0';
    signal rst   : std_logic := '1';
	 signal a0,a1,a2,a3 : std_logic_vector(3 downto 0):=(others => '0');
    signal x_in  : std_logic_vector(15 downto 0) := (others => '0');
    signal y_out : std_logic_vector(19 downto 0);


    constant Tclk : time := 10 ns;

begin


    DUT: filtre_parallele
        port map (
            clk   => clk,
            rst   => rst,
				a0 => a0,
				a1 => a1,
				a2 => a2,
				a3 => a3,
            x_in  => x_in,
            y_out => y_out
        );

 
    clk_process : process
  begin
        while now < 600 ns loop 
            clk <= not clk;
            wait for Tclk / 2;
        end loop;
        wait;  
    end process;

	 
	
    stim_process : process
    begin
        -- Reset
        rst <= '1';
        wait for 3*Tclk;
        rst <= '0';
		  a0 <= "0111"; a1 <= "0101"; a2<="0011"; a3<="0001";
        
		  
		  --        -----------------------------------------------------------------
        -- Envoi de valeurs 100
        -----------------------------------------------------------------
        x_in <= std_logic_vector(to_unsigned(100,16));
        wait for 7*Tclk;


        -----------------------------------------------------------------
        -- Envoi de valeurs 400
        -----------------------------------------------------------------
        x_in <= std_logic_vector(to_unsigned(400,16));
        wait for 11*Tclk;


        -----------------------------------------------------------------
        -- Envoi de valeurs 800
        -----------------------------------------------------------------
        x_in <= std_logic_vector(to_unsigned(800,16));
        wait for 7*Tclk;


  
        wait;
    end process;

end sim;

  -----------------------------------------------------------------
--  Test bench Filtre 2 pour la partie sans les IP mais avec des coefficients 
--  déclarees avec le mot cle constante 
  -----------------------------------------------------------------

--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--
--entity tb_filtre_parallele is
--end tb_filtre_parallele;
--
--architecture sim of tb_filtre_parallele is
--
--  
--    component filtre_parallele
--        Port (
--            clk   : in  std_logic;
--            rst   : in  std_logic;
--            x_in  : in  signed(15 downto 0);
--            y_out : out signed(19 downto 0)
--        );
--    end component;
--
--    signal clk   : std_logic := '0';
--    signal rst   : std_logic := '1';
--    signal x_in  : signed(15 downto 0) := (others => '0');
--    signal y_out : signed(19 downto 0);
--
--
--    constant Tclk : time := 10 ns;
--
--begin
--
--
--    DUT: filtre_parallele
--        port map (
--            clk   => clk,
--            rst   => rst,
--            x_in  => x_in,
--            y_out => y_out
--        );
--
-- 
--    clk_process : process
--  begin
--        while now < 600 ns loop 
--            clk <= not clk;
--            wait for Tclk / 2;
--        end loop;
--        wait;  
--    end process;
--
--	 
--	
--    stim_process : process
--    begin
--        -- Reset
--        rst <= '1';
--        wait for 3*Tclk;
--        rst <= '0';
--
--        x_in <= to_signed(100,16);
--        wait for 7*Tclk;

--
--   
--        x_in <= to_signed(400,16);
--        wait for 11*Tclk;

--		  
--		 
--        x_in <= to_signed(800,16);
--        wait for 7*Tclk;


--
--  
--        wait;
--    end process;
--
--end sim;





  -----------------------------------------------------------------
        -- Test bench Filtre 3 pour la partie avec les IP
  -----------------------------------------------------------------







--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--
--entity tb_filtre_parallele is
--end tb_filtre_parallele;
--
--architecture sim of tb_filtre_parallele is
--
--    ---------------------------------------------------------------------
--    -- Composant DUT (adapté à std_logic_vector)
--    ---------------------------------------------------------------------
--    component filtre_parallele
--        Port (
--            clk   : in  std_logic;
--            rst   : in  std_logic;
--            x_in  : in  std_logic_vector(15 downto 0);
--            y_out : out std_logic_vector(19 downto 0)
--        );
--    end component;
--
--    ---------------------------------------------------------------------
--    -- Signaux du testbench
--    ---------------------------------------------------------------------
--    signal clk   : std_logic := '0';
--    signal rst   : std_logic := '1';
--    signal x_in  : std_logic_vector(15 downto 0) := (others => '0');
--    signal y_out : std_logic_vector(19 downto 0);
--
--    constant Tclk : time := 10 ns;
--
--begin
--
--    ---------------------------------------------------------------------
--    -- Instanciation DUT
--    ---------------------------------------------------------------------
--    DUT : filtre_parallele
--        port map (
--            clk   => clk,
--            rst   => rst,
--            x_in  => x_in,
--            y_out => y_out
--        );
--
--    ---------------------------------------------------------------------
--    -- Horloge
--    ---------------------------------------------------------------------
--    clk_process : process
--    begin
--        while now < 600 ns loop 
--            clk <= not clk;
--            wait for Tclk / 2;
--        end loop;
--        wait;
--    end process;
--
--    ---------------------------------------------------------------------
--    -- Stimuli
--    ---------------------------------------------------------------------
--    stim_process : process
--    begin
--        -----------------------------------------------------------------
--        -- RESET
--        -----------------------------------------------------------------
--        rst <= '1';
--        wait for 3*Tclk;
--        rst <= '0';
--
--        -----------------------------------------------------------------
--        -- Envoi de valeurs 100
--        -----------------------------------------------------------------
--        x_in <= std_logic_vector(to_unsigned(100,16));
--        wait for 5*Tclk;

--
--        -----------------------------------------------------------------
--        -- Envoi de valeurs 400
--        -----------------------------------------------------------------
--        x_in <= std_logic_vector(to_unsigned(400,16));
--        wait for 5*Tclk;

--
--        -----------------------------------------------------------------
--        -- Envoi de valeurs 800
--        -----------------------------------------------------------------
--        x_in <= std_logic_vector(to_unsigned(800,16));
--        wait for 4*Tclk;

--
--        wait;
--    end process;
--
--end sim;
--
--
--
