library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tbdSPISlave is
	port(
		iClk         : in  std_ulogic; -- DE1-SoC: CLOCK_50
    	inRstAsync   : in  std_ulogic; -- DE1-Soc: SW[9]
    	
    	HEX0         : out std_ulogic_vector(6 downto 0);
	    HEX1         : out std_ulogic_vector(6 downto 0);
	    
	  	iSPIClk : in std_ulogic;
	  	iSPIMOSI: in std_ulogic;
	  	inSS	: in std_ulogic;
	  	oSPIMISO: out std_ulogic
	);
end entity tbdSPISlave;

architecture RTL of tbdSPISlave is
	constant cWordLen : natural := 8;
	
	signal oLastData : std_ulogic_vector(cWordLen-1 downto 0);
	
	
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
		
	SevSegDecode1 : entity work.Hex2SevSeg
		generic map(
			gInvertOutputs => false
		)
		port map(
			iHexValue => oLastData(7 downto 4),
			o7SegCode => HEX1
		);
		
	SevSegDecode2 : entity work.Hex2SevSeg
		generic map(
			gInvertOutputs => false
		)
		port map(
			iHexValue => oLastData(3 downto 0),
			o7SegCode => HEX0
		);
end architecture RTL;
