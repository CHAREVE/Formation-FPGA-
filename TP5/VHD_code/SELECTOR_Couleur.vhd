--##--declaration de mon composant : selctor de couleur 
--ce composant est un multiplexeur : composant combinatoir 
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity selector is

     Port ( led0_r, led0_b, led0_g : in STD_LOGIC :='0';
            color_code: out std_logic_vector(1 downto 0)); 
     end selector;

--Description comportementale
------------------------------------------------
architecture arch_selector of selector is
    constant color_code_eteinte :std_logic_vector := "00";
    constant color_code_rouge :std_logic_vector := "01";
    constant color_code_bleu :std_logic_vector := "11";
    constant color_code_vert :std_logic_vector := "10";
    
begin 
	     ------differentes tentatives de selection  de ma couleur 
	    -------------- tentation 1-------------------------------------------
--   color_code <= color_code_rouge when  led0_r = '1' and  led0_b = '0'and  led0_g = '0'  else
--             color_code_bleu when led0_b = '1'and led0_r = '0'and  led0_g = '0'else
--             color_code_vert when led0_g = '1' and led0_r = '0'and  led0_b = '0' else
--             --color_code_vert when led0_g = '1' and  led0_r = '1'and  led0_b = '1'else
--             color_code_eteinte;    -- valeur par defaut 
 
  -------------- tentative 2 -------------------------------------------------------
--          color_code <= 
--               color_code_rouge when falling_edge (led0_g) else
--               color_code_bleu when  falling_edge (led0_r) else
--               color_code_vert when  falling_edge (led0_b);
               
           -------------- tentative  3 -------------------------------------------------------    
                --color_code_rouge when led0_g = '1' else
               --color_code_bleu when  led0_r = '1' else
               --color_code_vert when  led0_b = '1';
--               color_code_vert when  falling_edge (led0_b) else
--               color_code_eteinte;    -- valeur par defaut 

         -------------- tentative  4 -------------------------------------------------------    
           --    process (led0_r, led0_b, led0_g)
--       begin
        
--        if falling_edge (led0_r) then color_code <= color_code_bleu;        
--           end if;
--        if falling_edge (led0_b) then color_code <= color_code_vert;
--           end if;
--        if falling_edge (led0_g) then color_code <= color_code_rouge;
--           end if;
--     end process ;    
                
    -------------- tentative  5 -------------------------------------------------------            
     process (led0_r, led0_b, led0_g)
       begin
        if led0_g ='1' then color_code <= color_code_rouge;
           elsif led0_r = '1' then color_code <= color_code_bleu; 
           elsif led0_b ='1' then color_code <= color_code_vert;
        end if; 
        end process ; 
end arch_selector;