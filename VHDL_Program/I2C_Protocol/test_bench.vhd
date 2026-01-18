library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity i2c_tb is
end i2c_tb;

architecture Behavioral of i2c_tb is
    component i2c_protocol
        port(
            clk : in std_logic;
            rst : in std_logic;
            start_bit : in std_logic;
            rw : in std_logic;
            slave_addr : in std_logic_vector(6 downto 0);
            data_write : in std_logic_vector(7 downto 0);
            scl_line : inout std_logic;
            sda_line : inout std_logic;
            data_read : out std_logic_vector(7 downto 0);
            busy : out std_logic;
            ack_err : out std_logic;
            slave_reg_data : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal start_bit : std_logic := '0';
    signal rw : std_logic := '0';
    signal slave_addr : std_logic_vector(6 downto 0) := "0000000";
    signal data_write : std_logic_vector(7 downto 0) := (others => '0');
    signal scl_line : std_logic;
    signal sda_line : std_logic;
    signal data_read : std_logic_vector(7 downto 0);
    signal busy : std_logic;
    signal ack_err : std_logic;
    signal slave_reg_data : std_logic_vector(7 downto 0);

    constant clk_period   : time := 10 ns;

begin
    --Open Drain
    scl_line <= 'H';
    sda_line <= 'H';

    uut: i2c_protocol port map (
        clk => clk, rst => rst, start_bit => start_bit, rw => rw,slave_addr => slave_addr, data_write => data_write,scl_line => scl_line, sda_line => sda_line,
data_read => data_read, busy => busy,ack_err => ack_err, slave_reg_data => slave_reg_data
);

    clk_process : process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    stim_proc: process
    begin		
        rst <= '0'; wait for 100 ns;
        rst <= '1'; wait for 100 ns;

        -- Write
        rw <= '0';
        data_write <= "11001100";
        start_bit <= '1';
        wait until busy = '1';
        start_bit <= '0';

        wait until busy = '0';
        wait for 200 ns;

        -- Read
        rw <= '1';
        start_bit <= '1';
        wait until busy = '1';
        start_bit <= '0';

        wait until busy = '0';
        wait for 500 ns;
        wait;
    end process;
end Behavioral;
