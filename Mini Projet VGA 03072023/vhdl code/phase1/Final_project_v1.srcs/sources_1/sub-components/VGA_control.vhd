library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use work.all;

entity VGA_control is
Port (pxl_clk : in std_logic;
     RST : in std_logic;
     h_cntr_reg : out std_logic_vector(11 downto 0);
     v_cntr_reg : out std_logic_vector(11 downto 0);
     h_sync_reg : out std_logic;
     v_sync_reg : out std_logic);
end VGA_control;

architecture Arch_VGA_control of VGA_control is
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

signal  h_cntr : std_logic_vector(11 downto 0):= (others =>'0');
signal  v_cntr : std_logic_vector(11 downto 0):= (others =>'0');
--signal active : std_logic:= '0';
begin
-- VGA controller --
 ------------------------------------------------------
 -------         SYNC GENERATION                 ------
 ------------------------------------------------------
 
  process (pxl_clk)
  begin
    if (rising_edge(pxl_clk)) then
      if (h_cntr = (H_MAX - 1)) then
        h_cntr <= (others =>'0');
      else
        h_cntr <= h_cntr + 1;
      end if;
    end if;
  end process;
  
  process (pxl_clk)
  begin
    if (rising_edge(pxl_clk)) then
      if ((h_cntr = (H_MAX - 1)) and (v_cntr = (V_MAX - 1))) then
        v_cntr <= (others =>'0');
      elsif (h_cntr = (H_MAX - 1)) then
        v_cntr <= v_cntr + 1;
      end if;
    end if;
  end process;
  
  process (pxl_clk)
  begin
    if (rising_edge(pxl_clk)) then
      if (h_cntr >= (H_FP + FRAME_WIDTH - 1)) and (h_cntr < (H_FP + FRAME_WIDTH + H_PW - 1)) then
        h_sync_reg <= '1';
      else
        h_sync_reg <= '0';
      end if;
    end if;
  end process;
  
  
  process (pxl_clk)
  begin
    if (rising_edge(pxl_clk)) then
      if (v_cntr >= (V_FP + FRAME_HEIGHT - 1)) and (v_cntr < (V_FP + FRAME_HEIGHT + V_PW - 1)) then
        v_sync_reg <= '1';
      else
        v_sync_reg <= '0';
      end if;
    end if;
  end process;

    h_cntr_reg <= h_cntr;
    v_cntr_reg <= v_cntr;

end Arch_VGA_control;
