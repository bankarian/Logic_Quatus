library ieee;
use ieee.std_logic_1164.all;

entity slowDown is 
port(
	clk: in std_logic;
	dout: out std_logic
);
end slowDown;

architecture behav of slowDown is
signal cnt: integer range 0 to 48:=0;
begin
	process(clk)
	begin
		if(clk'event and clk='1') then
			cnt<=cnt+1;
			if(cnt=12) then
				cnt<=cnt+1;dout<='1' ;	  
			elsif(cnt=24) then cnt<=0; dout<='0' ; 
			end if;
		end if; 
	end process;
end behav;