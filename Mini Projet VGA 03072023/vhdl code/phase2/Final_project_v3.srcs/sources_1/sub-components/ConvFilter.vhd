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

-- Masque Gaussien :
-- |1  2  1|
-- |2  4  2|
-- |1  2  1|
-- Etant donné que tous les coef sont des multiples de 2, on utilisera les décalages de bits pour les opérations

--Les pixels utilisés dans le calcul sont nommés
--     C1   C2   C3
-- L1 |P11  P12  P13|
-- L2 |P21  P22  P23|
-- L3 |P31  P23  P33|

-- A chaque coup d'horloge, on décale de 1 le masque vers la droite, 
-- donc les pixels à considérer vont vers la gauche
-- P11 <= P12, P21 <= P22, ... P32 <= P33
-- les valeurs de P13, P23 et P33 sont les nouvelles valeurs à considérer, donc les inputs de la fonction
-- Pixel_L1 / Pixel_L2 / Pixel_L3

-- Pixel_out sera la valeur du pixel à appliquer aux coordonnées du pixel P22 en sortie du filtre


entity ConvFilterGauss is
Port (pxl_clk : in std_logic;
    Pixel_L1 : in STD_LOGIC_VECTOR (11 downto 0);
    Pixel_L2 : in STD_LOGIC_VECTOR (11 downto 0);
    Pixel_L3 : in STD_LOGIC_VECTOR (11 downto 0);
    Pixel_out : out STD_LOGIC_VECTOR (11 downto 0));
end ConvFilterGauss;

architecture Arch_ConvFilterGauss of ConvFilterGauss is
-- Pour la gestion des bords, application de la méthode zero padding. 
-- A la fin d'une ligne, les pixels sont remis à 0 
-- Au début d'une ligne, les pixels sont décalés sur la droite

signal P11, P12, P13, P21, P22, P23, P31, P32, P33 : STD_LOGIC_VECTOR (11 downto 0) := (others =>'0');
--signal Pixel_L3_t1, Pixel_L3_t2, Pixel_L3_t3, Pixel_L3_t4, Pixel_L3_t5, Pixel_L3_t6 : STD_LOGIC_VECTOR (11 downto 0) := (others =>'0');
--signal Pixel_out_somme : STD_LOGIC_VECTOR (15 downto 0):= (others =>'0'); -- besoin d'un signal 16 bits car max = signal 12 bits * 4 bits (16)
--signal test1, test6 : STD_LOGIC_VECTOR (15 downto 0):= (others =>'0');
--signal test2, test3,test4, test5 : STD_LOGIC_VECTOR (15 downto 0):= (others =>'0');
signal Pixel_out_somme_rouge, Pixel_out_somme_bleu, Pixel_out_somme_vert : STD_LOGIC_VECTOR (7 downto 0) := (others =>'0');
signal Pixel_out_rouge, Pixel_out_bleu, Pixel_out_vert : STD_LOGIC_VECTOR (3 downto 0) := (others =>'0');

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
        
        -- registres pour retarder la sortie de Pattern_gen de 6 coup d'horloge 
        -- du fait du retard de Pixel_L2 et Pixel_L1 qui sont les sorties des FIFO
        -- Les sorties des FIFO étant en retard, il faut retarder Pixel_L3
