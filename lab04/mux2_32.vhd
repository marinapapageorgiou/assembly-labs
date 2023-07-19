library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity mux2_32 is
	port(
		d0 : in  std_logic_vector(31 downto 0);
		d1 : in  std_logic_vector(31 downto 0);
		s  : in  std_logic;
		y  : out std_logic_vector(31 downto 0)
	);
end entity mux2_32;


architecture RTL of mux2_32 is
begin
	with s select y <=
		d1 after 5 ns when '1',
		d0 after 5 ns when '0',
		(others => 'X') when others;
end architecture RTL;
