library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity MAC is
	port(
		init : in std_logic;
		clk,Rs : in std_logic;
		a : in std_logic_vector(15 downto 0);
		b : in std_logic_vector(3 downto 0);
		Accu : out std_logic_vector(19 downto 0)
	);
end MAC;

Architecture Arch_MAC of MAC is

	Component mux2
	generic(taille : integer);
	port(
		selection : in std_logic;
		in1,in2 : in std_logic_vector(taille-1 downto 0);
		S : out std_logic_vector(taille-1 downto 0)
	);
	end component;
	
	signal sigMux ,sigReg: std_logic_vector(19 downto 0); 
begin

	muxMAC : mux2
	generic map (taille => 20)
	port map(
		selection => init,
		in1 => (others => '0'),
		in2 => sigReg,
		S => sigMux
	);
	
	
	
	
	process(clk,Rs)
	begin
		if(Rs = '0')then
			sigReg <= (others =>'0');
		elsif(rising_edge(clk) and Rs = '1')then
			sigReg <= sigMux + (a*b);
		end if;
	end process;
	
	Accu <= sigReg;

end Arch_MAC;