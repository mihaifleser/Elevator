library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity DETECTOR is
port (SenzGreutate: in std_logic; -- 1=>eroare
      SenzUsa: in std_logic; -- 1=>eroare
      OK: out std_logic;
      PR_USA: out std_logic;
      PR_GR: out std_logic;
      CLK: in std_logic);

end DETECTOR;

architecture arh of DETECTOR is

signal Senz:std_logic_vector (1 downto 0);

begin

Senz(1) <= SenzGreutate;
Senz(0) <= SenzUsa;
 



verificamOK: process(CLK) 
begin

if CLK'EVENT and CLK = '1' then
    case  Senz is
        when "01" => 
            OK <= '1';
        when "00" => 
            PR_USA <= '1';
            OK <= '0';
        when "11" => 
            PR_GR <= '1';
            OK <= '0';
        when others =>
            PR_USA <= '1';
            PR_GR <= '1';
            OK <= '0';
    end case;
end if;

end process verificamOK;

end arh;