library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity traffic_light is
generic (
clk_freq: natural := 10;
green_time : natural := 6;
yellow_time : natural := 3
);

    Port ( clk: in  STD_LOGIC;
           rst : in  STD_LOGIC;
           north_red,north_yellow,north_green : out  STD_LOGIC;
           south_red,south_yellow,south_green : out  STD_LOGIC;
           east_red,east_yellow,east_green : out  STD_LOGIC;
           west_red,west_yellow,west_green : out  STD_LOGIC);
end traffic_light;

architecture Behavioral of traffic_light is
constant green : unsigned(7 downto 0) := to_unsigned(10,8);
constant yellow: unsigned(7 downto 0) := to_unsigned(5,8);

type states is (northsouth_green, northsouth_yellow, eastwest_green, eastwest_yellow);
signal state,nxtstate : states;
signal count : unsigned(33 downto 0) := (others=>'0');
constant zero : unsigned(33 downto 0) := (others => '0');

begin
process(clk)
begin
if(rising_edge(clk)) then
if(rst='0') then 
state <= northsouth_green;
count <= zero;
else
state<= nxtstate;
if(nxtstate=state) then
count <= count+1;
else
count <= zero;
end if;
end if;
end if;
end process;

process(count,state)
begin
nxtstate <= state;
case state is 
when northsouth_green =>
if count >= green then
nxtstate <= northsouth_yellow;
end if;
when northsouth_yellow =>
if count>= yellow then
nxtstate <= eastwest_green;
end if;
when eastwest_green => 
if count >= green then
nxtstate <= eastwest_yellow;
end if;
when eastwest_yellow =>
if count >= yellow then
nxtstate <= northsouth_green;
end if;
when others=>
nxtstate <= northsouth_green;
end case;
end process;
 
process(state)
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
case state is
	
when northsouth_green =>
north_green <= '1';
south_green <='1';
east_red <='1';
west_red <='1';
	
when northsouth_yellow =>
north_yellow <= '1';
south_yellow <= '1';
east_red <= '1';
west_red<= '1';
	
when eastwest_green =>
north_red <='1';
south_red <='1';
east_green <='1';
west_green <='1';
	
when eastwest_yellow =>
north_red <='1';
south_red <='1';
east_yellow <='1';
west_yellow <='1';
	
when others =>
north_red <='1';
south_red <='1';
east_red <= '1';
west_red<= '1';
end case;
end process;

end Behavioral;

