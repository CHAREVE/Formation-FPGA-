----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.07.2023 13:58:40
-- Design Name: 
-- Module Name: RegistreMngt - Arch_RegistreMngt
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegistreMngt is
Port (clk : in std_logic;
    h_cnt : in integer;
    Pixel_L1 : in STD_LOGIC_VECTOR (23 downto 0);
    Pixel_L2 : in STD_LOGIC_VECTOR (23 downto 0);
    Pixel_L3 : in STD_LOGIC_VECTOR (23 downto 0);
    Pixel_11 : out STD_LOGIC_VECTOR (23 downto 0);
    Pixel_12 : out STD_LOGIC_VECTOR (23 downto 0);
    Pixel_13 : out STD_LOGIC_VECTOR (23 downto 0);
    Pixel_21 : out STD_LOGIC_VECTOR (23 downto 0);
    Pixel_22 : out STD_LOGIC_VECTOR (23 downto 0);
    Pixel_23 : out STD_LOGIC_VECTOR (23 downto 0);
    Pixel_31 : out STD_LOGIC_VECTOR (23 downto 0);
    Pixel_32 : out STD_LOGIC_VECTOR (23 downto 0);
    Pixel_33 : out STD_LOGIC_VECTOR (23 downto 0)
    );
end RegistreMngt;

architecture Arch_RegistreMngt of RegistreMngt is
    
signal Pixel_13_svg, Pixel_23_svg, Pixel_33_svg, P11, P12, P13, P21, P22, P23, P31, P32, P33 : STD_LOGIC_VECTOR (23 downto 0) := (others =>'0');
signal Pixel_L2_retard, Pixel_L3_retard : STD_LOGIC_VECTOR (23 downto 0) := (others =>'0');

begin

process (clk)
begin
    if rising_edge(clk) then
        
        
        if h_cnt = 0 then
            P11 <= P12;
            P21 <= P22;
            P31 <= P32;
            P12 <= P13;
            P22 <= P23;
            P32 <= P33;
            P13 <= (others =>'0');
            P23 <= (others =>'0');
            P33 <= (others =>'0');
            Pixel_13_svg <= Pixel_L1;
            Pixel_23_svg <= Pixel_L2_retard;
            Pixel_33_svg <= Pixel_L3_retard;
        elsif h_cnt = 1 then
            P11 <= (others =>'0');
            P21 <= (others =>'0');
            P31 <= (others =>'0');
            P12 <= Pixel_13_svg;
            P22 <= Pixel_23_svg;
            P32 <= Pixel_33_svg;
            P13 <= Pixel_L1;
            P23 <= Pixel_L2_retard;
            P33 <= Pixel_L3_retard;
        else
            P11 <= P12;
            P12 <= P13;
            P13 <= Pixel_L1;
            P21 <= P22;
            P22 <= P23;
            P23 <= Pixel_L2_retard;
            P31 <= P32;
            P32 <= P33;
            P33 <= Pixel_L3_retard;
        end if;
        
        Pixel_11 <= P11;
        Pixel_21 <= P21;
        Pixel_31 <= P31;
        Pixel_12 <= P12;
        Pixel_22 <= P22;
        Pixel_32 <= P32;
        Pixel_13 <= P13;
        Pixel_23 <= P23;
        Pixel_33 <= P33;
        
        Pixel_L2_retard <= Pixel_L2;
        Pixel_L3_retard <= Pixel_L3;
    end if;
end process;
end Arch_RegistreMngt;
