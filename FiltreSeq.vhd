---- faut mettre un registre au bout pour prevenir de la fin de calcul


library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity FiltreSeq is
	port(
		e0,e1,e2,e3 : in std_logic_vector(3 downto 0);
		clk,Rs: in std_logic;
		x : in std_logic_vector(15 downto 0);
		y : out std_logic_vector(15 downto 0)
	);
end FiltreSeq;

Architecture Arch_FiltreSeq of FiltreSeq is
	
	Component FSM
		port(clk,Rs : in std_logic;
			sel : out std_logic_vector(1 downto 0);
			ini,fin : out std_logic
			);
	end component;
	

	Component mux4
		generic(taille : integer);
		port(
			selection : in std_logic_vector(1 downto 0);
			in1,in2,in3,in4 : in std_logic_vector(taille-1 downto 0);
			S : out std_logic_vector(taille-1 downto 0)
		);
	end component;
	
	Component mux2
		generic(taille : integer);
		port(
			selection : in std_logic;
			in1,in2 : in std_logic_vector(taille-1 downto 0);
			S : out std_logic_vector(taille-1 downto 0)
		);
	
	end component;
	
	Component MAC
		port(
			init : in std_logic;
			clk,Rs : in std_logic;
			a : in std_logic_vector(15 downto 0);
			b : in std_logic_vector(3 downto 0);
			Accu : out std_logic_vector(19 downto 0)
		);
	end component;
	
	
	
	signal x0,x1,x2,x3 : std_logic_vector(15 downto 0);
	signal sigE0,sigE1,sigE2,sigE3 : std_logic_vector(3 downto 0);
	signal sigSelec : std_logic_vector(1 downto 0);
	signal sigIni,sigFin : std_logic;
	
	signal sigCoeff: std_logic_vector(3 downto 0);
	signal sigEntry : std_logic_vector(15 downto 0);
	
	signal sigAccu : std_logic_vector(19 downto 0);

begin

	process(clk,Rs,sigFin)
	begin
		if(Rs = '0')then
			x0 <= (others => '0');
			x1<= (others => '0');
			x2<= (others => '0');
			x3<= (others => '0');
			sigE0<= (others => '0');
			sigE1<= (others => '0');
			sigE2<= (others => '0');
			sigE3 <= (others => '0');
			y <= (others => '0');
		elsif(rising_edge(clk) and sigFin = '1')then
			x0 <= x;
			x1 <= x0;
			x2 <= x1;
			x3 <= x2;
			sigE0 <= e0;
			sigE1 <= e1;
			sigE2 <= e2;
			sigE3 <= e3;
			y <= sigAccu(19 downto 4);
		end if;
	end process;

	muxEntry : mux4
	generic map (taille => 16)
	Port Map(
		selection => sigSelec, --Machine d'etat
		in1=>x0,
		in2=>x1,
		in3=>x2,
		in4=>x3,
		S => sigEntry
	);
	
	muxCoef : mux4
	generic map (taille => 4)
	Port Map(
		selection => sigSelec,--Machine d'etat
		in1=>sigE0,
		in2=>sigE1,
		in3=>sigE2,
		in4=>sigE3,
		S => sigCoeff
	);
	
	controlUnit : FSM
	Port Map(
		clk=>clk,
		Rs=>Rs,
		sel=> sigSelec,
		ini => sigIni,
		--E => sigE,
		fin => sigFin
	);
	
	MultAndAcc : MAC
	port map(
		init=>sigIni,
		clk=>clk,
		Rs=>Rs,
		a => sigEntry,
		b => sigCoeff,
		Accu => sigAccu
	);
	
	
end Arch_FiltreSeq;
