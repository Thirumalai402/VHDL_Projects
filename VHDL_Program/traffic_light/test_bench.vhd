LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

 
ENTITY trafficlight IS
END trafficlight;
 
ARCHITECTURE behavior OF trafficlight IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT traffic_light
	 generic (
            clk_freq     : natural := 50000000;
            green_time   : natural := 5;  
            yellow_time  : natural := 2
        );
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         north_red : OUT  std_logic;
         north_yellow : OUT  std_logic;
         north_green : OUT  std_logic;
         south_red : OUT  std_logic;
         south_yellow : OUT  std_logic;
         south_green : OUT  std_logic;
         east_red : OUT  std_logic;
         east_yellow : OUT  std_logic;
         east_green : OUT  std_logic;
         west_red : OUT  std_logic;
         west_yellow : OUT  std_logic;
         west_green : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal north_red : std_logic;
   signal north_yellow : std_logic;
   signal north_green : std_logic;
   signal south_red : std_logic;
   signal south_yellow : std_logic;
   signal south_green : std_logic;
   signal east_red : std_logic;
   signal east_yellow : std_logic;
   signal east_green : std_logic;
   signal west_red : std_logic;
   signal west_yellow : std_logic;
   signal west_green : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: traffic_light PORT MAP (
          clk => clk,
          rst => rst,
          north_red => north_red,
          north_yellow => north_yellow,
          north_green => north_green,
          south_red => south_red,
          south_yellow => south_yellow,
          south_green => south_green,
          east_red => east_red,
          east_yellow => east_yellow,
          east_green => east_green,
          west_red => west_red,
          west_yellow => west_yellow,
          west_green => west_green
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
rst<='0';    
	 wait for 30 ns;	
	 rst <='1';
	 wait for 2000 ns;


      wait;
   end process;

END;
