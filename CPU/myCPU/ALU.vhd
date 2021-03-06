library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ALU is
PORT ( 	M: IN STD_LOGIC;
		SEL: IN STD_LOGIC_VECTOR(3 downto 0); -- 1 input 3 bits for selecting function
		A, B: IN STD_LOGIC_VECTOR(7 downto 0); -- 2 input 8 bits
		
		Result: OUT STD_LOGIC_VECTOR(7 downto 0);
		Cf, Zf: OUT STD_LOGIC
	);
end ALU;

architecture Behav of ALU is
SIGNAL tmp: std_logic_vector(8 downto 0);
SIGNAL flag: std_logic_vector(7 downto 0):=(others=>'0');
begin
process(A, B, SEL, M) 
	-- R1 from B, R2 from A
BEGIN
	Zf<='0'; Cf<='0';
	IF M='1' THEN
		IF SEL="1001" THEN -- Add
			tmp <= ('0' & A) + ('0' & B);
			Result <= tmp(7 downto 0);
			Cf <= tmp(8);
			
			if tmp(7 downto 0)=flag then Zf<='1';
			else Zf<='0';	end if;
			
		ELSIF SEL="0110" THEN -- Subtract
			tmp <= ('0' & B) - ('0' & A);
			Result <= tmp(7 downto 0);
			Cf <= tmp(8);
			
			if tmp(7 downto 0)=flag then Zf<='1';
			else Zf<='0';	end if;
		ELSIF SEL="1011" THEN -- Or
			Result <= A or B;
		ELSIF SEL="0101" THEN -- Not R1
			Result <= not(B);

		ELSE Result <= "ZZZZZZZZ"; Zf<='Z'; Cf<='Z'; -- halt
		END IF;
		
	ELSE -- M='0' 
		Zf<='Z'; Cf<='Z';
			
		IF sel="1111" then Result <=A; -- MOVA MOVB, data flow from A
		ELSIF sel="1010" then Result <=B; --RSR RSL, data flow from B

		ELSE Result <= "ZZZZZZZZ";  -- halt
		END IF;
	END IF;
	END process;
end Behav;