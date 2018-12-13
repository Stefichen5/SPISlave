library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tbdSPISlave is
	port(
		iClk         : in  std_ulogic; -- DE1-SoC: CLOCK_50
    	inRstAsync   : in  std_ulogic; -- DE1-Soc: SW[9]
    	
    	HEX0         : out std_ulogic_vector(6 downto 0);
	    HEX1         : out std_ulogic_vector(6 downto 0);
	    LEDR		 : out std_ulogic_vector(7 downto 0);
	    
	  	iSPIClk : in std_ulogic;
	  	iSPIMOSI: in std_ulogic;
	  	inSS	: in std_ulogic;
	  	oSPIMISO: out std_ulogic
	);
end entity tbdSPISlave;

architecture RTL of tbdSPISlave is
	constant cWordLen : natural := 8;
	
	signal oLastData : std_ulogic_vector(cWordLen-1 downto 0);
	
	signal toSync, synced : std_ulogic_vector (3 downto 0);
begin
	UUT : entity work.SPISlave
		generic map(
			gWordLen => cWordLen
		)
		port map(
			iClk       => iClk,
			inRstAsync => inRstAsync,
			iSPIClk    => synced(0),
			iSPIMOSI   => synced(1),
			inSS       => synced(2),
			oSPIMISO   => oSPIMISO,
			oLastData  => oLastData
		);
		
		toSync(0) <= iSPIClk;
		toSync(1) <= iSPIMOSI;
		toSync(2) <= inSS;
		
		LEDR <= oLastData;
	
	Sync1 : entity work.Synchronizer
		generic map(
			gRange      => 3,
			gResetValue => '0'
		)
		port map(
			iClk       => iClk,
			inRstAsync => inRstAsync,
			iD         => toSync,
			oQ         => synced
		);
		
	SevSegDecode1 : entity work.Hex2SevSeg
		generic map(
			gInvertOutputs => true
		)
		port map(
			iHexValue => oLastData(7 downto 4),
			o7SegCode => HEX1
		);
		
	SevSegDecode2 : entity work.Hex2SevSeg
		generic map(
			gInvertOutputs => true
		)
		port map(
			iHexValue => oLastData(3 downto 0),
			o7SegCode => HEX0
		);
end architecture RTL;
