
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use work.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
Port ( CLK_I : in STD_LOGIC;
        RST : in STD_LOGIC;
        VGA_HS_O : out STD_LOGIC;
        VGA_VS_O : out STD_LOGIC;
        VGA_R : out STD_LOGIC_VECTOR (3 downto 0);
        VGA_B : out STD_LOGIC_VECTOR (3 downto 0);
        VGA_G : out STD_LOGIC_VECTOR (3 downto 0));
end top;

architecture Behavioral of top is

component clk_wiz_0
port
 (-- Clock in ports
  CLK_IN1           : in     std_logic;
  -- Clock out ports
  CLK_OUT1          : out    std_logic
 );
end component;

component Pattern_gen is
  Port (pxl_clk : in std_logic;
        h_cntr_reg : in std_logic_vector(11 downto 0);
        v_cntr_reg : in std_logic_vector(11 downto 0);
        Pixel_L3 : out std_logic_vector(11 downto 0));
end component;

--component VGA_control is
--Port (pxl_clk : in std_logic;
--     RST : in std_logic;
--     --h_cntr_reg : out std_logic_vector(11 downto 0);
--     --v_cntr_reg : out std_logic_vector(11 downto 0);
--     h_sync_reg : out std_logic;
--     v_sync_reg : out std_logic);
--end component;

component fifo_generator_1 is
  Port (clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC);
end component;

component fifo_generator_2 is
  Port (clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC);
end component;

component ConvFilterGauss is
Port (pxl_clk : in std_logic;
    Pixel_L1 : in STD_LOGIC_VECTOR (11 downto 0);
    Pixel_L2 : in STD_LOGIC_VECTOR (11 downto 0);
    Pixel_L3 : in STD_LOGIC_VECTOR (11 downto 0);
    Pixel_out : out STD_LOGIC_VECTOR (11 downto 0));
end component;

--Sync Generation constants

----***640x480@60Hz***--  Requires 25 MHz clock (800 525)
--constant FRAME_WIDTH : natural := 640;
--constant FRAME_HEIGHT : natural := 480;

--constant H_FP : natural := 16; --H front porch width (pixels)
--constant H_PW : natural := 96; --H sync pulse width (pixels)
--constant H_MAX : natural := 800; --H total period (pixels)

--constant V_FP : natural := 10; --V front porch width (lines)
--constant V_PW : natural := 2; --V sync pulse width (lines)
--constant V_MAX : natural := 525; --V total period (lines)

--constant H_POL : std_logic := '0';
--constant V_POL : std_logic := '0';

----***800x600@60Hz***--  Requires 40 MHz clock
--constant FRAME_WIDTH : natural := 800;
--constant FRAME_HEIGHT : natural := 600;
--
--constant H_FP : natural := 40; --H front porch width (pixels)
--constant H_PW : natural := 128; --H sync pulse width (pixels)
--constant H_MAX : natural := 1056; --H total period (pixels)
--
--constant V_FP : natural := 1; --V front porch width (lines)
--constant V_PW : natural := 4; --V sync pulse width (lines)
--constant V_MAX : natural := 628; --V total period (lines)
--
--constant H_POL : std_logic := '1';
--constant V_POL : std_logic := '1';


----***1280x720@60Hz***-- Requires 74.25 MHz clock
--constant FRAME_WIDTH : natural := 1280;
--constant FRAME_HEIGHT : natural := 720;
--
--constant H_FP : natural := 110; --H front porch width (pixels)
--constant H_PW : natural := 40; --H sync pulse width (pixels)
--constant H_MAX : natural := 1650; --H total period (pixels)
--
--constant V_FP : natural := 5; --V front porch width (lines)
--constant V_PW : natural := 5; --V sync pulse width (lines)
--constant V_MAX : natural := 750; --V total period (lines)
--
--constant H_POL : std_logic := '1';
--constant V_POL : std_logic := '1';

