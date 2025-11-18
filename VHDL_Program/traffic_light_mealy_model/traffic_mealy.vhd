
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity traffic_light_mealy is
generic (
clk_freq: natural := 1;
green_time : natural := 10;
yellow_time : natural := 3
);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           north_green,north_red,north_yellow : out  STD_LOGIC;
           south_green,south_yellow,south_red : out  STD_LOGIC;
           east_green,east_yellow,east_red : out  STD_LOGIC;
           west_green,west_yellow,west_red : out  STD_LOGIC);
end traffic_light_mealy;

architecture Behavioral of traffic_light_mealy is
constant green :unsigned(7 downto 0) := to_unsigned(green_time*clk_freq,8);
constant yellow : unsigned(7 downto 0) := to_unsigned(yellow_time*clk_freq,8);
constant pre_yellow_blink : integer := (clk_freq / 2) + 1;

type state is (north_south_green,north_south_yellow,east_west_green,east_west_yellow);
signal currstate, nxtstate : state;

signal count : unsigned(7 downto 0) := (others=>'0');
constant zero : unsigned(7 downto 0) := (others=>'0');

begin
process(clk)
begin
if(rising_edge (clk)) then
if(rst='0') then
currstate <= north_south_green;
count <= zero;
else
currstate <= nxtstate;
if( nxtstate=currstate) then
count <= count+1;
else
count <= zero;
end if;
end if;
end if;
end process;

process(currstate,count)
begin
nxtstate <= currstate;
case currstate is
when north_south_green =>
if count >= green then
nxtstate <= north_south_yellow;
end if;

when north_south_yellow =>
if count >= yellow then
nxtstate <= east_west_green;
end if;

when east_west_green =>
if count >= green then
nxtstate <= east_west_yellow;
end if;

when east_west_yellow =>
if count >= yellow then
nxtstate <= north_south_green;
end if;

when others =>
nxtstate <= north_south_green;
end case;
end process;

process (currstate,count)
begin
north_red <= '0';
north_yellow <= '0';
north_green <= '0';
south_red <= '0';
south_yellow <= '0';
south_green <= '0';
east_red <= '0';
east_yellow <= '0';
east_green <= '0';
west_red <= '0';
west_yellow <= '0';
west_green <= '0';
case currstate is

when north_south_green =>
east_red <= '1';
west_red <= '1';
north_green <= '1';
south_green <= '1';


when north_south_yellow =>
east_red <= '1';
west_red <= '1';
if (to_integer(count) mod pre_yellow_blink) < (pre_yellow_blink / 2) then
north_yellow <= '1';
south_yellow <= '1';
end if;

when east_west_green =>
north_red <= '1';
south_red <= '1';
east_green <= '1';
west_green <= '1';

when east_west_yellow =>
north_red <= '1';
south_red <= '1';
if (to_integer(count) mod pre_yellow_blink) < (pre_yellow_blink / 2) then
east_yellow <= '1';
west_yellow <= '1';
end if;
 
when others =>
north_red <= '1';
south_red <= '1';
east_red <= '1';
west_red <= '1';
end case;
end process;
end Behavioral;

