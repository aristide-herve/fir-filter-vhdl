library ieee;
use ieee.std_logic_1164.all;

Entity FSM is
	port(clk,Rs : in std_logic;
			sel : out std_logic_vector(1 downto 0);
			ini,fin : out std_logic
			);
end FSM;

Architecture Arch_FSM of FSM is

	Type state is (A,B,C,D);
	signal etat,etat_f: state;

begin
P1 : process(clk,Rs)
	begin
		if(Rs = '0')then
			etat <=A;
		elsif(rising_edge(clk) and Rs = '1')then
			etat <= etat_f;
		end if;
end process P1;

P2 : process(etat)
	begin
		if(etat = A)then
			sel <= "00";
			ini <= '1';
			--E <= '0';
			fin <= '1';
			
		elsif(etat = B)then
			sel <= "01";
			ini <= '0';
			--E <= '0';
			fin <= '0';
			
		elsif(etat = C)then
			sel <= "10";
			ini <= '0';
			--E <= '0';
			fin <= '0';
			--if(etat = D)
		else  
			sel <= "11";
			ini <= '0';
			--E <= '1';
			fin <= '0';
		end if;
end process P2;

P3 : process(etat,etat_f)
	begin
		case etat is 
			when A =>
				etat_f <= B;
			when B =>
				etat_f <= C;
			when C =>
				etat_f <= D;
			when D =>
				etat_f <= A;
			when others =>
				etat_f <= A;
		end case;
	
end process P3;
end Arch_FSM;