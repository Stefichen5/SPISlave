library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity tbSPISlave is
end entity tbSPISlave;

architecture Bhv of tbSPISlave is
	constant cClkTime : time := 5 ns;
	constant cSPIClkTime : time := 20 ns;
	constant cSimTime : time := 100 ns;
	constant cWordLen : natural := 8;
	
	signal iClk, inRstAsync : std_ulogic := '0';
	signal iSPIClk, iSPIMOSI, inSS : std_ulogic := '0';
	signal oSPIMISO : std_ulogic;
	signal oLastData : std_ulogic_vector(cWordLen-1 downto 0);
	signal SPIClkEn : std_ulogic := '0';
begin

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

	Stimul : process is
	begin
		wait for 2* cClkTime;
		inRstAsync <= '1';
		wait for cSimTime;
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
