library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vending_machine is
    Port ( inp : in  STD_LOGIC_VECTOR (1 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           outp : out  STD_LOGIC;
           change : out  STD_LOGIC_VECTOR (1 downto 0));
end vending_machine;

architecture Behavioral of vending_machine is
type state is (s0,s1,s2); 
signal prstate,nxtstate : state; 
begin 

 process(clk, rst)
    begin
        if rst = '1' then
            prstate <= s0;
        elsif rising_edge(clk) then
            prstate <= nxtstate;
        end if;
    end process;
    process (prstate, inp)
    begin 
        case prstate is 
            when s0 =>
                if (inp = "00") then 
                    nxtstate <= s0; 
                    outp <= '0'; 
                    change <= "00"; 
                elsif (inp = "01") then 
                    nxtstate <= s1; 
                    outp <= '0';
                    change <= "00"; 
						   elsif (inp = "10") then 
                    nxtstate <= s2; 
                    outp <= '0'; 
                    change <= "00"; 
                else
                    nxtstate <= s0;
                    outp <= '0';
                    change <= "00";
                end if;
					  when s1 =>
                if (inp = "00") then 
                    nxtstate <= s0; 
                    outp <= '0'; 
                    change <= "01"; 
                elsif (inp = "01") then 
                    nxtstate <= s2; 
                    outp <= '0';
                    change <= "00";
                elsif (inp = "10") then 
                    nxtstate <= s0; 
                    outp <= '1'; 
                    change <= "00"; 
                else
                    nxtstate <= s0;
                    outp <= '0';
                    change <= "00";
                end if;
 when s2 =>
                if (inp = "00") then 
                    nxtstate <= s0; 
                    outp <= '0'; 
                    change <= "10"; 
                elsif (inp = "01") then 
                    nxtstate <= s0;
                    outp <= '1'; 
                    change <= "00"; 
                elsif (inp = "10") then 
                    nxtstate <= s0; 
                    outp <= '1'; 
                    change <= "01"; 
                else
 nxtstate <= s0;
                    outp <= '0';
                    change <= "00";
                end if;

            when others =>
                nxtstate <= s0;
                outp <= '0';
                change <= "00";
        end case;
    end process;
end Behavioral;					 
						  
					 