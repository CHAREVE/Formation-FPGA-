-----------------------------------------------------------------------------------
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Use work .all;

entity Master_tb is
end Master_tb;

architecture arch_Master_tb of Master_tb is
   signal clk : std_logic ;
   --signal Resetn :std_logic ;
   signal Bouton_1_tb :std_logic :='0';
   signal Bouton_0_tb :std_logic :='0';
   signal led0_r_tb : std_logic :='0';
   signal led0_b_tb : std_logic :='0';
   signal led0_g_tb : std_logic :='0';
   constant clk_period : time :=  10000 ns;--10 ns;

begin
    uut_Master : entity Master Port map (
           clk => clk,
           Bouton_1 => Bouton_1_tb,
		   Bouton_0 => Bouton_0_tb,        
           led0_r => led0_r_tb,
           led0_b => led0_b_tb, 
           led0_g => led0_g_tb);
       
	---Clock process definitions
	clk_process : process
	begin
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
	end process; 
	
	tester_Bouton_1_process : process -- tester Bouton_1_tb
	begin
	Bouton_1_tb <= '0';
	wait for 10 sec;
	Bouton_1_tb <= '1';
	wait for 1 sec;
	Bouton_1_tb <= '0';
	wait for 10 sec;
	Bouton_1_tb <= '1';
	wait for 10 sec;
	end process;
tester_Bouton_0_process : process -- tester Bouton_0_tb
	begin
	Bouton_0_tb <= '0';
	wait for 10 sec;
	Bouton_0_tb <= '1';
	wait for 5 sec;
	Bouton_0_tb <= '0';
	wait for 10 sec;
	Bouton_0_tb <= '1';
	wait for 10 sec;
	end process;

end arch_Master_tb;
