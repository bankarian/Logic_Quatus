library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ProgramCounter is -- manipulate the Address
PORT(
	LD: in STD_LOGIC; -- Load Enable
	INC: in STD_LOGIC; -- Increment
	clk: in STD_LOGIC; -- Clock
	inAddr: in STD_LOGIC_VECTOR(7 downto 0); -- input address
	
	oAddr: out STD_LOGIC_VECTOR(7 downto 0):=(others=>'0') -- output address
	);
end ProgramCounter;

architecture behav of ProgramCounter is
signal Finder: std_logic_vector(7 downto 0):=(others=>'0');
signal order: std_logic_vector(1 downto 0);
begin 
	order <= (INC & LD);
	process (clk)
	begin
		IF falling_edge(clk) then
			case order is 
				when "01" => Finder <= inAddr; -- load in addresss
				when "10" => Finder <= Finder+1; -- increment
				when others => Finder <= Finder;
			end case;
		END IF;
	end process;
	oAddr <= Finder;
end behav;