library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Hex2SevSeg is
	generic (gInvertOutputs : boolean := false);
	port (iHexValue	: in  std_ulogic_vector(3 downto 0);
			o7SegCode	: out std_ulogic_vector(6 downto 0));
end entity Hex2SevSeg;

architecture RTL of Hex2SevSeg is
	-- ---------------------------------------------------------------------------
  -- Conversion HEX-Value to low active 7-segment value
  -- ---------------------------------------------------------------------------
  function ToSevSeg(cValue : std_ulogic_vector(3 downto 0))
    return std_ulogic_vector is
    variable SevSeg : std_ulogic_vector(6 downto 0);
  begin
    case cValue(3 downto 0) is
      when "0000" => SevSeg := "0111111";
      when "0001" => SevSeg := "0000110";
      when "0010" => SevSeg := "1011011";
      when "0011" => SevSeg := "1001111";
      when "0100" => SevSeg := "1100110";
      when "0101" => SevSeg := "1101101";
      when "0110" => SevSeg := "1111101";
      when "0111" => SevSeg := "0000111";
      when "1000" => SevSeg := "1111111";
      when "1001" => SevSeg := "1101111";
      when "1010" => SevSeg := "1110111";
      when "1011" => SevSeg := "1111100";
      when "1100" => SevSeg := "0111001";
      when "1101" => SevSeg := "1011110";
      when "1110" => SevSeg := "1111001";
      when "1111" => SevSeg := "1110001";
      when others => SevSeg := "XXXXXXX";
    end case;
    if (gInvertOutputs) then
      return not SevSeg;
    else
      return SevSeg;
    end if;
  end ToSevSeg;
begin
	o7SegCode  <= ToSevSeg(iHexValue);
end architecture RTL;
