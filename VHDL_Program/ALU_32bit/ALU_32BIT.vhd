library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity alu_32bit is
    Port ( a : in  STD_LOGIC_VECTOR (31 downto 0);
           b : in  STD_LOGIC_VECTOR (31 downto 0);
           op_code : in  STD_LOGIC_VECTOR (3 downto 0);
           result : out  STD_LOGIC_VECTOR (31 downto 0);
			  Zero   : out std_logic);

end alu_32bit;

architecture Behavioral of alu_32bit is
begin
process(a, b, op_code)
variable x : signed(31 downto 0);
variable y : signed(31 downto 0);
variable z : signed(31 downto 0);
begin
x:= signed(a);
y:= signed(b);
z:=(others => '0');
case op_code is
--add
when "0000" =>
z:= x+y;
--sub
when "0001" =>
z:= x-y;
-- HERE THE MULTIPLICATION IS NOT POSSIBLE BECAUSE OF OUTPUT IS 32 BIT IF WE CHANGE 64 BIT ITS POSSIBLE
--when "0010" =>
--z:= x*y;
--division
when "0011" =>
if (y /= 0) then
z:= x/y;
else
z:= (others => '0');
end if;
--shift left
when "0100" =>
z:= signed(shift_left(unsigned(x), to_integer(unsigned(y(4 downto 0)))));
--shift right
when "0101" =>
z:= signed(shift_right(unsigned(x), to_integer(unsigned(y(4 downto 0)))));
--rotate left
when "0110" =>
z:= signed(a(30 downto 0)& a(31));
--rotate right
when "0111" =>
z:= signed (a(0)& a(31 downto 1));
-- and
when "1000" =>
z:= signed (x and y);
-- or
when "1001" =>
z:= signed (x or y);
-- xor
when "1010" =>
z:= signed (x xor y);
-- nand
when "1011" =>
z:= signed (x nand y);
-- nor
when "1100" =>
z:= signed (x nor y);
-- xnor
when "1101" =>
z:= signed (x xnor y);
-- greater operation
when "1110" =>
if (x>y) then 
z:= to_signed(1,32);
else
z:= to_signed(0,32);
end if;
-- equal operation
when "1111" =>
if(x=y) then 
z:= to_signed(1,32);
else
z:= to_signed (0,32);
end if;
-- default due to case statements
when others =>
z:= (others => '0');
end case;

result <= std_logic_vector (z);
end process;
end Behavioral;

