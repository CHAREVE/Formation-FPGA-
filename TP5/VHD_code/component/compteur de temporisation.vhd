-- Declaration de mon premier élement compteur 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity compteur_2 is
    Port ( clk : in STD_LOGIC;
           Reset_2 : in STD_LOGIC;
           enable_2 : in STD_LOGIC;
           scount_2 : out STD_LOGIC_VECTOR (7 downto 0));
end compteur_2;
architecture arch_compteur_2 of compteur_2 is
signal comptage_2 : integer :=0; 
signal reset_compteur_2 : std_logic := '0';
begin
	process (clk,Reset_2,enable_2)
    begin                                           
		if rising_edge (clk) then
			if Reset_2 ='1' then 
			     comptage_2 <= 0; 
			elsif enable_2 ='1' then          
			    comptage_2 <= comptage_2 + 1;
			end if;
		end if;
	end process;
 scount_2 <= std_logic_vector(to_unsigned(comptage_2,8));
 end arch_compteur_2;

