library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Detector_miscare is
port(butoaneU: in std_logic_vector(12 downto 0);
	butoaneC: in std_logic_vector(12 downto 0);
	butoaneL: in std_logic_vector(12 downto 0);
	etajCurent: in std_logic_vector(3 downto 0);
	CLK: in std_logic;
	Iu: out std_logic;
	Ic: out std_logic;
	Ia: out std_logic);
end Detector_miscare;

architecture arh of Detector_miscare is

signal we1,we2,we3,reset,tbs1,tbs2,tbs3,tbw1,tbw2,tbw3: std_logic;
signal memoU,memoC,memoL : std_logic_vector(12 downto 0);
signal a1,a2,a3 : std_logic_vector(3 downto 0);
component RAM is
generic(MaxMem : natural := 12);
port(butoane: in std_logic_vector(12 downto 0);
	WE: in std_logic;
     RESET: in std_logic;
     Adress: in std_logic_vector (3 downto 0);
	 CLK: in std_logic;
     toBeShown: out std_logic;
	 MEMO: out std_logic_vector(12 downto 0);
     toBeWritten: in std_logic);
end component;

begin
Ru: RAM generic map(12)
		port map (butoaneU,we1,reset,a1,clk,tbs1,memoU,tbw1);
Rc: RAM generic map(12)
		port map (butoaneC,we2,reset,a2,clk,tbs2,memoC,tbw2);
Rl: RAM generic map(12)
		port map (butoaneL,we3,reset,a3,clk,tbs3,memoL,tbw3);


Operation: process(CLK)
variable rez: std_logic := '0';
BEGIN
if CLK'EVENT and CLK = '1' then
	rez := '0';
	for I in conv_integer(etajCurent) + 1 to 12 loop
		rez := rez or memoU(I) or memoL(I);
	end loop;
	Iu <= rez;

	rez := '0';
	for I in 0 to conv_integer(etajCurent) - 1 loop
		rez := rez or memoC(I) or memoL(I);
	end loop;
	Ic <= rez;

	rez := '0';
	rez := memoU(conv_integer(etajCurent)) or memoC(conv_integer(etajCurent)) or memoL(conv_integer(etajCurent));
	if rez = '1' then
		tbw1 <= '0';
		tbw2 <= '0';
		tbw3 <= '0';
		a1 <= etajCurent;
		a2 <= etajCurent;
		a3 <= etajCurent;
		we1 <= '1';
		we2 <= '1';
		we3 <= '1';
	else
		we1 <= '0';
		we2 <= '0';
		we3 <= '0';
	end if;
	Ia <= rez;

end if;
end process Operation;
end arh;