--*****************************************************TP4 QUESTION9 **********
--##-- besoin de créer un nouveau composant combinatoir btn1 : un Selector_BTN1 ##
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity Selector_BTN1 is
    Port (Bouton_1 : in STD_LOGIC;
          color_code : out STD_LOGIC_vector (1 downto 0));
end Selector_BTN1;

architecture arch_Selector_BTN1 of Selector_BTN1 is

    constant color_code_bleu :std_logic_vector := "11";
    constant color_code_vert :std_logic_vector := "10";
begin
    color_code <= color_code_vert when Bouton_1 ='1' else color_code_bleu; 
end arch_Selector_BTN1;
---*************************************************************************
--##-- besoin de créer un deuxième composant synchrone btn0 : un registre_BTN0 ##
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity registre_BTN0 is
    Port (clk : in STD_LOGIC;
          Resetn: in STD_LOGIC;
          Bouton_0 : in STD_LOGIC;-- := '1';
          update : out STD_LOGIC);
end registre_BTN0;
architecture arch_registre_BTN0 of registre_BTN0 is
signal btn0_prev : STD_LOGIC := '0';
--signal Resetn: STD_LOGIC := '0';

--******************************************
-- question 9_tp4 -- si front montant de clk alors : 
    -- - si front montant (bouton_0) = 1 alors update vaut 1
    -- - sinon update vaut 0
------------**************************
begin 
 
process (Resetn, clk) 
begin
-- demande de rajouter la Resetn  
---qui est prioritaire à la rising clk
--pour que le registre soit bien décrit il faut l'initialiser
    if Resetn = '1' then  
        update <= '0'; 
        btn0_prev <= '0';
    elsif rising_edge(clk) then
        if Bouton_0 = '1' then
            if btn0_prev = '0' then
                update <= '1';
            else 
                update <= '0';
            end if;
        else 
            update <= '0';
        end if;
        btn0_prev <= Bouton_0;
    end if;
end process;

end arch_registre_BTN0;

---*************************************************************************
---------------JE déclare mon MASTER GLOBAL qui englobe : LED_DRIVER & Selector_BTN1 & Registre_BTN0
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE work.ALL;
entity Master is
    Port ( clk : in STD_LOGIC ;
           Bouton_1 : in STD_LOGIC :='0';
		   Bouton_0 : in STD_LOGIC :='0' ;
           led0_r, led0_b, led0_g : out STD_LOGIC :='0');
     end Master ;

architecture arch_Master of Master is

    signal color_code : STD_LOGIC_vector (1 downto 0);
    signal update : STD_LOGIC;-- :='0' ;
    
begin
---instantiation de MASTER avec  LED_DRIVER & Tristate_BTN1 & Registre_BTN0
    inst_Selector_BTN1 : entity Selector_BTN1 port map ( 
        Bouton_1 => Bouton_1,
        color_code => color_code);
      
    inst_registre_BTN0 : entity registre_BTN0 port map(
          clk => clk,
          Resetn => '0',
          Bouton_0 => Bouton_0,
          update => update);
    
    
    inst_Led_driver : entity Led_driver port map(
        clk => clk,
        Resetn => '0',
        color_code => color_code,
		update => update,
        led0_r => led0_r, 
        led0_b => led0_b, 
        led0_g => led0_g);

end arch_Master;
