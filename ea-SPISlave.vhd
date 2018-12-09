-- A simple SPI receiver that does MSB
-- -> the 1st received bit is 'HIGH
-- -> the last received bit is 'LOW

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SPISlave is
	generic (gWordLen : natural);
	port(
		iClk : in std_ulogic;
		inRstAsync : in std_ulogic;
		iSPIClk : in std_ulogic;
		iSPIMOSI : in std_ulogic;
		inSS : in std_ulogic;
		
		oSPIMISO : out std_ulogic;
		oLastData : out std_ulogic_vector(gWordLen-1 downto 0)
	);
end entity SPISlave;

architecture RTL of SPISlave is
	type state_type is (WaitForData, WaitForClkLow);

	type tInternalData is record
		receivedData: std_ulogic_vector(gWordLen-1 downto 0);
		outputData : std_ulogic_vector(gWordLen-1 downto 0);
		currentBit : std_ulogic_vector(gWordLen-1 downto 0);
	end record;

	constant cDataDefault : tInternalData := (
		receivedData => (others=>'0'),
		outputData => (others=>'0'),
		currentBit => std_ulogic_vector(to_unsigned(gWordLen-1,gWordLen))
	);
	
	constant cOnes : std_ulogic_vector (gWordlen-1 downto 0) := (others=>'1');

	signal state, nextState : state_type;
	signal Data, DataNext : tInternalData;
begin

	process(iClk, inRstAsync) is
	begin
		if inRstAsync = '0' then
			state <= WaitForData;
			Data <= cDataDefault;
		elsif rising_edge(iClk) then
			state <= nextState;
			Data <= DataNext;
		end if;
	end process;

	FSM: process (all) is
	begin
		nextState <= state;
		DataNext <= Data;
		--only do if CS is active (lowactive)
		if (inSS = '0') then
			case state is
					when WaitForData =>
						if (iSPIClk) then
							--save the received bit
							DataNext.receivedData(to_integer(unsigned(Data.currentBit))) <= iSPIMOSI;
							--move our pointer by one bit
							DataNext.currentBit <= (std_ulogic_vector(unsigned(Data.currentBit) - to_unsigned(1,Data.currentBit'LENGTH)));
							nextState <= WaitForClkLow;
						end if;
					when WaitForClkLow =>
						if (NOT iSPIClk) then
							--if our received data is complete, print it out and start next one
							if(Data.currentBit = cOnes) then
								DataNext.currentBit <= std_ulogic_vector(to_unsigned(gWordLen-1,DataNext.currentBit'LENGTH));
								DataNext.outputData <= Data.receivedData;
								Datanext.receivedData <= (others=>'0');
							end if;
							
							nextState <= WaitForData;
						end if;
				end case;
		end if;
	end process;

	oLastData <= Data.outputData;
	oSPIMISO <= '0';

end architecture RTL;
