library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity mux2 is
generic(taille : integer);
port(
	selection : in std_logic;
	in1,in2 : in std_logic_vector(taille-1 downto 0);
	S : out std_logic_vector(taille-1 downto 0)
);
end mux2;

Architecture Arch_mux2 of mux2 is
begin

	process(selection,in1,in2)
	begin
		if(selection = '1')then
			S <= in1;
		elsif(selection = '0')then
			S <= in2;
		else
			S <= (others => '0');
		end if;
	end process;

end Arch_mux2;