----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.06.2023 20:39:41
-- Design Name: 
-- Module Name: top_tb - arch_top_tb
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
Use work.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_tb is
--  Port ( );
end top_tb;

architecture arch_top_tb of top_tb is

            signal CLK_I_tb: std_logic ;
            signal RST_tb : std_logic :='0';
            signal VGA_HS_O_tb : std_logic :='0';
            signal VGA_VS_O_tb : std_logic :='0' ;
            signal VGA_R_tb : STD_LOGIC_VECTOR (3 downto 0);
            signal VGA_B_tb : STD_LOGIC_VECTOR (3 downto 0);
            signal VGA_G_tb : STD_LOGIC_VECTOR (3 downto 0);
            
            constant clk_period : time :=  10 ns;--10 ns;
begin

uut_top :   entity top port map (
           CLK_I  => CLK_I_tb,
           RST => RST_tb,
           VGA_HS_O => VGA_HS_O_tb,
           VGA_VS_O => VGA_VS_O_tb,
           VGA_R => VGA_R_tb,
           VGA_B => VGA_B_tb,
           VGA_G => VGA_G_tb);


---Clock process definitions
	clk_process : process
	begin
	clk_I_tb <= '0';
	wait for clk_period/2;
	 CLK_I_tb <= '1';
	wait for clk_period/2;
	end process; 
	
	RST_process : process
	begin
	RST_tb <= '1';
	wait for 5000 ns;
	RST_tb <= '0';
	wait;
	end process; 
end arch_top_tb;
