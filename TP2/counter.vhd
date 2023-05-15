
--##-- declaration premier composant : compteur ##
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity compteur is
    Port ( clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           scount : out STD_LOGIC_VECTOR (27 downto 0));
end compteur;
----Description comportementale
architecture arch_compteur of compteur is
 signal comptage : integer :=0; --STD_LOGIC_VECTOR (27 downto 0);  -- indicateur de comptage interne
    
begin
	process (clk,Reset,enable)
    begin                                           -- Comptage sur le signal interne
		if rising_edge (clk) then
			if Reset ='1' then 
			     comptage <= 0; --scount <= (others => '0');
			elsif enable ='1' then          
          ----  if compteur = "111111111111111111111111111" then compteur <= (others => '0'); -- pas de condition de fin de comptage et remise à zéro.
			    comptage <= comptage + 1; --std_logic_vector(unsigned(scount) + 1); -- "+"(unsigned,int)
				--end if;
			end if;
		end if;
	end process;
 --scount <= std_logic_vector(compteur); -- scount copie la sortie = valeur finale du compteur
 scount <= std_logic_vector(to_unsigned(comptage,28));
 
 end arch_compteur;

--##--declaration deuxieme composant : comparateur ##
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparateur is
--generic ( N : integer := 200000000);
    Port ( comparateur_in : in STD_LOGIC_VECTOR (27 downto 0);
           compteur_max : in STD_LOGIC_VECTOR (27 downto 0);
           end_counter : out STD_LOGIC);
end comparateur;

--Description comportementale
------------------------------------------------
 architecture arch_comparateur of comparateur is
  
begin -- on va Comparer la valeur de comparateur_in avec la valeur de comparateur_max
	 	 --principe de ma comparison : egal <= '1' when A=B else '0';
          end_counter <= '1' when comparateur_in = compteur_max else '0';
	
	--une autre façon d'ecrire ma comparison : 
	 --if comparateur_in >= compteur_max then 
		--end_counter = '1';
		--else
		--end_counter='0';
	--end if;
end arch_comparateur;

--##--declaration troisième composant : Bascule_T_flip_flops

-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Bascule_T_Flip_Flops is

     Port ( clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           --enable : in STD_LOGIC;
		   T : in STD_LOGIC;
           t_out : inout STD_LOGIC :='0');
           --led0_b : inout STD_LOGIC :='0');
end Bascule_T_flip_flops;

--Description comportementale
------------------------------------------------
architecture arch_Bascule_T_Flip_Flops of Bascule_T_Flip_Flops is
  
begin -- on va mémoriser la dernière entrée pendant N valeur de comptage 
      -- on va laisser la led allumée 2s et etteinte pendant 2S
	      
   process(Reset,clk)
        begin
        if reset='1' then t_out <= '0';
        --if Reset='1' then led0_b <= '0';
        elsif rising_edge(clk) then
            if T ='1' then 
                if t_out ='1' then
                --if led0_b ='1' then
                    t_out <= '0';
                    --led0_b <= '0';
                else --si t_out = '0'
                    t_out <='1';
                    --led0_b <='1';
                end if;
	       end if;
	   end if;
  end process;
 
 end arch_Bascule_T_flip_flops;
--##--declaration liaison entre les differents composants et la carte 

-- Declaration de ma bibliothèque
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.ALL;

entity counter is
    Port ( clk_gen : in STD_LOGIC;
            btn0: in STD_LOGIC;
            --restart : in std_logic;
            led0_b : out STD_LOGIC);
end counter;

architecture arch_counter of counter is
    --déclaration des signaux Outputs
    signal allumer_led : std_logic := '0';
    signal comptage_tb : std_logic_vector (27 downto 0);
    signal led0_b_intern : STD_LOGIC := '0';
    signal restart : std_logic := '0';
    signal reset_compteur : std_logic := '0';
    -- Clock period definitions
    constant N : integer := 200000000;
begin
    
    -- Gestion des inputs
    -- clk_gen => pas de traitement
    restart <= btn0 ;
    reset_compteur <=(allumer_led or restart);
    
    inst_compteur : entity compteur port map(
          clk => clk_gen,
          Reset => reset_compteur,
          enable => '1',
		  scount => comptage_tb );
       
    inst_comparateur : entity comparateur port map(
          comparateur_in => comptage_tb,   
		  compteur_max => std_logic_vector(to_unsigned(N,28)),
		  end_counter => allumer_led );
		  
	inst_Bascule_T_Flip_Flops : entity Bascule_T_Flip_Flops port map(
           clk => clk_gen,
           Reset => restart,
           T => allumer_led,
           --t_out => led0_b_inter);
           t_out => led0_b_intern);
   
	led0_b <= led0_b_intern;

end arch_counter;



