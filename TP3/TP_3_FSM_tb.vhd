 -----------------------------------------------------------------------------------
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Use work .all;

entity FSM_tb is
end FSM_tb;

architecture arch_FSM_tb of FSM_tb is
   signal clk : std_logic ;
   --signal Resetn :std_logic ;
   signal reset_tb :std_logic :='0';
   signal led0_r_tb : std_logic :='0';
   signal led0_b_tb : std_logic :='0';
   signal led0_g_tb : std_logic :='0';
   --signal end_counter_unit_tb :  std_logic ;
    --signal end_counter : std_logic ;
    constant clk_period : time :=  10 ns;--10000 ns;--

begin
    uut_FSM_unit : entity FSM_unit Port map (
           clk => clk,
           Bouton => reset_tb,
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
	
	bouton_process : process
	begin
	reset_tb <= '0';
	wait for 52000 ms;
	reset_tb <= '1';
	wait for 1000 ms;
	reset_tb <= '0';
	end process;
	
end arch_FSM_tb;