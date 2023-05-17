
----------------------------question 8 TP-4 -----------------------------------------------
--création de module de pilotage de LED RGB 
--Ce dernier doit permettre de faire clignoter une LED RGB connectée
-- en sortie d’une couleur définie par un code couleur donné en entrée.
 ---Le changement de couleur de la LED RGB n’a lieu que si un signal update est reçu.
---******************* 
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
  
--------------------------------------TP4_LED_DRVER question 8--------------------------------
--------------------------------------------------------------------------------------------------------
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE work.ALL;
entity Led_driver is
    Port ( clk : in STD_LOGIC ;
           Resetn : in STD_LOGIC :='0';
           color_code : in STD_LOGIC_vector (1 downto 0);
		   update : in STD_LOGIC ;
           led0_r, led0_b, led0_g : out STD_LOGIC :='0');
     end Led_driver ;

architecture arch_Led_driver of Led_driver is

    -- Definition des signaux
    signal end_counter_1 : STD_LOGIC := '0';
    --signal end_counter_2 : STD_LOGIC := '0';
    type state is (etat_initial, led_rouge, led_bleu,led_vert,led_eteinte);
    signal etat_cr, etat_sv : state ; --etat dans lequel on se trouve actuellement & etat dans lequel on passera au prochain coup d'horloge
    
    signal etat_led : std_logic_vector(2 downto 0);
    signal allumer_led : std_logic_vector(2 downto 0):="000";
    constant v_led_rouge :std_logic_vector := "001";
    constant v_led_bleu :std_logic_vector := "010";
    constant v_led_vert :std_logic_vector := "100";
    constant v_led_blanc :std_logic_vector := "111";
    constant v_led_eteinte :std_logic_vector := "000";
    constant color_code_eteinte :std_logic_vector := "00";
    constant color_code_rouge :std_logic_vector := "01";
    constant color_code_bleu :std_logic_vector := "11";
    constant color_code_vert :std_logic_vector := "10";
    signal t_out : std_logic;
   

begin

	inst_Counter_unit : entity Counter_unit port map ( 
	       clk => clk,
           Reset => Resetn,
           end_counter_1 => end_counter_1); 
                      
    inst_Bascule_T_Flip_Flops : entity Bascule_T_Flip_Flops port map(
          clk => clk,
          reset => Resetn,
          T => end_counter_1,
		  t_out => t_out);
	
-- Initialisation de ma machine à etat-- 	  
process( clk , Resetn)
begin -- définition de l'initialisation de ma machine à etat-- remise à zero
      if Resetn='1' then etat_cr <= etat_initial;
      elsif rising_edge(clk) then etat_cr <= etat_sv; 
      end if;     
end process; 

-- Définition de ma machine à etat-- 
process(color_code, update)
begin
--initialisation des etats:
if update = '0' then
    etat_sv <= etat_cr; 
elsif color_code = color_code_eteinte then --& update = '1'
    etat_sv <= led_eteinte;
elsif color_code = color_code_rouge then --& update = '1'
    etat_sv <= led_rouge;
elsif color_code = color_code_bleu then --& update = '1'
    etat_sv <= led_bleu; 
elsif color_code = color_code_vert then --& update = '1'
    etat_sv <= led_vert; 
end if;
end process;


-- Définition des actions dans un état-- 
process(etat_cr)--state_switch
begin
case etat_cr is
	when etat_initial =>
		etat_led <= v_led_blanc;-- blanc => rouge + bleu + vert
	when led_rouge =>
		etat_led <= v_led_rouge; -- rouge
	when led_bleu =>
		etat_led <= v_led_bleu; -- bleu
	when led_vert =>
		etat_led <= v_led_vert; -- vert
	when led_eteinte =>
	   etat_led <= v_led_eteinte; -- eteinte
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

end arch_Led_driver ;


