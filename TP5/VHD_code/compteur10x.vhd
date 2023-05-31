
--*****************************************************tp2counter**********
--##-- mon composant Compteur contient deux entités : un compteur qui compte les coups d'horloges et un autre
-------composant comparateur (combinatoir) qui compare par rapport à une valeur compteur_max_2 si on a atteint la valeur de coup d'horloge souhaitée 
-----ensuite je rassemble les deux elements en un seul que j'appel ici "Counter_unit2" qui fait l'instantiation et regroupe element 1 et element 2




--***********************************regroupement de mes deux sous-elements (compteur et comparateur)*****
--*********************************
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE work.ALL;

entity Counter_unit_10_tp5 is
generic ( M : integer := 10); -- le nombre de coup à compter ici tp 5 M =10
    Port ( clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Enable_2 : in STD_LOGIC;
           end_counter_2 : inout STD_LOGIC := '0');     
end Counter_unit_10_tp5;
----Description comportementale de mon Counter_unit
architecture arch_Counter_unit_10_tp5 of Counter_unit_10_tp5 is
  signal scount_2 : std_logic_vector (7 downto 0);
  signal reset_2 : std_logic := '0';
   
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
		   
 end arch_Counter_unit_10_tp5;
