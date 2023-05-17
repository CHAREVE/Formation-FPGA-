-----------------------------------------------------------------------------------
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Use work .all;

entity led_driver_tb is
end led_driver_tb;

architecture arch_led_driver_tb of led_driver_tb is
   signal clk : std_logic ;
   --signal Resetn :std_logic ;
   signal reset_tb :std_logic :='0';
   signal led0_r_tb : std_logic :='0';
   signal led0_b_tb : std_logic :='0';
   signal led0_g_tb : std_logic :='0';
   signal color_code_tb : std_logic_vector(1 downto 0):="00";
   signal update_tb : std_logic :='0';
    constant clk_period : time :=  10000 ns;--10 ns;

begin
    uut_led_driver : entity Led_driver Port map (
           clk => clk,
           Resetn => reset_tb,
           color_code => color_code_tb,
		   update => update_tb,          
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
	
	test_color_code_process : process -- tester ma commande 
	begin
	color_code_tb <= "11";
	wait for 10 sec;
	color_code_tb <= "01";
	wait for 10 sec;
	color_code_tb <= "10";
	wait for 10 sec;
	color_code_tb <= "00";
	wait for 10 sec;
	end process;
    
    test_update_process : process -- tester mon update led_driver
	begin
	update_tb <= '0';
	wait for 7 sec;
	update_tb <= '1';
	wait for 1 sec;
	update_tb <= '0';
	end process;




end arch_led_driver_tb;