--        Pixel_L3_t6 <= Pixel_L3_t5;
--        Pixel_L3_t5 <= Pixel_L3_t4;
--        Pixel_L3_t4 <= Pixel_L3_t3;
--        Pixel_L3_t3 <= Pixel_L3_t2;
--        Pixel_L3_t2 <= Pixel_L3_t1;
--        Pixel_L3_t1 <= Pixel_L3;
        
        -- Point de test pour le calcul du filtre -- et compréhension du besoin de 16 bits pour le calcul du filtre
        
        --test1 <= ("0000" & P11) + ("0000" & P13) + ("0000" & P31) + ("0000" & P33); -- somme des 4 pixels dans les coins avec coef 1 de la matrice 
        --test2 <= "000" & P12 & '0'; -- multiplication x 2 : donc décalage à droite de 1 bit
        --test3 <= "000" & P21 & '0';-- multiplication x 2 : donc décalage à droite de 1 bit
        --test4 <= "000" & P23 & '0';-- multiplication x 2 : donc décalage à droite de 1 bit
        --test5 <= "000" & P32 & '0';-- multiplication x 2 : donc décalage à droite de 1 bit
        --test6 <= "00"& P22 & "00";-- multiplication x 4 : donc décalage à droite de 2 bits
        
        --Pixel_out_somme <= test1 + test2 + test3 + test4 + test5 + test6;
        
        -- Fin du point de test --
        
        -- Application du filtre à chaque composante R G B de manière distincte
        -- Implique de prendre la partie rouge puis vert puis bleu
        -- Pixel rouge
        Pixel_out_somme_rouge <= ("0000" & P11(11 downto 8)) + ("000" & P12(11 downto 8) & '0') + ("0000" & P13(11 downto 8)) + ("000" & P21(11 downto 8) & '0') + ("00"& P22(11 downto 8) & "00") + ("000" & P23(11 downto 8) & '0') + ("0000" & P31(11 downto 8)) + ("000" & P32(11 downto 8) & '0') + ("0000" & P33(11 downto 8));--Somme des mult par les coef du filtre
        Pixel_out_rouge <= Pixel_out_somme_rouge(7 downto 4); --division par 16
        -- Pixel vert
        Pixel_out_somme_vert <= ("0000" & P11(7 downto 4)) + ("000" & P12(7 downto 4) & '0') + ("0000" & P13(7 downto 4)) + ("000" & P21(7 downto 4) & '0') + ("00"& P22(7 downto 4) & "00") + ("000" & P23(7 downto 4) & '0') + ("0000" & P31(7 downto 4)) + ("000" & P32(7 downto 4) & '0') + ("0000" & P33(7 downto 4));
        Pixel_out_vert <= Pixel_out_somme_vert(7 downto 4);
        -- Pixel bleu
        Pixel_out_somme_bleu <= ("0000" & P11(3 downto 0)) + ("000" & P12(3 downto 0) & '0') + ("0000" & P13(3 downto 0)) + ("000" & P21(3 downto 0) & '0') + ("00"& P22(3 downto 0) & "00") + ("000" & P23(3 downto 0) & '0') + ("0000" & P31(3 downto 0)) + ("000" & P32(3 downto 0) & '0') + ("0000" & P33(3 downto 0));
        Pixel_out_bleu <= Pixel_out_somme_bleu(7 downto 4);
        
        -- Première méthode sans séparer les composantes R G B du pixel
        -- => Ne fonctionne pas à cause d'erreurs d'arrondis
        -- mult par 2^n = decalage à gauche de n bits = ajouter des bits '0' à droite = concatener PXY par '0'
        -- Pixel_out_somme <= ("0000" & P11) + ("000" & P12 & '0') + ("0000" & P13) + ("000" & P21 & '0') + ("00"& P22 & "00") + ("000" & P23 & '0') + ("0000" & P31) + ("000" & P32 & '0') + ("0000" & P33);
        -- Pixel_out <= Pixel_out_somme(15 downto 4);-- division par 16, donc par 2^4 donc décalage de 4 vers la droite
        
        -- Concaténation finale RGB
        Pixel_out <= Pixel_out_rouge & Pixel_out_vert & Pixel_out_bleu;
        -- Test
        --        Pixel_L3_t5 <= P23;
        --        Pixel_out <= P13(3 downto 0)&Pixel_L3_t5(3 downto 0)&Pixel_L3_t2(3 downto 0);
        -- Test

    end if;
end process;
end Arch_ConvFilterGauss;
