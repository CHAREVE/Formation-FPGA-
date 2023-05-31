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
  