----***1280x1024@60Hz***-- Requires 108 MHz clock
--constant FRAME_WIDTH : natural := 1280;
--constant FRAME_HEIGHT : natural := 1024;

--constant H_FP : natural := 48; --H front porch width (pixels)
--constant H_PW : natural := 112; --H sync pulse width (pixels)
--constant H_MAX : natural := 1688; --H total period (pixels)

--constant V_FP : natural := 1; --V front porch width (lines)
--constant V_PW : natural := 3; --V sync pulse width (lines)
--constant V_MAX : natural := 1066; --V total period (lines)

--constant H_POL : std_logic := '1';
--constant V_POL : std_logic := '1';

--***1920x1080@60Hz***-- Requires 148.5 MHz pxl_clk
constant FRAME_WIDTH : natural := 1920;
constant FRAME_HEIGHT : natural := 1080;

constant H_FP : natural := 88; --H front porch width (pixels)
constant H_PW : natural := 44; --H sync pulse width (pixels)
constant H_MAX : natural := 2200; --H total period (pixels)

constant V_FP : natural := 4; --V front porch width (lines)
constant V_PW : natural := 5; --V sync pulse width (lines)
constant V_MAX : natural := 1125; --V total period (lines)

--constant H_POL : std_logic := '1';
--constant V_POL : std_logic := '1';

----Moving Box constants
--constant BOX_WIDTH : natural := 8;
--constant BOX_CLK_DIV : natural := 1000000; --MAX=(2^25 - 1)

--constant BOX_X_MAX : natural := (512 - BOX_WIDTH);
--constant BOX_Y_MAX : natural := (FRAME_HEIGHT - BOX_WIDTH);

--constant BOX_X_MIN : natural := 0;
--constant BOX_Y_MIN : natural := 256;

--constant BOX_X_INIT : std_logic_vector(11 downto 0) := x"000";
--constant BOX_Y_INIT : std_logic_vector(11 downto 0) := x"190"; --400

signal pxl_clk : std_logic;
signal active : std_logic;

signal h_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');
signal v_cntr_reg : std_logic_vector(11 downto 0) := (others =>'0');

signal h_sync_reg : std_logic := '0';
signal v_sync_reg : std_logic := '0';

signal h_sync_dly_reg : std_logic := '0';
signal v_sync_dly_reg : std_logic := '0';

signal vga_red_reg : std_logic_vector(3 downto 0) := (others =>'0');
signal vga_green_reg : std_logic_vector(3 downto 0) := (others =>'0');
signal vga_blue_reg : std_logic_vector(3 downto 0) := (others =>'0');

signal vga_red : std_logic_vector(3 downto 0);
signal vga_green : std_logic_vector(3 downto 0);
signal vga_blue : std_logic_vector(3 downto 0);

signal Pixel_L1, Pixel_L2, Pixel_L3, Pixel_out : std_logic_vector(11 downto 0); 
signal FIFO_1_empty, FIFO_2_empty, FIFO_1_full, FIFO_2_full : std_logic;
signal FIFO_1_write_ena, FIFO_2_write_ena, FIFO_1_read_ena, FIFO_2_read_ena : std_logic;

signal Init, Init2 : std_logic := '1';-- variable pour reperer le remplissage des fifos
--signal v_sync_reg_t1, v_sync_reg_t2, v_sync_reg_t3, v_sync_reg_t4, v_sync_reg_t5, v_sync_reg_t6 : std_logic;-- registres pour retarder VSYNC
--signal h_sync_reg_t1, h_sync_reg_t2, h_sync_reg_t3, h_sync_reg_t4, h_sync_reg_t5, h_sync_reg_t6 : std_logic;-- registres pour retarder HSYNC

constant h_decal : natural := 4;-- utilisé pour décaler h_sync. Mis à 7 pour 1 de décalage (lié au masque) et 6 de retard de l'info lié au FIFO
constant v_decal : natural := 1;-- utilisé pour décaler v_sync

