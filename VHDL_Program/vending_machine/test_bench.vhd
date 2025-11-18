LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY vennding IS
END vennding;
 
ARCHITECTURE behavior OF vennding IS 

 
    COMPONENT vending_machine
    PORT(
         inp : IN  std_logic_vector(1 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         outp : OUT  std_logic;
         change : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal inp : std_logic_vector(1 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal outp : std_logic;
   signal change : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: vending_machine PORT MAP (
          inp => inp,
          clk => clk,
          rst => rst,
          outp => outp,
          change => change
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
     -- Reset for 2 cycles
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 10 ns;

        -- Test Case 1: Insert 01 (say ₹1 coin)
        inp <= "01";
        wait for 20 ns;
		   -- Test Case 2: Insert 01 again (total ₹2)
        inp <= "01";
        wait for 20 ns;

        -- Test Case 3: Insert 10 (₹2 coin)
        inp <= "10";
        wait for 20 ns;

        -- Test Case 4: No input (idle)
        inp <= "00";
        wait for 20 ns;
		  -- Test Case 5: Random inputs
        inp <= "10";
        wait for 20 ns;
        inp <= "00";
        wait for 20 ns;
        inp <= "01";
        wait for 20 ns;


      wait;
   end process;

END;