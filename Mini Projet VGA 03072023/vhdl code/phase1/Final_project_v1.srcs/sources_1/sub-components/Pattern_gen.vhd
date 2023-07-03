library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use work.all;

entity Pattern_gen is
  Port (h_cntr_reg : in std_logic_vector(11 downto 0);
        v_cntr_reg : in std_logic_vector(11 downto 0);
        vga_red : out std_logic_vector(3 downto 0);
        vga_green : out std_logic_vector(3 downto 0);
        vga_blue : out std_logic_vector(3 downto 0));
end Pattern_gen;

architecture Arch_Pattern_gen of Pattern_gen is
--Sync Generation constants

--***640x480@60Hz***--  Requires 25 MHz clock
constant FRAME_WIDTH : natural := 640;
constant FRAME_HEIGHT : natural := 480;

constant H_FP : natural := 16; --H front porch width (pixels)
constant H_PW : natural := 96; --H sync pulse width (pixels)
constant H_MAX : natural := 800; --H total period (pixels)

constant V_FP : natural := 10; --V front porch width (lines)
constant V_PW : natural := 2; --V sync pulse width (lines)
constant V_MAX : natural := 525; --V total period (lines)

constant H_POL : std_logic := '0';
constant V_POL : std_logic := '0';

----***1920x1080@60Hz***-- Requires 148.5 MHz pxl_clk
--constant FRAME_WIDTH : natural := 1920;
--constant FRAME_HEIGHT : natural := 1080;

--constant H_FP : natural := 88; --H front porch width (pixels)
--constant H_PW : natural := 44; --H sync pulse width (pixels)
--constant H_MAX : natural := 2200; --H total period (pixels)

--constant V_FP : natural := 4; --V front porch width (lines)
--constant V_PW : natural := 5; --V sync pulse width (lines)
--constant V_MAX : natural := 1125; --V total period (lines)

--constant H_POL : std_logic := '1';
--constant V_POL : std_logic := '1';

signal active : std_logic := '0';

begin
 --- Generateur de pattern ---
  ----------------------------------------------------
  -------         TEST PATTERN LOGIC           -------
 active <= '1' when ((h_cntr_reg < FRAME_WIDTH) and (v_cntr_reg < FRAME_HEIGHT))else '0';
--Noir et blanc (taille 2^8 / 2^8)
vga_red <= "1111" when (active = '1' and h_cntr_reg(8) = v_cntr_reg(8)) else "0000";
vga_blue <= "1111" when (active = '1' and h_cntr_reg(8) = v_cntr_reg(8)) else "0000";
vga_green <= "1111" when (active = '1' and h_cntr_reg(8) = v_cntr_reg(8)) else "0000";

-- rouge et vert (taille 2^8 / 2^8)
--vga_red <= "1111" when (active = '1' and h_cntr_reg(8) = v_cntr_reg(8)) else "0000";
--vga_blue <= "0000";
--vga_green <= "0000" when (active = '1' and h_cntr_reg(8) = v_cntr_reg(8)) else "1111";


 end Arch_Pattern_gen;
