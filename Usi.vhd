library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity usi is
port( enable : in std_logic;
reset : in std_logic;
timpDeschidere : in natural range 0 to 5000;
CLK : in std_logic;
SenzOm : in std_logic;
SenzUsiInchise : out std_logic);
end usi;

architecture arh of usi is

signal resetCounter1,resetCounter2,Plenable1,Plenable2,Overflow1,Overflow2 : std_logic := '0';
signal PL1,PL2,Q1,Q2,timp : integer range 0 to 3000;
type stateType is (idle, deschideUsi, staiDeschis, Verifica,inchideUsi);
signal state, nextState : stateType;


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
timp <= timpDeschidere;
C1: Counter generic map (5)
			port map (CLK,PL1,resetCounter1,Q1,Plenable1,Overflow1);
C2: Counter generic map (2)
			port map (CLK,PL2,resetCounter2,Q2,Plenable2,Overflow2);	

ACTUALIZEAZÃ_STARE: process (reset, clk)
	begin
		if (reset = '1') then
			state <= idle;
		elsif CLK'EVENT and CLK = '1' then
			state <= nextState;
		end if;
end process ACTUALIZEAZÃ_STARE;				

Transition: process (state, Overflow1, Overflow2, SenzOm, enable)
	begin
		case state is
			when idle =>
				SenzUsiInchise <= '0';
				if enable = '1' then
					nextState <= deschideUsi;
				else
					nextState <= idle;
				end if;
			when DeschideUsi =>
				SenzUsiInchise <= '0';
				resetCounter2 <= '1';
                if Overflow2 = '1' then
            		nextState <= staiDeschis;
                    resetCounter2 <= '0';
				else
					nextState <= deschideUsi;
				end if;
			
			when StaiDeschis =>
				SenzUsiInchise <= '0';
				resetCounter1 <= '1';
				if Overflow1 = '1' then
					nextState <= verifica;
					resetCounter1 <= '0';
				else
					nextState <= staiDeschis;
				end if;
			
			when verifica =>
				SenzUsiInchise <= '0';
				if SenzOm = '1' then
					nextState <= StaiDeschis;
				else
					nextState <= InchideUsi;
				end if;
			
			when inchideUsi =>
				SenzUsiInchise <= '0';
				if senzOm = '1' then
					nextState <= deschideUsi;
					resetCounter2 <= '0';
				else
					resetCounter2 <= '1';
	                if(Overflow2 = '1') then
	            		nextState <= idle;
	                    resetCounter2 <= '0';
						SenzUsiInchise <= '1';
					else
						nextState <= inchideUsi;
					end if;
				end if;
			
			
				
		
		end case;
end process transition;

operation: process(CLK)
begin
	if CLK'EVENT and CLK = '1' then
		if(enable = '1') then
			
		end if;
	
	
	end if;

end process operation;

			
			
end arh;