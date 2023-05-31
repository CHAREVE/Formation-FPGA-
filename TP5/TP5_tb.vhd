
-----------------------------------------------------------------------------------
-- Declaration de ma bibliothèque
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Use work.all;

entity TP5_tb is
end TP5_tb;

architecture arch_TP5_tb of TP5_tb is
--   signal clkA : std_logic ;
--   signal clkB : std_logic ;
--   --signal Resetn :std_logic ;
  signal Reset_tb :std_logic :='0';
   signal led0_r_tb : std_logic :='0';
   signal led0_b_tb : std_logic :='0';
   signal led0_g_tb : std_logic :='0';
   signal led1_r_tb : std_logic :='0';
   signal led1_b_tb : std_logic :='0';
   signal led1_g_tb : std_logic :='0';
   signal end_cycle_tb : std_logic :='0';
   signal color_code_tb : std_logic_vector(1 downto 0) := "00";
   signal update_tb : std_logic :='0';
   signal clk_100Mhz_tb : std_logic := '0';
   signal clk_250Mz_tb : std_logic :='0';
   signal clk_50Mz_tb : std_logic :='0';
   constant clkA_period : time :=  4 ms;--4 ns;
   constant clkB_period : time :=  20 ms;--20 ns;
   constant clk_100Mhz_period : time :=  10000 ns;--10 ns;
--   component Master_TP5  
--     port (  clk : in STD_LOGIC ; --:='100Mz' ;
--        Reset_Master : in STD_LOGIC;
--        led0_r : out std_logic ;
--        led0_b : out std_logic ;
--        led0_g : out std_logic ;
--        led1_r : out std_logic ;
--        led1_b : out std_logic ;
--        led1_g : out std_logic );
--     end component ;
begin
--    uut_Led_driver_led0 : entity Led_driver_led0 Port map (
--            clk => clk,
--            Resetn => Reset_tb,
--            color_code => color_code_tb, 
--		    update => update_tb,  
--            end_cycle => end_cycle_tb, 
--            led0_r => led0_r_tb, 
--            led0_b => led0_b_tb, 
--            led0_g => led0_g_tb);
                       
--    uut_selector : entity selector Port map (
--            led0_r => led0_r_tb, 
--            led0_b => led0_b_tb, 
--            led0_g => led0_g_tb,
--            color_code => color_code_tb);   
                          
--    uut_Counter_unit_10_tp5 : entity Counter_unit_10_tp5 Port map (
--            clk => clk,
--            Reset => Reset_tb,
--            Enable_2 => end_cycle_tb,
--            end_counter_2 => update_tb);
    
     uut_Master_TP5 : entity Master_TP5 Port map (
           clk => clk_100Mhz_tb,
--            clkA => clkA,
--            clkB => clkB,
            Reset_Master => Reset_tb,
            led0_r => led0_r_tb, 
            led0_b => led0_b_tb, 
            led0_g => led0_g_tb,
            led1_r => led1_r_tb, 
            led1_b => led1_b_tb, 
            led1_g => led1_g_tb);  
      
--      ---Clock process definitions
--	clkA_process : process
--	begin
--	clkA <= '0';
--	wait for clkA_period/2;
--	clkA <= '1';
--	wait for clkA_period/2;
--	end process; 
--	clkB_process : process
--	begin
--	clkB <= '0';
--	wait for clkB_period/2;
--	clkB <= '1';
--	wait for clkB_period/2;
--	end process; 
--    clk_100Mz_process : process
--	begin
--	clk_100Mz_tb<= '0';
--	wait for clk_100Mz_period/2;
----	clk_100Mz_tb <= '1';
----	wait for clk_100Mz_period/2;
--	end process; 
--	-- autre façon de l'ecrire cette simulation sur la clk_100Mhz ---
	clk_100Mz_process : process
	begin
	clk_100Mhz_tb <= not clk_100Mhz_tb;
	wait for clk_100Mhz_period/4;
	end process; 
	
    tester_Reset_process : process  -- tester ma reset
	begin
	Reset_tb <= '1';
	wait for 10 ns;
	Reset_tb <= '0';
	wait; --for 2 sec;
	end process;
  
 
end arch_TP5_tb;
