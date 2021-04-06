library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RAM is
generic(MaxMem : natural := 12);
port(butoane: in std_logic_vector(12 downto 0);
	WE: in std_logic;
     RESET: in std_logic;
     Adress: in std_logic_vector (3 downto 0);
	 CLK: in std_logic;
     toBeShown: out std_logic;
	 MEMO: out std_logic_vector(12 downto 0);
     toBeWritten: in std_logic);
end RAM;

architecture A1 of RAM is 
signal VECT: std_logic_vector(MaxMem downto 0):= (others => '0');
begin

operation : process (CLK)
begin
if CLK'EVENT and CLK = '1' then
	if RESET = '1' then
		VECT <= (others => '0');
	else
		for I in 0 to 12 loop
			VECT(I) <= VECT(I) or butoane(I);
		end loop;
		if WE = '1' then
			VECT(conv_integer(Adress)) <= toBeWritten;
		end if;
			toBeShown <= VECT(conv_integer(Adress));
	end if;
	MEMO <= VECT;
	end if;
end process operation;
end A1;
