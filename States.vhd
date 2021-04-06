library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity UC is
	port (reset, clock, Iu, Ic, Ia, Iok : in std_logic;
	Y : out std_logic;
	urca: out std_logic;
	enableDoors: out std_logic;
	coboara: out std_logic);
end UC;
					
architecture A1 of UC is
type stateType is (idle, asc, stayOnFloorAsc, stayOnFloorDesc,continueAsc,desc,continueDesc);
signal state, nextState : stateType;
begin

ACTUALIZEAZÃ_STARE: process (reset, clock)
	begin
		if (reset = '1') then
			state <= idle;
		elsif CLOCK'EVENT and CLOCK = '1' then
			state <= nextState;
		end if;
end process ACTUALIZEAZÃ_STARE;	
	
TRANSITION: process(state,Iu,Ia,Ic,Iok)					 --I urcare; I coborare; I am ajuns ~~ I ok
	begin
		case state is
			when idle	=>
				enableDoors <= '0';
				report "!!!!!!!!!!!!!!!!!!!!!!!IDLE";
				urca <= '0';
				coboara <= '0';
				if Iu = '1' then
					nextState <= asc; 
				else
					if Ic = '1' then
						nextState <= desc;
					else
						nextState <= idle;
					end if;
				end if;
				
			when asc	=> 
				enableDoors <= '0';
				report "!!!!!!!!!!!!!!!!!!!!!!!!ASC";
				urca <= '1';
				coboara <= '0';
				if Ia = '1' then
					nextState <= stayOnFloorAsc;
				else
					nextState <= asc;
				end if;
			
			when stayOnFloorAsc =>
				enableDoors <= '1';
				urca <= '0';
				coboara <= '0';
				report "!!!!!!!!!!!!!!!!!!!!!!!!!!!stayOnFloorAsc";	
				if Iok = '1' then
					nextState <= continueAsc;
				else
					nextState <= stayOnFloorAsc;
				end if;
			
			when continueAsc =>
				enableDoors <= '0';
				urca <= '0';
				coboara <= '0';
				report "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!continueAsc";
				if Iu = '1' then
					nextState <= asc;
				else 
					if Ic = '1' then
						nextState <= desc;
					else
						nextState <= idle;
					end if;
				end if;
			
			when desc	=> 
				enableDoors <= '0';
				urca <= '0';
				coboara <= '1';
				report "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!DESC";
				if Ia = '1' then
					nextState <= stayOnFloorDesc;
				else
					nextState <= desc;
				end if;
			
			when stayOnFloorDesc =>
				enableDoors <= '1';
				urca <= '0';
				coboara <= '0';
				report "!!!!!!!!!!!!!!!!!!!!!!!!!!!stayOnFloorDesc";	
				if Iok = '1' then
					nextState <= continueDesc;
				else
					nextState <= stayOnFloorDesc;
				end if;
			 
			when continueDesc =>
				enableDoors <= '0';
				urca <= '0';
				coboara <= '0';
				report "!!!!!!!!!!!!!!!!!!!!!1continueDesc";
				if Ic = '1' then
					nextState <= desc;
				else
					if Iu = '1' then
						nextState <= asc;
					else
						nextState <= idle;
					end if;
				end if;
			end case;
	end process TRANSITION;
end A1;
