library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity MAIN is
	port (
	timpDeschidere : in natural range 0 to 5000;
	viteza: in integer range 1 to 3;
	PR_USA: out std_logic;
    PR_GR: out std_logic;
	SenzGreutate: in std_logic;
    SenzOm: in std_logic;
	reset, clock : in std_logic;
	butoaneUrcare: in std_logic_vector(12 downto 0);
	butoaneCoborare: in std_logic_vector(12 downto 0);
	butoaneLift: in std_logic_vector(12 downto 0));
end MAIN;

architecture arh of main is	 

signal Iu,Ic,Ia,Iok,Y,urca,coboara,enableDoors,senzUsa: std_logic;
signal etajCurent: std_logic_vector(3 downto 0);

component UC is
	port (reset, clock, Iu, Ic, Ia, Iok : in std_logic;
	Y : out std_logic;
	urca: out std_logic;
	enableDoors: out std_logic;
	coboara: out std_logic);
end component;


component Detector_miscare is
port(butoaneU: in std_logic_vector(12 downto 0);
	butoaneC: in std_logic_vector(12 downto 0);
	butoaneL: in std_logic_vector(12 downto 0);
	etajCurent: in std_logic_vector(3 downto 0);
	CLK: in std_logic;
	Iu: out std_logic;
	Ic: out std_logic;
	Ia: out std_logic);
end component;

component DETECTOR is
port (SenzGreutate: in std_logic; -- 1=>eroare
      SenzUsa: in std_logic; -- 1=>eroare
      OK: out std_logic;
      PR_USA: out std_logic;
      PR_GR: out std_logic;
      CLK: in std_logic);

end component;

component Floor_handler is
port (CLK: in std_logic;
		viteza: in integer range 1 to 3;
		RESET: in std_logic;
		etajCurent: out std_logic_vector(3 downto 0);
		urca: in std_logic;
		coboara: in std_logic);
end component;

component usi is
port( enable : in std_logic;
	reset : in std_logic;
	timpDeschidere : in natural range 0 to 5000;
	CLK : in std_logic;
	SenzOm : in std_logic;
	SenzUsiInchise : out std_logic);
end component;

begin	 

	DM: Detector_miscare port map(butoaneUrcare,butoaneCoborare,butoaneLift,etajCurent,clock,Iu,Ic,Ia);
	UnitateComanda:	UC port map (reset,clock,Iu,Ic,Ia,Iok,Y,urca,enableDoors,coboara);
	Detector_erori: DETECTOR port map(senzGreutate, SenzUsa, Iok,PR_USA,PR_GR,clock);
	FLH: Floor_handler port map(clock,viteza,reset,etajCurent,urca,coboara);
	USILE: usi port map(enableDoors,reset,timpDeschidere,clock,senzOm, senzUsa);
end arh;