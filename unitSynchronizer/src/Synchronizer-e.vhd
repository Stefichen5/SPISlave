library ieee;
use ieee.std_logic_1164.all;

entity Synchronizer is
  generic (
    gRange        : natural := 1;
    gResetValue   : std_ulogic := '0'
    );
  port (
    iClk          : in  std_ulogic;
    inRstAsync    : in  std_ulogic;
    iD            : in  std_ulogic_vector(gRange-1 downto 0);
    oQ            : out std_ulogic_vector(gRange-1 downto 0)
    );
end;
