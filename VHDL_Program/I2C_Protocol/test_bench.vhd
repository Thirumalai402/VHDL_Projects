LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
ENTITY I2C_proto IS
END I2C_proto;
 
ARCHITECTURE behavior OF I2C_proto IS 
 
    -- Component Declaration 
    COMPONENT I2C_protocol
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         start_bit : IN  std_logic;
         rw : IN  std_logic;
         slave_addr : IN  std_logic_vector(6 downto 0);
         data_write : IN  std_logic_vector(7 downto 0);
         scl_line : INOUT  std_logic;
         sda_line : INOUT  std_logic;
         data_read : OUT  std_logic_vector(7 downto 0);
         busy : OUT  std_logic;
         ack_err : OUT  std_logic;
         slave_reg_data : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal start_bit : std_logic := '0';
   signal rw : std_logic := '0';
   signal slave_addr : std_logic_vector(6 downto 0) := (others => '0');
   signal data_write : std_logic_vector(7 downto 0) := (others => '0');

   signal scl_line : std_logic;
   signal sda_line : std_logic;

 	--Outputs
   signal data_read : std_logic_vector(7 downto 0);
   signal busy : std_logic;
   signal ack_err : std_logic;
   signal slave_reg_data : std_logic_vector(7 downto 0);

   -- Clock period 
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate 
   uut: I2C_protocol PORT MAP (
          clk => clk,
          rst => rst,
          start_bit => start_bit,
          rw => rw,
          slave_addr => slave_addr,
          data_write => data_write,
          scl_line => scl_line,
          sda_line => sda_line,
          data_read => data_read,
          busy => busy,
          ack_err => ack_err,
          slave_reg_data => slave_reg_data
        );

   -- Clock process 
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
        rst <= '0';
        wait for 100 ns;
        rst <= '1';
        wait for 100 ns;
 
        rw <= '0';                 
        data_write <= "11001100";
        start_bit <= '1';
        wait for clk_period*5;
        start_bit <= '0';
        wait until busy = '0';      
        wait for 200 ns;

        rw <= '1';                  
        start_bit <= '1';
        wait for clk_period*5;
        start_bit <= '0';

        wait until busy = '0';
        wait for 200 ns;

      wait;
   end process;

END;
