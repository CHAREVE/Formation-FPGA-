----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.05.2023 10:33:42
-- Design Name: 
-- Module Name: counter_tb - arch_counter_tb
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter_tb is
end counter_tb;

architecture arch_counter_tb of counter_tb is
--déclaration des signaux
    signal clk : std_logic := '0';
    signal bouton : std_logic := '0';
    signal led : std_logic := '0'; 
    signal clk_gen : std_logic := '0';
    signal btn0 : std_logic := '0';
    signal led0_b : std_logic := '0'; 
    
    constant clk_period : time :=  10 ns; --10000 ns;--

begin
    uut_counter : entity counter Port map (
        clk_gen => clk, 
        btn0 => bouton, 
        led0_b => led);
	
	---Clock process definitions
	clk_process : process
	begin
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
	end process;
	
end arch_counter_tb;
