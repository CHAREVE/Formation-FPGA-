library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use work.all;

entity Pattern_gen is
  Port (pxl_clk : in std_logic;
        h_cntr_reg : in std_logic_vector(11 downto 0);
        v_cntr_reg : in std_logic_vector(11 downto 0);
        Pixel_L3 : out std_logic_vector(11 downto 0));
end Pattern_gen;

architecture Arch_Pattern_gen of Pattern_gen is

--***1920x1080@60Hz***-- Requires 148.5 MHz pxl_clk
constant FRAME_WIDTH : natural := 1920;
constant FRAME_HEIGHT : natural := 1080;

constant H_FP : natural := 88; --H front porch width (pixels)
constant H_PW : natural := 44; --H sync pulse width (pixels)
constant H_MAX : natural := 2200; --H total period (pixels)

constant V_FP : natural := 4; --V front porch width (lines)
constant V_PW : natural := 5; --V sync pulse width (lines)
constant V_MAX : natural := 1125; --V total period (lines)

constant H_POL : std_logic := '1';
constant V_POL : std_logic := '1';

signal active : std_logic;
signal vga_red : std_logic_vector(3 downto 0);
signal vga_green : std_logic_vector(3 downto 0);
signal vga_blue : std_logic_vector(3 downto 0);

begin

  ----------------------------------------------------------------
  ------- PATTERN GENERATOR         
  ------- Damier de taille h-cntr = 2^X et v-cnt = 2^Y 
  ------- Ici X = 8 et Y = 8 (adapté pour resolution 1920 * 1080
  ----------------------------------------------------------------

active <= '1' when ((h_cntr_reg < FRAME_WIDTH) and (v_cntr_reg < FRAME_HEIGHT))else '0';

--blanc et noir, taille 2^8 / 2^8
vga_red <= "0000" when (active = '1' and h_cntr_reg(9) = v_cntr_reg(9)) else "1111";
vga_blue <= "0000" when (active = '1' and h_cntr_reg(9) = v_cntr_reg(9)) else "1111";
vga_green <= "0000" when (active = '1' and h_cntr_reg(9) = v_cntr_reg(9)) else "1111";

process (pxl_clk)
begin
if rising_edge(pxl_clk) then
    -- Génération du pixel R G B aux coordonnées (h_cntr_reg; v_cntr_reg)
    Pixel_L3 <= vga_red & vga_green & vga_blue;
end if;
end process;

end Arch_Pattern_gen;
