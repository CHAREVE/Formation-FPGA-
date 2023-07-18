
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

entity Top is
generic(
    FRAME_WIDTH : natural := 640;  -- largeur de l'image
    PX_SIZE : natural := 24        -- taille d'un pixel
    );
Port ( clk : in STD_LOGIC;
        RST : in STD_LOGIC;
        input_data: in STD_LOGIC_VECTOR (23 downto 0);
        input_data_valid : in STD_LOGIC;
        output_data : out STD_LOGIC_VECTOR (23 downto 0);
        output_data_valid : out STD_LOGIC);
end Top;

architecture Arch_Top of Top is

constant Threshold : integer := 60; 
constant Pixel_Cyan : std_logic_vector(23 downto 0) := ("000000001111111111111111");

signal h_cnt : integer := 0;

signal Pixel_L1, Pixel_L2, Pixel_L3, Pixel_out : std_logic_vector(23 downto 0) := (others =>'0'); 
signal Pixel_out_ConvFilterSobelH : integer;
signal Pixel_11, Pixel_12, Pixel_13, Pixel_21, Pixel_22, Pixel_23, Pixel_31, Pixel_32, Pixel_33 : std_logic_vector(23 downto 0) := (others =>'0'); 
signal FIFO_1_empty, FIFO_2_empty, FIFO_1_full, FIFO_2_full : std_logic;
signal FIFO_1_write_ena, FIFO_2_write_ena, FIFO_1_read_ena, FIFO_2_read_ena : std_logic;

signal Init, Init2 : std_logic := '0';-- variable pour reperer le remplissage des fifos
signal FIFO_2_write_ena_delay, Init_retard1,Init_retard2, Init_retard3,Init_retard4 : std_logic := '0';--variables pour retarder output_data_valid

component fifo_generator_1 is
  Port (clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC);
end component;

component fifo_generator_2 is
  Port (clk : IN STD_LOGIC;
    srst : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
    full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC);
end component;

component RegistreMngt is
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
end component;

component ConvFilterSobelH is
Port (pxl_clk : in std_logic;
    Pixel_11 : in STD_LOGIC_VECTOR (23 downto 0);
    Pixel_12 : in STD_LOGIC_VECTOR (23 downto 0);
    Pixel_13 : in STD_LOGIC_VECTOR (23 downto 0);
    Pixel_21 : in STD_LOGIC_VECTOR (23 downto 0);
    Pixel_22 : in STD_LOGIC_VECTOR (23 downto 0);
    Pixel_23 : in STD_LOGIC_VECTOR (23 downto 0);
    Pixel_31 : in STD_LOGIC_VECTOR (23 downto 0);
    Pixel_32 : in STD_LOGIC_VECTOR (23 downto 0);
    Pixel_33 : in STD_LOGIC_VECTOR (23 downto 0);
    Pixel_out_ConvFilterSobelH : out integer);
end component;

begin

-- generation du compteur horizontal
-- quand h_cntr atteint le bout de la ligne, reprend à 0
process (clk)
begin
if (rising_edge(clk)) then
    if RST = '1' then
        Init <= '0';
        Init2 <= '0';
    elsif ((h_cnt = FRAME_WIDTH) and (Init = '1')) then
        Init2 <= '1'; -- quand la 2e ligne est lue, on autorise à lire FIFO2
    elsif (h_cnt = FRAME_WIDTH) then
        Init <= '1'; -- quand la 1e ligne est lue, on autorise à lire dans FIFO1 et écrire dans FIFO2       
    end if;
   
    if (RST = '1') then
        h_cnt <= 0;
    elsif (h_cnt = FRAME_WIDTH) and (input_data_valid = '1') then
        h_cnt <= 1;
    elsif (input_data_valid = '1') then
        h_cnt <= h_cnt + 1;
    end if;
    
    if input_data_valid = '1' then
        Pixel_L3 <= input_data;
    else
        Pixel_L3 <= (others =>'0');
    end if;
    
    FIFO_2_write_ena_delay <= FIFO_2_write_ena;
    
    -- Affectation des sorties
    if (Pixel_out_ConvFilterSobelH >= Threshold) then
        output_data <= Pixel_Cyan;
    else 
        --output_data <= Pixel_22;
        output_data <= (others =>'0');
    end if;
    
    --Init_retard5 <= Init_retard4;
    Init_retard4 <= Init_retard3;
    Init_retard3 <= Init_retard2;
    Init_retard2 <= Init_retard1;
    Init_retard1 <= Init;
    
    output_data_valid <= Init_retard4;
end if;
end process;
 
FIFO_1_write_ena <= not(FIFO_1_full) and input_data_valid; --on écrit dans FIFO_1 dès le début
FIFO_1_read_ena <= not(FIFO_1_empty) and Init; --on lit dans FIFO_1 si FIFO_1 n'est pas vide et si la première ligne a été entièrement lue (not (Init))
FIFO_2_write_ena <= not(FIFO_2_full) and Init; --on écrit dans FIFO_2 si FIFO_1 n'est pas plein et si la première ligne a été entièrement lue (not (Init))
FIFO_2_read_ena <= not(FIFO_2_empty) and Init2; --on lit dans FIFO_2 si FIFO_2 n'est pas vide et si la 2e ligne a été entièrement lue (not (Init2))

FIFO_L1_inst : fifo_generator_1
port map (clk => clk,
    srst => RST,
    din => Pixel_L3, --Pixel_L3 est le pixel sortie de pattern_gen. c'est celui qui viendra en bas à droite de notre filtre (P33)
    wr_en => FIFO_1_write_ena,
    rd_en => FIFO_1_read_ena,
    dout => Pixel_L2, --Pixel_L2 est le pixel de la ligne au dessus du pixel courant Pixel_L3
    full => FIFO_1_full,
    empty => FIFO_1_empty);

FIFO_L2_inst : fifo_generator_2
port map (clk => clk,
    srst => RST,
    din => Pixel_L2,-- Prend la sortie de FIFO1
    wr_en => FIFO_2_write_ena_delay,
    rd_en => FIFO_2_read_ena,
    dout => Pixel_L1, -- Pixel_L1 est le pixel de la ligne au dessus du pixel Pixel_L2 donc 2 lignes au dessus du pixel courant Pixel_L3
    full => FIFO_2_full,
    empty => FIFO_2_empty);

RegistreMngt_inst : RegistreMngt
port map (clk => clk,
    h_cnt => h_cnt,
    Pixel_L1 => Pixel_L1,
    Pixel_L2 => Pixel_L2,
    Pixel_L3 => Pixel_L3,
    Pixel_11 => Pixel_11,
    Pixel_12 => Pixel_12,
    Pixel_13 => Pixel_13,
    Pixel_21 => Pixel_21,
    Pixel_22 => Pixel_22,
    Pixel_23 => Pixel_23,
    Pixel_31 => Pixel_31,
    Pixel_32 => Pixel_32,
    Pixel_33 => Pixel_33);

ConvFilterSobelH_inst : ConvFilterSobelH
port map (pxl_clk => clk,
    Pixel_11 => Pixel_11,
    Pixel_12 => Pixel_12,
    Pixel_13 => Pixel_13,
    Pixel_21 => Pixel_21,
    Pixel_22 => Pixel_22,
    Pixel_23 => Pixel_23,
    Pixel_31 => Pixel_31,
    Pixel_32 => Pixel_32,
    Pixel_33 => Pixel_33,
    Pixel_out_ConvFilterSobelH => Pixel_out_ConvFilterSobelH);

end Arch_Top;
