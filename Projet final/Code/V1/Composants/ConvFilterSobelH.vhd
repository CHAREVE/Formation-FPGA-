library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.ALL;
use work.all;
use IEEE.math_real.all;

-- masque kernel utilisé 3x3 :
-- K = 
--     C1   C2   C3
-- L1 |K11  K12  K13|
-- L2 |K21  K22  K23|
-- L3 |K31  K23  K33|

-- Masque Sobel (HORIZONTAL) :
-- |-1  0  1|
-- |-2  0  2|
-- |-1  0  1|
---- Masque Sobel(VERTICAL) :
-- |-1 -2 -1|
-- |0  0  0|
-- |1  2  1|

---- Masque Sobel H + Sobel V :
-- |(-1-1) -2  (1-1)|    |-2 -2  0|
-- |(0-2)   0    2  | => |-2  0  2|
-- |0       2  (1+1)|    | 0  2  2|

-- Etant donné que tous les coef sont des multiples de 2, on utilisera les décalages de bits pour les opérations

-- Les pixels utilisés dans le calcul sont nommés
--     C1        C2        C3
-- L1 |Pixel_11  Pixel_12  Pixel_13|
-- L2 |Pixel_21  Pixel_22  Pixel_23|
-- L3 |Pixel_31  Pixel_33  Pixel_33|

-- A chaque coup d'horloge, on décale le masque vers la droite (de 1 pixel), 
-- donc les pixels à considérer vont vers la gauche
-- Pixel_11 <= Pixel_12, Pixel_21 <= Pixel_22, ... Pixel_32 <= Pixel_33
-- les valeurs de Pixel_13, Pixel_23 et Pixel_33 sont les nouvelles valeurs à considérer, donc les inputs de la fonction
-- Pixel_L1 / Pixel_L2 / Pixel_L3

-- Pixel_out_ConvFilterSobelH sera la valeur utilisée pour comparer à un seuil 
-- afin de déterminer s'il s'agit d'un point d'intérêt ou non 

-- Un pixel RGB de 24 bits contient 8bits par composante de couleur
-- La somme doit pouvoir contenir des valeurs (somme minimale et somme maximale) entre (8bit x 6) et - (8bits x 6) 
-- => somme de 3 multiplications (x (-2)) ou somme de 3 multiplications (x 2). 
-- [255 x (-6) ; 255 x 6] => [-1530 ; 1530] => Besoin d'une variable signée qui va de [-1530 ; 1530] 
-- 1530 tient dans 11bits + 1 bit pour le signe => 12 bits

entity ConvFilterSobelH is
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
    Pixel_out_ConvFilterSobelH : out STD_LOGIC_VECTOR (23 downto 0));
end ConvFilterSobelH;

architecture Arch_ConvFilterSobelH of ConvFilterSobelH is
-- Pour la gestion des bords, application de la méthode zero padding. 
-- A la fin d'une ligne, les pixels sont remis à 0 

--signal Pixel_11, Pixel_12, Pixel_13, Pixel_21, Pixel_22, Pixel_23, Pixel_31, Pixel_32, Pixel_33 : STD_LOGIC_VECTOR (23 downto 0) := (others =>'0');
signal Pixel_out_somme_rouge, Pixel_out_somme_bleu, Pixel_out_somme_vert : signed(11 downto 0);
--signal Pixel_out_rouge, Pixel_out_bleu, Pixel_out_vert : STD_LOGIC_VECTOR (7 downto 0) := (others =>'0');

begin

process (pxl_clk)
begin
    if rising_edge(pxl_clk) then
               
        -- Application du filtre à chaque composante R G B de manière distincte
        -- Implique de prendre la partie rouge puis vert puis bleu
        
        -- Pixel rouge
        --Pixel_out_somme_bleu <= ('0' & Pixel_33(7 downto 0) & '0') + Pixel_32 ('0' & Pixel_13(7 downto 0)) + (Pixel_23(7 downto 0) & '0') - ('0' & Pixel_11(7 downto 0)) - ('0' & Pixel_31(7 downto 0)) - (Pixel_21(7 downto 0) & '0');--Somme des mult par les coef du filtre
        Pixel_out_somme_bleu <= signed((Pixel_33(7 downto 0) & '0') + (Pixel_32(7 downto 0) & '0') + (Pixel_23(7 downto 0) & '0') - (Pixel_11(7 downto 0) & '0') - (Pixel_21(7 downto 0) & '0')- (Pixel_12(7 downto 0) & '0')); 
        --Pixel_out_bleu <= Pixel_out_somme_rouge(7 downto 0); 
        -- Pixel vert
        Pixel_out_somme_vert <= signed((Pixel_33(15 downto 8) & '0') + (Pixel_32(15 downto 8) & '0') + (Pixel_23(15 downto 8) & '0') - (Pixel_11(15 downto 8) & '0') - (Pixel_21(15 downto 8) & '0')- (Pixel_12(15 downto 8) & '0'));
        --Pixel_out_vert <= Pixel_out_somme_vert(7 downto 0);
        -- Pixel bleu
        Pixel_out_somme_rouge <= signed((Pixel_33(23 downto 16) & '0') + (Pixel_32(23 downto 16) & '0') + (Pixel_23(23 downto 16) & '0') - (Pixel_11(23 downto 16) & '0') - (Pixel_21(23 downto 16) & '0')- (Pixel_12(23 downto 16) & '0'));
        --Pixel_out_rouge <= Pixel_out_somme_bleu(7 downto 0);
        
        -- Concaténation finale RGB
        --Pixel_out_ConvFilterSobelH <= Pixel_out_somme_rouge(7 downto 0) & Pixel_out_somme_vert(7 downto 0) & Pixel_out_somme_bleu(7 downto 0);
        Pixel_out_ConvFilterSobelH <= (others =>'0');
        --Pixel_out <= Pixel_out_rouge & Pixel_out_vert & Pixel_out_bleu;
        
        --Pixel_22 <= Pixel_22;
    end if;
end process;
end Arch_ConvFilterSobelH;
