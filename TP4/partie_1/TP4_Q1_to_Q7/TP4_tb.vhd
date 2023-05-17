-----------------------------------------------------------------------------------
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Use work .all;

entity TP4_tb is
end TP4_tb;

architecture arch_TP4_tb of TP4_tb is
   signal clk : std_logic ;
   --signal Resetn :std_logic ;
   signal reset_tb :std_logic :='0';
   signal led0_r_tb : std_logic :='0';
   signal led0_b_tb : std_logic :='0';
   signal led0_g_tb : std_logic :='0';
   signal test_tb : std_logic :='0';
    --signal end_counter : std_logic ;
    constant clk_period : time :=  10000 ns;--10 ns;

begin
    uut_TP4_FSM : entity TP4_FSM Port map (
           clk => clk,
           Bouton_1 => reset_tb,
           Bouton_0 => test_tb,
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
	
	test_tb_process : process -- tester la led verte
	begin
	test_tb <= '0';
	wait for 5.5 sec;
	test_tb <= '1';
	wait for 15.25 sec;
	test_tb <= '0';
	end process;
	
end arch_TP4_tb;

