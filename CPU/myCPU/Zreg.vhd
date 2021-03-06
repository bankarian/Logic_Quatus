library ieee;
use ieee.std_logic_1164.all;

entity Zreg is
PORT(
	clk: in STD_LOGIC;
	S: in STD_LOGIC_VECTOR(3 DOWNTO 0);
	Zin: in STD_LOGIC;
	Zout: out STD_LOGIC
	);
end Zreg;

architecture behav of Zreg is
signal reg: std_logic:='0';
signal flag: std_logic:='0';
begin 
	process(clk)
	begin
		if rising_edge(clk) then
			if((S="1001" or S="0110") and flag='0') then -- only operate when add/sub
				reg <= Zin; flag<='1';
			else flag<='0';
			end if;
		end if;
	end process;
	Zout <= reg;
end;