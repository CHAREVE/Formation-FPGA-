
--*****************************************************counter_unit du tp precedent**********
--##-- appel du premier composant : compteur ##
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity compteur_1 is
    Port ( clk : in STD_LOGIC;
           Reset_1 : in STD_LOGIC;
           enable_1 : in STD_LOGIC;
           scount_1 : out STD_LOGIC_VECTOR (27 downto 0));
end compteur_1;
architecture arch_compteur_1 of compteur_1 is
signal comptage_1 : integer :=0; 
--signal reset_compteur_1 : std_logic := '0';
begin
	process (clk,Reset_1,enable_1)
    begin                                           
		if rising_edge (clk) then
			if Reset_1 ='1' then 
			     comptage_1 <= 0; 
			elsif enable_1 ='1' then          
			    comptage_1 <= comptage_1 + 1;
			end if;
		end if;
	end process;
 --scount <= std_logic_vector(compteur); -- scount copie la sortie = valeur finale du compteur
 scount_1 <= std_logic_vector(to_unsigned(comptage_1,28));
-- Reset <= reset_compteur;
 end arch_compteur_1;

--##--appel de mon deuxieme composant : comparateur ##
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity comparateur_1 is
    Port ( comparateur_in_1 : in STD_LOGIC_VECTOR (27 downto 0);
           compteur_max_1 : in STD_LOGIC_VECTOR (27 downto 0);
           end_counter_1 : out STD_LOGIC);
end comparateur_1;
 architecture arch_comparateur_1 of comparateur_1 is
       begin -- on va Comparer la valeur de comparateur_in avec la valeur de comparateur_max
	   end_counter_1 <= '1' when comparateur_in_1 = compteur_max_1 else '0';
end arch_comparateur_1;

----##-- declaration de l'entité  Counter_unit ## qui va compter le nbre de coup d'horloge 
---------Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE work.ALL;

entity Counter_unit is
generic ( N : integer := 200000000); -- le nombre de coup d'horloge à compter 200000000
Port ( clk : in STD_LOGIC;
          Reset : in STD_LOGIC;
          end_counter_1 : inout STD_LOGIC := '0');     
end Counter_unit;
----Description comportementale de mon Counter_unit_1
architecture arch_Counter_unit of Counter_unit is
   
    signal scount_1 : std_logic_vector (27 downto 0);
    signal reset_1 : std_logic := '0';
 
begin
    reset_1 <=(end_counter_1 or reset);
 
    inst_compteur : entity compteur_1 port map(
          clk => clk,
          reset_1 => reset_1,
          enable_1 => '1',
		  scount_1 => scount_1 );
       
    inst_comparateur : entity comparateur_1 port map(
          comparateur_in_1 => scount_1,   
		  compteur_max_1 => std_logic_vector(to_unsigned(N,28)),
		  end_counter_1 => end_counter_1 );
		   
 end arch_Counter_unit;
