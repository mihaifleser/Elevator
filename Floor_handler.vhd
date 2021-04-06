library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Floor_handler is
port (CLK: in std_logic;
		viteza: in integer range 1 to 3;
		RESET: in std_logic;
		etajCurent: out std_logic_vector(3 downto 0);
		urca: in std_logic;
		coboara: in std_logic);
end Floor_handler;

architecture arh of Floor_handler is

signal resetCounter,Plenable1,Plenable2,Overflow1,Overflow2 : std_logic := '0';
signal PL1,PL2,Q1,Q2 : integer range 0 to 3000;

component COUNTER is
generic(MaxCount : natural := 10);
port (CLK: in std_logic;
		PL: in integer range 0 to MaxCount;
		RESET: in std_logic;
		Q: out integer range 0 to MaxCount;
		PLENABLE: in std_logic;
		OVERFLOW: out std_logic);
end component;


begin
C1: Counter generic map (10)
			port map (CLK,PL1,resetCounter,Q1,Plenable1,Overflow1);
C2: Counter generic map (30)
			port map (CLK,PL2,resetCounter,Q2,Plenable2,Overflow2);	

Operation: process(CLK)
variable etaj : integer range 0 to 12;
BEGIN
if CLK'EVENT and CLK = '1' then
	if urca = '1' then
            if viteza = 1 then
                resetCounter <= '1';
                if(Overflow1 = '1') then
                    etaj := etaj + 1;
                    resetCounter <= '0';
                end if;
            else
              resetCounter <= '1';
              if(Overflow2 = '1') then
                etaj:= etaj+1;
                resetCounter <= '0';
              end if;
          end if;
		else	
			if coboara = '1' then
				if viteza = 1 then
	                resetCounter <= '1';
	                if(Overflow1 = '1') then
	                    etaj := etaj - 1;
	                    resetCounter <= '0';
	                end if;
	            else
	               resetCounter <= '1';
	               if(Overflow2 = '1') then
	                 etaj:= etaj-1;
	                 resetCounter <= '0';
	               end if;
	           end if;
			end if;
	end if;
etajCurent <= std_logic_vector(conv_unsigned(etaj, etajCurent'length));
end if;
end process Operation;
end arh;