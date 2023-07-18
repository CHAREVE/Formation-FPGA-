library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use work.all;

-- masque kernel utilisé 3x3 :
-- K = 
--     C1   C2   C3
-- L1 |K11  K12  K13|
-- L2 |K21  K22  K23|
-- L3 |K31  K23  K33|

---- Masque Sobel(VERTICAL) :
-- |-1 -2 -1|
-- |0  0  0|
-- |1  2  1|

-- Etant donné que tous les coef sont des multiples de 2, on utilisera les décalages de bits pour les opérations

--Les pixels utilisés dans le calcul sont nommés
--     C1   C2   C3
-- L1 |P11  P12  P13|
-- L2 |P21  P22  P23|
-- L3 |P31  P33  P33|

-- A chaque coup d'horloge, on décale de 1 le masque vers la droite, 
-- donc les pixels à considérer vont vers la gauche
-- P11 <= P12, P21 <= P22, ... P32 <= P33
-- les valeurs de P13, P23 et P33 sont les nouvelles valeurs à considérer, donc les inputs de la fonction
-- Pixel_L1 / Pixel_L2 / Pixel_L3

-- Pixel_out sera la valeur du pixel à appliquer aux coordonnées du pixel P22 en sortie du filtre


entity ConvFilterSobelV is
Port (pxl_clk : in std_logic;
    Pixel_L1 : in STD_LOGIC_VECTOR (23 downto 0);
    Pixel_L2 : in STD_LOGIC_VECTOR (23 downto 0);
    Pixel_L3 : in STD_LOGIC_VECTOR (23 downto 0);
    Pixel_out_ConvFilterSobelV : out STD_LOGIC_VECTOR (23 downto 0));
end ConvFilterSobelV;

architecture Arch_ConvFilterSobelV of ConvFilterSobelV is
-- Pour la gestion des bords, application de la méthode zero padding. 
-- A la fin d'une ligne, les pixels sont remis à 0 

signal P11, P12, P13, P21, P22, P23, P31, P32, P33 : STD_LOGIC_VECTOR (23 downto 0) := (others =>'0');
signal Pixel_out_somme_rouge, Pixel_out_somme_bleu, Pixel_out_somme_vert : STD_LOGIC_VECTOR (8 downto 0) := (others =>'0');
--signal Pixel_out_rouge, Pixel_out_bleu, Pixel_out_vert : STD_LOGIC_VECTOR (7 downto 0) := (others =>'0');

begin

process (pxl_clk)
begin
    if rising_edge(pxl_clk) then
            
        -- affectation de des pixels dans le masque (on se déplace vers la droite)
        P11 <= P12;
        P12 <= P13;
        P13 <= Pixel_L1;
        P21 <= P22;
        P22 <= P23;
        P23 <= Pixel_L2;
        P31 <= P32;
        P32 <= P33;
        P33 <= Pixel_L3;-- P33 est décalé d'autant de coup d'horloge que nécessaire pour être synchronisé avec les sorties du FIFO (P23 et P13)
        
        -- Application du filtre à chaque composante R G B de manière distincte
        -- Implique de prendre la partie rouge puis vert puis bleu
        -- Pixel rouge
        Pixel_out_somme_bleu <= ('0' & P33(7 downto 0)) + ('0' & P31(7 downto 0)) + (P32(7 downto 0) & '0') - ('0' & P11(7 downto 0)) - ('0' & P13(7 downto 0)) - (P12(7 downto 0) & '0');--Somme des mult par les coef du filtre
        --Pixel_out_bleu <= Pixel_out_somme_rouge(7 downto 0); 
        -- Pixel vert
        Pixel_out_somme_vert <= ('0' & P33(15 downto 8)) + ('0' & P31(15 downto 8)) + (P32(15 downto 8) & '0') - ('0' & P11(15 downto 8)) - ('0' & P13(15 downto 8)) - (P12(15 downto 8) & '0');
        --Pixel_out_vert <= Pixel_out_somme_vert(7 downto 0);
        -- Pixel bleu
        Pixel_out_somme_rouge <= ('0' & P33(23 downto 16)) + ('0' & P31(23 downto 16)) + (P32(23 downto 16) & '0') - ('0' & P11(23 downto 16)) - ('0' & P13(23 downto 16)) - (P12(23 downto 16) & '0');
        --Pixel_out_rouge <= Pixel_out_somme_bleu(7 downto 0);

        -- Concaténation finale RGB
        Pixel_out_ConvFilterSobelV <= Pixel_out_somme_rouge(7 downto 0) & Pixel_out_somme_vert(7 downto 0) & Pixel_out_somme_bleu(7 downto 0);
        --Pixel_out <= Pixel_out_rouge & Pixel_out_vert & Pixel_out_bleu;

    end if;
end process;
end Arch_ConvFilterSobelV;
