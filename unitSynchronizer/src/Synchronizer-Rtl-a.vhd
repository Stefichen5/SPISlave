architecture Rtl of Synchronizer is

  -- ------------------------------------------------------
  -- copied from last semester
  -- ------------------------------------------------------
  signal preSynced, synced		:	std_ulogic_vector(iD'RANGE)	:=	(others=>'0');
begin

  -- ------------------
  -- code copied from last semester
  -- ------------------
	PreSync: process (inRstAsync,iClk)
	begin
		if inRstAsync = not('1') then
			preSynced<=(others=>'0');
		--Wait for clock
		elsif rising_edge(iClk) then
			preSynced<=iD;
		end if;
	end process PreSync;
	
	InSync: process (inRstAsync,iClk)
	begin
		if inRstAsync = not('1') then
			synced<=(others=>'0');
		--Wait for clock
		elsif rising_edge(iClk) then
			synced<=preSynced;
		end if;
	end process InSync;
	
	oQ<=synced;
end;