begin
   
clk_div_inst : clk_wiz_0
port map
   (-- Clock in ports
    CLK_IN1 => CLK_I,
    -- Clock out ports
    CLK_OUT1 => pxl_clk);

-- generation du compteur horizontal
-- quand h_cntr atteint le bout de la ligne, reprend à 0
process (pxl_clk)
begin
if (rising_edge(pxl_clk)) then
    if ((h_cntr_reg = (H_MAX - 1)) or (RST = '1')) then
        h_cntr_reg <= (others =>'0');
    else
        h_cntr_reg <= h_cntr_reg + 1;
    end if;
end if;
end process;
-- generation du compteur vertical 
-- quand h_cntr atteint le bout de la ligne, v_cntr s'incrémente
-- quand h_cntr atteint le bout de la ligne et v_cntr le bout de la colonne, v_cntr reprend à 0
process (pxl_clk)
begin
if (rising_edge(pxl_clk)) then
    if (((h_cntr_reg = (H_MAX - 1)) and (v_cntr_reg = (V_MAX - 1))) or (RST = '1')) then
        v_cntr_reg <= (others =>'0');
    elsif (h_cntr_reg = (H_MAX - 1)) then
        v_cntr_reg <= v_cntr_reg + 1;
    end if;
end if;
end process;
      
Pattern_gen_inst : Pattern_gen
port map
    (pxl_clk=> pxl_clk,
        h_cntr_reg => h_cntr_reg,
        v_cntr_reg => v_cntr_reg,
        Pixel_L3 => Pixel_L3);

Init <= 
    '1' when RST = '1' else
    '0' when h_cntr_reg = (H_MAX - 1); --v_cntr_reg = 1; -- quand la 1e ligne est lue, on autorise à lire dans FIFO1 et écrire dans FIFO2
    
Init2 <= 
    '1' when RST = '1' else
    '0' when ((h_cntr_reg = (H_MAX - 1)) and (v_cntr_reg = 1)); --v_cntr_reg = 2; -- quand la 2e ligne est lue, on autorise à lire FIFO2
    
FIFO_1_write_ena <= not(FIFO_1_full); --on écrit dans FIFO_1 dès le début
FIFO_1_read_ena <= not(FIFO_1_empty) and not(Init); --on lit dans FIFO_1 si FIFO_1 n'est pas vide et si la première ligne a été entièrement lue (not (Init))
FIFO_2_write_ena <= not(FIFO_2_full) and not(Init); --on écrit dans FIFO_2 si FIFO_1 n'est pas plein et si la première ligne a été entièrement lue (not (Init))
FIFO_2_read_ena <= not(FIFO_2_empty) and not(Init2); --on lit dans FIFO_2 si FIFO_2 n'est pas vide et si la 2e ligne a été entièrement lue (not (Init2))

FIFO_L1_inst : fifo_generator_1
port map (clk => pxl_clk,
    srst => RST,
    din => Pixel_L3, --Pixel_L3 est le pixel sortie de pattern_gen. c'est celui qui viendra en bas à droite de notre filtre (P33)
    wr_en => FIFO_1_write_ena,
    rd_en => FIFO_1_read_ena,
    dout => Pixel_L2, --Pixel_L2 est le pixel de la ligne au dessus du pixel courant Pixel_L3
    full => FIFO_1_full,
    empty => FIFO_1_empty);

FIFO_L2_inst : fifo_generator_2
port map (clk => pxl_clk,
    srst => RST,
    din => Pixel_L2,-- Prend la sortie de FIFO1
    wr_en => FIFO_2_write_ena,
    rd_en => FIFO_2_read_ena,
    dout => Pixel_L1, -- Pixel_L1 est le pixel de la ligne au dessus du pixel Pixel_L2 donc 2 lignes au dessus du pixel courant Pixel_L3
    full => FIFO_2_full,
    empty => FIFO_2_empty);

