
-- Déclaration des paquetages utiles pour le module
library ieee;
use ieee.std_logic_1164.all;
-- use ieee.std_logic_arith.all;
--use ieee.std_logic_unsigned.all;

--Description externe
entity subtractor is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           S : out STD_LOGIC;
           Cout : out STD_LOGIC);
end subtractor;

architecture Behavioral of subtractor is
begin
    S <= A XOR B XOR Cin ;
	Cout <=((not A)and B) or (Cin AND (not(A XOR B)));
	 
end Behavioral;
