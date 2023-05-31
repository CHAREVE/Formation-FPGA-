----- Declaration de mon deuxième élement comparateur
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
