library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2c_protocol is
    Port (
        clk : in  STD_LOGIC;
        rst : in  STD_LOGIC;
        start_bit : in  STD_LOGIC;
        rw : in  STD_LOGIC;
        slave_addr : in  STD_LOGIC_VECTOR (6 downto 0);
        data_write : in  STD_LOGIC_VECTOR (7 downto 0);
        scl_line : inout std_logic;       
        sda_line : inout std_logic;      
        data_read : out STD_LOGIC_VECTOR (7 downto 0);
        busy : out STD_LOGIC;
        ack_err : out STD_LOGIC;
        slave_reg_data : out STD_LOGIC_VECTOR (7 downto 0)
    );
end i2c_protocol;

architecture Behavioral of i2c_protocol is

-- open drain for internal
    signal scl_in : std_logic := '1';    
    signal scl_drive_m : std_logic := '1';    
    signal sda_drive_m : std_logic := '1';    
    signal sda_drive_s : std_logic := '1';    
    constant clk_div : integer := 10; 
    signal clk_count : integer range 0 to clk_div := 0;

--master
    type mstate_t is (idle, start, address, address_ack, data, data_ack, read_data, read_ack, stop, done);
    signal mstate : mstate_t := idle;
    signal bit_count_m : integer range 0 to 7 := 7;
    signal shift_reg_m : std_logic_vector(7 downto 0) := (others => '0');
    signal addr_bits_m : std_logic_vector(7 downto 0) := (others => '0');
    signal rw_reg_m : std_logic := '0';
    signal busy_i : std_logic := '0';

--slave
    type sstate_t is (idle, wait_address, recv_byte, send_ack, send_byte, done);
    signal sstate : sstate_t := idle;
    signal bit_count_s : integer range 0 to 7 := 7;
    signal shift_reg_s : std_logic_vector(7 downto 0) := (others => '0');
    signal slave_reg: std_logic_vector(7 downto 0) := "10101010";
    
    begin
-- open drain op
    scl_line <= '0' when (scl_drive_m = '0' or (busy_i = '1' and scl_in = '0')) else 'Z';
    sda_line <= '0' when (sda_drive_m = '0' or sda_drive_s = '0') else 'Z';
    busy <= busy_i;
    slave_reg_data <= slave_reg;

--scl
    process(clk, rst)
    begin
    if rst = '0' then
       clk_count <= 0;
       scl_in <= '1';
    elsif rising_edge(clk) then
       if clk_count = clk_div then
            clk_count <= 0;
            scl_in <= not scl_in;
       else
           clk_count <= clk_count + 1;
         end if;
       end if;
   end process;

--master
    process(clk, rst)
    begin
        if rst='0' then
            mstate <= idle;
            sda_drive_m <= '1';
            scl_drive_m <= '1';
            busy_i <= '0';
            ack_err <= '0';
        elsif rising_edge(clk) then
            if scl_in='0' then     
         case mstate is
         when idle =>
         busy_i <= '0';
         sda_drive_m <= '1'; 
         if start_bit='1' then
         busy_i <= '1';
         rw_reg_m <= rw;
         addr_bits_m <= slave_addr & rw;
         mstate <= start;
         end if;
         
         when start =>
         sda_drive_m <= '0';      
         mstate <= address;
         
         when address =>
         sda_drive_m <= addr_bits_m(bit_count_m);
         if bit_count_m = 0 then
         bit_count_m <= 7;
         mstate <= address_ack;
         else
         bit_count_m <= bit_count_m - 1;
         end if;
         
         when address_ack =>
         sda_drive_m <= '1';  
         if sda_line='1' then
         ack_err <= '1';
         mstate <= stop;
         else
         if rw_reg_m='0' then
         shift_reg_m <= data_write;
         mstate <= data;
         else
         mstate <= read_data;
         end if;
         end if;
                   
         when data =>
         sda_drive_m <= shift_reg_m(bit_count_m);
         if bit_count_m=0 then
         mstate <= stop;
         else
         bit_count_m <= bit_count_m - 1;
         end if;
         
         when read_data =>
         sda_drive_m <= '1';
         shift_reg_m(bit_count_m) <= sda_line;
         if bit_count_m = 0 then
         data_read <= shift_reg_m;
         mstate <= read_ack;
         else
         bit_count_m <= bit_count_m - 1;
         end if;
         when read_ack =>
         sda_drive_m <= '0';
         mstate <= stop;
                    
         when stop =>
         sda_drive_m <= '1';
         mstate <= done;
         when done =>
         busy_i <= '0';
         mstate <= idle;
                    
         when others => mstate <= idle;
          end case;
        end if;
      end if;
   end process;

--slave
    process(clk, rst)
    begin
        if rst='0' then
            sstate <= idle;
            sda_drive_s <= '1';
        elsif rising_edge(clk) then
            case sstate is
            
            when idle =>
            sda_drive_s <= '1';
            if scl_in='1' and sda_line='0' then
            sstate <= wait_address;
            bit_count_s <= 7;
            end if;
                
            when wait_address =>
            if scl_in='1' then
            shift_reg_s(bit_count_s) <= sda_line;
            if bit_count_s=0 then
            if shift_reg_s(7 downto 1) = slave_addr then
            sda_drive_s <= '0'; 
            if shift_reg_s(0)='0' then
            sstate <= recv_byte;
            else
            shift_reg_s <= slave_reg;
            sstate <= send_byte;
            end if;
            bit_count_s <= 7;
            else
            sstate <= idle;
            end if;
            else
            bit_count_s <= bit_count_s - 1;
            end if;
            end if;
             
            when others => sstate <= idle;
          end case;
       end if;
    end process;
end Behavioral;
