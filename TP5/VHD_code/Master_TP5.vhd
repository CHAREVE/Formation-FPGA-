--------------------------------------tp5  --------------------------------
----------------------------------Master_TP5 rassemble l'architecture des led0 et led1---------------------------------------------------------------
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE work.ALL;
entity Master_TP5 is
    Port ( clk : in STD_LOGIC ; --:='100Mz' ;
--        clkA : in STD_LOGIC :='0' ; --:='250Mz' ;
--        clkB : in STD_LOGIC :='0' ; --:='50Mz' ;
        Reset_Master : in STD_LOGIC;
        led0_r:  out std_logic  ;
        led0_b : out std_logic ;
        led0_g : out std_logic ;
        led1_r : out std_logic ;
        led1_b : out std_logic ;
        led1_g : out std_logic );
     end Master_TP5 ;

architecture arch_Master_TP5 of Master_TP5 is
----declaration des signaux internes du Master_TP5
signal clkA : STD_LOGIC ;
signal clkB : STD_LOGIC ;
signal color_code: STD_LOGIC_vector (1 downto 0);
signal update:  STD_LOGIC ;
signal end_cycle : STD_LOGIC;
signal end_cycle_led1 : STD_LOGIC := '1';
signal v_led0_r :STD_LOGIC ;
signal v_led0_g :STD_LOGIC ;
signal v_led0_b :STD_LOGIC ;
signal v_led1_r :STD_LOGIC ;
signal v_led1_g :STD_LOGIC ;
signal v_led1_b :STD_LOGIC ;
--signal Reset_Master : STD_LOGIC :='0';

----declaration des signaux internes pour des besoins de sync_clkA_to_clkB (rapide à lente) 
signal count : integer range 0 to 6 := 0;
signal update_streched:  STD_LOGIC ;
signal update_stable:  STD_LOGIC :='0' ;
signal update_metastable:  STD_LOGIC :='0';
signal color_code_streched : STD_LOGIC_vector (1 downto 0);

component clk_wiz_0  is 
port (  clk_100Mhz  :in STD_LOGIC;
        reset : in STD_LOGIC ;
        locked : out STD_LOGIC ;
        clk_250Mhz: out STD_LOGIC ;
        clk_50Mhz : out STD_LOGIC );
end component;
           
begin
inst_Led_driver_led0 : entity Led_driver_led0 port map ( 
	       clk => clkA,
           Resetn => Reset_Master, 
           color_code => color_code,
		   update => update,
		   --update => update_stable,
		   end_cycle => end_cycle ,
           led0_r => v_led0_r,
           led0_b => v_led0_b,
           led0_g => v_led0_g); 
           
inst_Led_driver_led1 : entity Led_driver_led1 port map ( 
	       clk => clkB,
           Resetn => Reset_Master, 
           --color_code => color_code,
           color_code => color_code_streched,
		   update => update_streched,
		   --update => update_stable,
		   end_cycle_led1 => end_cycle_led1,
           led1_r => led1_r,
           led1_b => led1_b,
           led1_g => led1_g); 
 inst_Counter_unit_10_tp5 : entity Counter_unit_10_tp5 port map ( 
	       clk => clkA,
           Reset => Reset_Master,
           Enable_2 => end_cycle,
           end_counter_2 => update);
 inst_selector : entity selector port map ( 
	       led0_r => v_led0_r,--led0_r, 
           led0_b => v_led0_b, --led0_b,
           led0_g => v_led0_g, ---led0_g,
            color_code => color_code);

   inst_clk_wiz_0  :  clk_wiz_0  port map ( 
        clk_100Mhz => clk,
        reset =>  Reset_Master,
        clk_250Mhz => clkA,
        clk_50Mhz => clkB);           

-- pour des besoins de sync_clkA_to_clkB (rapide à lente) : 
-- je crée une impulsion 'Update'plus longue qui dure x cycles d'horloges au lieu d'1 seul cycle 
--cette nouvelle pulse on va la nommer "update_streched" 
 process (clkA,Reset_master ) 
   begin --ici j'ai besoin d'un compteur "Count" qui compte jusqu'au 4
   if rising_edge(clkA) then
        if Reset_master ='1' then count <= 0;  
            elsif update = '1' then count <= 6;
            elsif count > 0 then count <= count - 1; --else count <= 4; 
        end if; 
    end if;
    --end if;
 end process ;
 
 -- je crée une impulsion longue qui s'appelle "update_streched":
update_streched <='1' when count >0 else '0'; 

--maintenant je vais enlever la métastabilité de la frequence lente CLKB = 50Mz: 
-- process (clkB,Reset_master ) 
--   begin
--    if rising_edge(clkB) then
--      if Reset_master ='1' then
--        update_metastable <= '0';
--        update_stable <= '0';
--        else 
--        update_metastable <= update_streched ;
--        update_stable <= update_metastable; 
--      end if;
--     end if;
-- end process ;
process (update_streched) 
begin
if update_streched = '0' then color_code_streched <= color_code;
end if;
end process ;
        led0_r <= v_led0_r ;
        led0_b <= v_led0_b;
        led0_g <= v_led0_g;
--        led1_r <= v_led1_r;
--        led1_b <= v_led1_b;
--        led1_g <=  v_led1_g;
        
end arch_Master_TP5;
