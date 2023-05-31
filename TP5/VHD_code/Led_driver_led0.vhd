
--------------------------------------tp5 Question1 --------------------------------
--------------------------------------------------------------------------------------------------------
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE work.ALL;
entity Led_driver_led0 is
    Port ( clk : in STD_LOGIC ;
           Resetn : in STD_LOGIC;
           color_code : in STD_LOGIC_vector (1 downto 0);
		   update : in STD_LOGIC  ;
		   end_cycle : out STD_LOGIC;
           led0_r, led0_b, led0_g : out STD_LOGIC :='0');
     end Led_driver_led0 ;

architecture arch_Led_driver_led0 of Led_driver_led0 is

    -- Definition des signaux
    signal end_counter_1 : STD_LOGIC := '0';
    --signal end_counter_2 : STD_LOGIC := '0';
    type state is (etat_initial, led_rouge, led_bleu,led_vert,led_eteinte);
    signal etat_cr, etat_sv : state := etat_initial; --etat-cr dans lequel on se trouve actuellement & etat-sv dans lequel on passera au prochain coup d'horloge
                                                     ---ici j'initialise mon etat
    signal etat_led : std_logic_vector(2 downto 0) := "111";
    --signal allumer_led : std_logic_vector(2 downto 0):="000";
    constant v_led_rouge :std_logic_vector := "001";
    constant v_led_bleu :std_logic_vector := "010";
    constant v_led_vert :std_logic_vector := "100";
    constant v_led_blanc :std_logic_vector := "111";
    constant v_led_eteinte :std_logic_vector := "000";
    constant color_code_eteinte :std_logic_vector := "00";
    constant color_code_rouge :std_logic_vector := "01";
    constant color_code_bleu :std_logic_vector := "11";
    constant color_code_vert :std_logic_vector := "10";
    signal t_out : std_logic := '0';
    signal Q : std_logic := '0'; --etat intermidiare de mémorisation
    signal out_FIFO : STD_LOGIC_vector (1 downto 0);

  
begin

	inst_Counter_unit : entity Counter_unit port map ( 
	       clk => clk,
           Reset => Resetn,
           --Enable_2 => '1',
           end_counter_1 => end_counter_1); 
           
                      
    inst_Bascule_T_Flip_Flops : entity Bascule_T_Flip_Flops port map(
          clk => clk,
          reset => Resetn,
          T => end_counter_1,
		  t_out => t_out);
	
-- Initialisation de ma machine à etat-- 	  
process( clk , Resetn,etat_sv)
begin -- définition de l'initialisation de ma machine à etat-- remise à zero
      if Resetn='1' then etat_cr <= etat_initial;
      elsif rising_edge(clk) then etat_cr <= etat_sv; 
      end if;     
end process; 

-- Définition de ma machine à etat-- 
process(color_code,update,etat_cr)
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

process (etat_led,t_out)
begin
--if rising_edge(clk) then
--    allumer_led <= etat_led and (t_out, t_out, t_out);		
--    led0_r <= allumer_led(0);
--    led0_b <= allumer_led(1);
--    led0_g <= allumer_led(2); c'est un composant combinatoire, pas besoin de lui faire dependre de la clk
--                          --- auusi çà nous fait gagnier un cycle d'horloge
    led0_r <= etat_led(0) and t_out;
    led0_b <= etat_led(1) and t_out;
    led0_g <= etat_led(2) and t_out;
--end if;
end process;

---------------  modifiez le module LED_driver en ajoutant une sortie end_cycle. Cette sortie
----------------vaudra 1 à la fin d'un cycle allumé/éteint de la LED RGB.

process (Resetn, clk) 
begin
-- demande de rajouter la Resetn  
---qui est prioritaire à la rising clk
--pour que le end cycle soit bien décrit il faut l'initialiser
    if Resetn = '1' then  
        end_cycle <= '0'; 
        Q <= '0';
    elsif rising_edge(clk) then
        if t_out = '1' then
            if Q = '0' then
                end_cycle <= '1';
            else 
                end_cycle <= '0';
            end if;
        else 
            end_cycle <= '0';
        end if;
        Q <= t_out;
    end if;
end process;

end arch_Led_driver_led0 ;

