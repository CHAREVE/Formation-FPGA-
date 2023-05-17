
---------------------------------------------------------------------------
----------------------------partie Actions appliquées de la machine à etat
--------------------------------------------------------------------------- 
-- on va rajouter un autre élément à notre architecture (du tp precedent) 
---pour maintenir la led allumée 2 sec et eteinte 2 sec en mémorisant la dernière
--- entrée, et ce pendant N valeur de comptage de front mentant 
     --**********************************************************
--##--declaration composant : Bascule_T_flip_flop
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
          
end Bascule_T_flip_flops;

--Description comportementale
------------------------------------------------
architecture arch_Bascule_T_Flip_Flops of Bascule_T_Flip_Flops is
  
begin 
	      
   process(Reset,clk)
        begin
        if reset='1' then t_out <= '0';
                elsif rising_edge(clk) then
            if T ='1' then 
                if t_out ='1' then
                     t_out <= '0';
                          else 
                    t_out <='1';
                   
                end if;
	       end if;
	   end if;
  end process;
  end arch_Bascule_T_flip_flops;
  
--------------------------------------TP4_FSM---------------------------------
--------------------------------------------------------------------------------------------------------
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE work.ALL;
entity TP4_FSM is
    Port ( clk : in STD_LOGIC;
           Bouton_0 : in STD_LOGIC := '0';
           Bouton_1 : in STD_LOGIC := '0';
           led0_r, led0_b, led0_g : out STD_LOGIC);
         
end TP4_FSM;

architecture arch_TP4_FSM of TP4_FSM is

    -- Definition des signaux
    signal end_counter_1 : STD_LOGIC := '0';
    --signal end_counter_2 : STD_LOGIC := '0';
    type state is (etat_initial, led_rouge, led_bleu,led_vert,led_eteinte);
    signal etat_cr, etat_sv : state ; --etat dans lequel on se trouve actuellement & etat dans lequel on passera au prochain coup d'horloge
    signal etat_led : std_logic_vector(2 downto 0);
    signal allumer_led : std_logic_vector(2 downto 0);
    constant v_led_rouge :std_logic_vector := "001";
   -- constant v_led_bleu :std_logic_vector := "010";
    constant v_led_vert :std_logic_vector := "100";
    constant v_led_blanc :std_logic_vector := "111";
    constant v_led_eteinte :std_logic_vector := "000";
    signal t_out : std_logic;
   

begin

	inst_Counter_unit_1 : entity Counter_unit_1 port map ( 
	       clk => clk,
           Reset => Bouton_1,
           end_counter_1 => end_counter_1); 
                      
    inst_Bascule_T_Flip_Flops : entity Bascule_T_Flip_Flops port map(
          clk => clk,
          reset => bouton_1,
          T => end_counter_1,
		  t_out => t_out);
	
-- Initialisation de ma machine à etat-- 	  
process( clk , Bouton_1)
begin -- définition de l'initialisation de ma machine à etat-- remise à zero
      if bouton_1='1' then etat_cr <= etat_initial;
      elsif rising_edge(clk) then etat_cr <= etat_sv; 
      end if;     
end process; 

-- Définition de ma machine à etat-- 
process(etat_cr, end_counter_1, bouton_0, allumer_led)
begin
--initialisation des etats:
etat_sv <= etat_cr; 
        case etat_cr is
            when etat_initial =>
                if end_counter_1 = '1' then
					etat_sv <= led_rouge;
				end if; 
		    when led_rouge =>
                 if bouton_0 = '1' then
					etat_sv <= led_vert;
				end if;
			when led_vert =>
                if bouton_0 = '0' then
					etat_sv <= led_rouge;
				elsif falling_edge(allumer_led(2)) then 
				    etat_sv <= led_eteinte;
				end if;
			when led_eteinte =>
				if bouton_0 = '0' then	
				    etat_sv <= led_rouge;
				end if;
		    when others =>
		      etat_sv <= led_rouge;
			end case;
end process;

process(etat_cr)--state_switch
begin
case etat_cr is
	when etat_initial =>
		etat_led <= v_led_blanc;-- blanc => rouge + bleu + vert
	when led_rouge =>
		etat_led <= v_led_rouge; -- rouge
	--when led_bleu =>
		--etat_led <= v_led_bleu; -- bleu
	when led_vert =>
		etat_led <= v_led_vert; -- vert
	when others =>
	   etat_led <= v_led_eteinte; -- rouge
	end case;
end process;

process (clk,etat_led)
begin
if rising_edge(clk) then
    allumer_led <= etat_led and (t_out, t_out, t_out);		
    led0_r <= allumer_led(0);
    led0_b <= allumer_led(1);
    led0_g <= allumer_led(2);
end if;
end process;

end arch_TP4_FSM;


