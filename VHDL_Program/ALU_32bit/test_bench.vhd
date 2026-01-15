
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;
 
ENTITY alu IS
END alu;
 
ARCHITECTURE behavior OF alu IS 
 
    -- Component Declaration
    COMPONENT alu_32bit
    PORT(
         a : IN  std_logic_vector(31 downto 0);
         b : IN  std_logic_vector(31 downto 0);
         op_code : IN  std_logic_vector(3 downto 0);
         result : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Input
   signal a : std_logic_vector(31 downto 0) := (others => '0');
   signal b : std_logic_vector(31 downto 0) := (others => '0');
   signal op_code : std_logic_vector(3 downto 0) := (others => '0');

 	--Output
   signal result : std_logic_vector(31 downto 0);  
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu_32bit PORT MAP (
          a => a,
          b => b,
          op_code => op_code,
          result => result
        );

   -- Stimulus process
   stim_proc:  begin
        a <= x"00000014"; 
        b <= x"00000005";  

        for i in 0 to 15 loop
            op_code <= std_logic_vector(to_unsigned(i, 4));
            wait for 100 ns;
        end loop;

        a <= x"00000004";  
        b <= x"00000005"; 

        for i in 0 to 15 loop
            op_code <= std_logic_vector(to_unsigned(i, 4));
            wait for 100 ns;
        end loop;

        wait;
    end process;	
      	

  
END;