ConvFilterGauss_inst : ConvFilterGauss
port map (pxl_clk => pxl_clk,
    Pixel_L1 => Pixel_L1,
    Pixel_L2 => Pixel_L2,
    Pixel_L3 => Pixel_L3,
    Pixel_out => Pixel_out);

-- Pour tenir compte que le pixel de sortie (image output) du filtre a les coordonnées (h_cntr - 1; v_cntr - 1), 
-- (exemple, le pixel de l'image du pattern_gen est le (3;3) mais le pixel sorti du filtre est le (2;2)
-- il faut décaler h_sync et v_sync. Les signaux h_decal et v_decal sont ajoutés aux calculs de h_sync et v_sync
-- h_sync doit aussi tenir compte du délai pour réceptionner les sorties des FIFO et être décalé d'autant

-- calcul de h_sync --
-- h_sync = 1 quand (H_FP + FRAME_WIDTH - 1) <= v_cntr_reg < H_FP + FRAME_WIDTH + H_PW - 1
process (pxl_clk)
begin
if (rising_edge(pxl_clk)) then
    if (h_cntr_reg >= (H_FP + FRAME_WIDTH - 1 + h_decal)) and (h_cntr_reg < (H_FP + FRAME_WIDTH + H_PW - 1 + h_decal)) then
        h_sync_reg <= '1';
    else
        h_sync_reg <= '0';
    end if;
end if;
end process;

-- calcul de v_sync --
-- v_sync = 1 quand (V_FP + FRAME_HEIGHT - 1) <= v_cntr_reg < V_FP + FRAME_HEIGHT + V_PW - 1
process (pxl_clk)
begin
if (rising_edge(pxl_clk)) then
    if (v_cntr_reg >= (V_FP + FRAME_HEIGHT - 1 + v_decal)) and (v_cntr_reg < (V_FP + FRAME_HEIGHT + V_PW - 1 + v_decal)) then
        v_sync_reg <= '1';
    else
        v_sync_reg <= '0';
    end if;
end if;
end process;

process (pxl_clk)
begin
if (rising_edge(pxl_clk)) then

    ------------------------------------
    -- Test retard sur V_sync et H_sync
    -- Ensuite, ajout de V_decal et h_decal à la place
    -- => code plus utilisé
    ------------------------------------
    
    --    v_sync_reg_t6 <= v_sync_reg_t5;
    --    v_sync_reg_t5 <= v_sync_reg_t4;
    --    v_sync_reg_t4 <= v_sync_reg_t3;
    --    v_sync_reg_t3 <= v_sync_reg_t2;
    --    v_sync_reg_t2 <= v_sync_reg_t1;
    --    v_sync_reg_t1 <= v_sync_reg;
        
    --    h_sync_reg_t6 <= h_sync_reg_t5;
    --    h_sync_reg_t5 <= h_sync_reg_t4;
    --    h_sync_reg_t4 <= h_sync_reg_t3;
    --    h_sync_reg_t3 <= h_sync_reg_t2;
    --    h_sync_reg_t2 <= h_sync_reg_t1;
    --    h_sync_reg_t1 <= h_sync_reg;
        
    --    v_sync_dly_reg <= v_sync_reg_t6;
    --    h_sync_dly_reg <= h_sync_reg_t6;
    --------------------------------------
    
    v_sync_dly_reg <= v_sync_reg;
    h_sync_dly_reg <= h_sync_reg;
    
    vga_red_reg <= Pixel_out(11 downto 8);
    vga_green_reg <= Pixel_out(7 downto 4);
    vga_blue_reg <= Pixel_out(3 downto 0);
end if;
end process;

-- Affectation des sorties
VGA_HS_O <= h_sync_dly_reg;
VGA_VS_O <= v_sync_dly_reg;
VGA_R <= vga_red_reg;
VGA_G <= vga_green_reg;
VGA_B <= vga_blue_reg;

end Behavioral;
