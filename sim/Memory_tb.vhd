library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory_tb is
end Memory_tb;

architecture Behavioral of Memory_tb is
    component Memory
        generic (
            ADDR_OFFSET : std_logic_vector(31 downto 0) := x"00000000";
            DEPTH       : positive                      := 16384
        );
        port (
            i_din   : in  std_logic_vector(31 downto 0);
            i_wen   : in  std_logic;
            i_addr  : in  std_logic_vector(31 downto 0);
            i_clk   : in  std_logic;
            o_dout  : out std_logic_vector(31 downto 0);
            o_valid : out std_logic
        );
    end component;

    -- Signals for DUT
    signal i_din   : std_logic_vector(31 downto 0);
    signal i_wen   : std_logic;
    signal i_addr  : std_logic_vector(31 downto 0);
    signal i_clk   : std_logic;
    signal o_dout  : std_logic_vector(31 downto 0);
    signal o_valid : std_logic;

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the DUT
    uut : Memory
    generic map(
        ADDR_OFFSET => x"00000100",
        DEPTH       => 16384
    )
    port map(
        i_din   => i_din,
        i_wen   => i_wen,
        i_addr  => i_addr,
        i_clk   => i_clk,
        o_dout  => o_dout,
        o_valid => o_valid
    );

    -- Clock generation
    clk_process : process
    begin
        i_clk <= '0';
        wait for clk_period / 2;
        i_clk <= '1';
        wait for clk_period / 2;
    end process clk_process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Initialize signals
        i_din  <= (others => '0');
        i_wen  <= '0';
        i_addr <= (others => '0');
        wait for 20 ns;

        -- Example write operation
        i_din  <= x"DEADBEEF";
        i_addr <= x"00000104";
        i_wen  <= '1';
        wait for clk_period;

        -- Disable write enable
        i_wen <= '0';
        wait for clk_period;

        -- Example read operation
        i_addr <= x"00000004";
        wait for clk_period;

        wait;
    end process stimulus_process;

end Behavioral;
