library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Entity mux4 is
generic(taille : integer);
port(
	selection : in std_logic_vector(1 downto 0);
	in1,in2,in3,in4 : in std_logic_vector(taille-1 downto 0);
	S : out std_logic_vector(taille-1 downto 0)
);
end mux4;

Architecture Arch_Mux4 of mux4 is
begin

	process(selection,in1,in2,in3,in4)
	begin
		if(selection = "00")then
			S <= in1;
		elsif(selection = "01")then
			S <= in2;
		elsif(selection = "10")then
			S <= in3;
		elsif(selection = "11")then
			S <= in4;
		else
			S <= (others => '0');
		end if;
	end process;

end Arch_Mux4;