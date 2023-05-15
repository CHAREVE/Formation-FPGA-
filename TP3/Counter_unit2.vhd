
--*****************************************************tp2counter**********
--##-- appel du premier composant : compteur ##
-- Declaration de ma bibliothèque
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
 --scount <= std_logic_vector(compteur); -- scount copie la sortie = valeur finale du compteur
 scount_2 <= std_logic_vector(to_unsigned(comptage_2,8));
-- Reset <= reset_compteur;
 end arch_compteur_2;

--##--appel de mon deuxieme composant : comparateur ##
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity comparateur_2 is
    Port ( comparateur_in_2 : in STD_LOGIC_VECTOR (7 downto 0);
           compteur_max_2 : in STD_LOGIC_VECTOR (7 downto 0);
           end_counter_2 : out STD_LOGIC);
end comparateur_2;
 architecture arch_comparateur_2 of comparateur_2 is
       begin -- on va Comparer la valeur de comparateur_in avec la valeur de comparateur_max
	   end_counter_2 <= '1' when comparateur_in_2 = compteur_max_2 else '0';
end arch_comparateur_2;
--****************************************************************tp2counter*****
--##-- declaration de l'entité  Counter_unit2 ## qui va compter le nbre de coup d'horloge DE TP1
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE work.ALL;

entity Counter_unit_2 is
generic ( M : integer := 6);--255); -- le nombre de coup à compter
    Port ( clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Enable_2 : in STD_LOGIC;
           end_counter_2 : inout STD_LOGIC := '0');     
end Counter_unit_2;
----Description comportementale de mon Counter_unit
architecture arch_Counter_unit_2 of Counter_unit_2 is
  signal scount_2 : std_logic_vector (7 downto 0);
  signal reset_2 : std_logic := '0';
    --constant N : integer := 200000000;
begin
reset_2 <=(end_counter_2 or reset);
    inst_compteur_2 : entity compteur_2 port map(
          clk => clk,
          reset_2 => reset_2,
          enable_2 => Enable_2,
		  scount_2 => scount_2 );
       
    inst_comparateur_2 : entity comparateur_2 port map(
          comparateur_in_2 => scount_2,   
		  compteur_max_2 => std_logic_vector(to_unsigned(M,8)),
		  end_counter_2 => end_counter_2 );
		   
 end arch_Counter_unit_2;
