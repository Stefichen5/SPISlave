library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tbSPISlave is
end entity tbSPISlave;

architecture Bhv of tbSPISlave is
	constant cClkTime : time := 2 ns;
	constant cSPIClkTime : time := 7 ns;
	constant cSimTime : time := 100 ns;
	constant cWordLen : natural := 8;
	
	signal iClk, inRstAsync : std_ulogic := '0';
	signal iSPIClk, iSPIMOSI, inSS : std_ulogic := '0';
	signal oSPIMISO : std_ulogic;
	signal oLastData : std_ulogic_vector(cWordLen-1 downto 0);
	signal SPIClkEn : std_ulogic := '0';
	signal HEX0, HEX1 : std_ulogic_vector(6 downto 0);
begin

DUT : entity work.tbdSPISlave
	port map(
		iClk       => iClk,
		inRstAsync => inRstAsync,
		HEX0       => HEX0,
		HEX1       => HEX1,
		LEDR	   => oLastData,
		iSPIClk    => iSPIClk,
		iSPIMOSI   => iSPIMOSI,
		inSS       => inSS,
		oSPIMISO   => oSPIMISO
	);

/*
	UUT : entity work.SPISlave
		generic map(
			gWordLen => cWordLen
		)
		port map(
			iClk       => iClk,
			inRstAsync => inRstAsync,
			iSPIClk    => iSPIClk,
			iSPIMOSI   => iSPIMOSI,
			inSS       => inSS,
			oSPIMISO   => oSPIMISO,
			oLastData  => oLastData
		);
*/
	Stimul : process is
	begin
		inSS <= '1';
		wait for 2* cClkTime;
		inRstAsync <= '1';
		wait for 2* cClkTime;
		
		iSPIMOSI <= '1';
		
		--1st bit
		inSS <= '0';
		wait for 5* cClkTime;
		SPIClkEn <= '1';
		wait until oLastData'EVENT;
		inSS <= '1';
		SPIClkEn <= '0';
		
		/*
		iSPIMOSI <= '1';
		wait for 5 ns;
		iSPIClk <= '1';
		
		--2nd bit
		wait until NOT iSPIClk;
		iSPIMOSI <= '0';
		
		--3rd bit
		wait until NOT iSPIClk;
		iSPIMOSI <= '1';
		
		--4th bit
		wait until NOT iSPIClk;
		iSPIMOSI <= '0';
		
		--5th bit
		wait until NOT iSPIClk;
		iSPIMOSI <= '1';
		
		--6th bit
		wait until NOT iSPIClk;
		iSPIMOSI <= '0';
		
		--7th bit
		wait until NOT iSPIClk;
		iSPIMOSI <= '1';
		
		--8th bit
		wait until NOT iSPIClk;
		iSPIMOSI <= '0';
		
		wait until oLastData'EVENT;
		 
		report "Received Data: " & Integer'IMAGE(to_integer(unsigned(oLastData)));
		assert oLastData = "10101010" report "Wrong data" severity failure;
		*/
	
		finish;
	end process;

	SPIClkGen : process is
	begin
		iSPIClk <= NOT iSPIClk when SPIClkEn;
		wait for cSPIClkTime;
	end process;

	ClkGen : process is
	begin
		iClk <= NOT iClk;
		wait for cClkTime;
	end process;

end architecture Bhv;
