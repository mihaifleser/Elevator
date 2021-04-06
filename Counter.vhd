library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity COUNTER is
generic(MaxCount : natural := 10);
port (CLK: in std_logic;
		PL: in integer range 0 to MaxCount;
		RESET: in std_logic;
		Q: out integer range 0 to MaxCount;
		PLENABLE: in std_logic;
		OVERFLOW: out std_logic);
end COUNTER;

architecture arh of COUNTER is

begin
	
counterOperation: process(CLK)
	variable count : integer range 0 to Maxcount;
BEGIN 
	IF(clk'event and clk = '1') then
		if RESET = '0' then
			count := 0;
			OVERFLOW <= '0';
		else
			if PLENABLE = '1' then
				count := pl;
			else if count = MaxCount then
					count := 0;
					OVERFLOW <= '1';
				else
					count:= count+1;
					OVERFLOW <= '0';
				end if;
			end if;
		end if;
	end if;	
	q <= count;
end process counterOperation;
end arh;