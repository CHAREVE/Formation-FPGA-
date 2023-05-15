library ieee;
use ieee.std_logic_1164.all;


entity full_adder is

	Port ( 
		--Entrées full adder 
		A 	: in std_logic;
		B 	: in std_logic;
		Cin : in std_logic;
				
		--Sorties full adder 
		S 	: out std_logic;
		Cout: out std_logic
	);

end full_adder;

 

architecture behavior of full_adder is
 
begin

    S <= A XOR B XOR Cin ;
	Cout <= Cin and (A xor B) or (A and B);  

end behavior;

