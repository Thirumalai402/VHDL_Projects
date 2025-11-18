
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY traffiv_mealy IS
END traffiv_mealy;
 
ARCHITECTURE behavior OF traffiv_mealy IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT traffic_light_mealy
	 generic(
	  clk_freq: natural := 5;
     green_time : natural := 10;
     yellow_time : natural := 3
    );
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         north_green : OUT  std_logic;
         north_red : OUT  std_logic;
         north_yellow : OUT  std_logic;
         south_green : OUT  std_logic;
         south_yellow : OUT  std_logic;
         south_red : OUT  std_logic;
         east_green : OUT  std_logic;
         east_yellow : OUT  std_logic;
         east_red : OUT  std_logic;
         west_green : OUT  std_logic;
         west_yellow : OUT  std_logic;
         west_red : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal north_green : std_logic;
   signal north_red : std_logic;
   signal north_yellow : std_logic;
   signal south_green : std_logic;
   signal south_yellow : std_logic;
   signal south_red : std_logic;
   signal east_green : std_logic;
   signal east_yellow : std_logic;
   signal east_red : std_logic;
   signal west_green : std_logic;
   signal west_yellow : std_logic;
   signal west_red : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: traffic_light_mealy PORT MAP (
          clk => clk,
          rst => rst,
          north_green => north_green,
          north_red => north_red,
          north_yellow => north_yellow,
          south_green => south_green,
          south_yellow => south_yellow,
          south_red => south_red,
          east_green => east_green,
          east_yellow => east_yellow,
          east_red => east_red,
          west_green => west_green,
          west_yellow => west_yellow,
          west_red => west_red
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
     
	  rst <= '0';
wait for 50ns;
rst <= '1';
wait for 10ns;
wait for 5000ns;

      -- insert stimulus here 

      wait;
   end process;

END;
