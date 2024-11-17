library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RegisterFile_tb is
end RegisterFile_tb;

architecture Behavioral of RegisterFile_tb is
    -- Component declaration for the RegisterFile entity
    component RegisterFile
        port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            i_rs1_addr : in  std_logic_vector(4 downto 0);
            i_rs2_addr : in  std_logic_vector(4 downto 0);
            i_rd_addr  : in  std_logic_vector(4 downto 0);
            i_rd_data  : in  std_logic_vector(31 downto 0);
            i_rd_we    : in  std_logic;
            o_rs1_data : out std_logic_vector(31 downto 0);
            o_rs2_data : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Signals to connect to the RegisterFile instance
    signal clk        : std_logic := '0';
    signal reset      : std_logic := '0';
    signal i_rs1_addr : std_logic_vector(4 downto 0) := (others => '0');
    signal i_rs2_addr : std_logic_vector(4 downto 0) := (others => '0');
    signal i_rd_addr  : std_logic_vector(4 downto 0) := (others => '0');
    signal i_rd_data  : std_logic_vector(31 downto 0) := (others => '0');
    signal i_rd_we    : std_logic := '0';
    signal o_rs1_data : std_logic_vector(31 downto 0);
    signal o_rs2_data : std_logic_vector(31 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the RegisterFile component
    uut: RegisterFile
        port map (
            clk        => clk,
            reset      => reset,
            i_rs1_addr => i_rs1_addr,
            i_rs2_addr => i_rs2_addr,
            i_rd_addr  => i_rd_addr,
            i_rd_data  => i_rd_data,
            i_rd_we    => i_rd_we,
            o_rs1_data => o_rs1_data,
            o_rs2_data => o_rs2_data
        );

    -- Clock generation
    clk_process: process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Test process
    stim_proc: process
    begin
        -- Test Reset Functionality
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        wait for clk_period;

        -- Check if all registers are reset to 0
        i_rs1_addr <= "00000";  -- Register 0
        wait for clk_period;
        assert o_rs1_data = x"00000000" report "Register 0 is not reset properly" severity error;

        -- Test Write Operation
        i_rd_addr <= "00001";   -- Register 1
        i_rd_data <= x"DEADBEEF";  -- Test data
        i_rd_we <= '1';
        wait for clk_period;
        i_rd_we <= '0';         -- Disable write enable

        -- Read back from Register 1 to verify the write
        i_rs1_addr <= "00001";
        wait for clk_period;
        assert o_rs1_data = x"DEADBEEF" report "Write operation failed for Register 1" severity error;

        -- Verify Register 0 Write Protection
        i_rd_addr <= "00000";   -- Register 0 (should not be writable)
        i_rd_data <= x"CAFEBABE";
        i_rd_we <= '1';
        wait for clk_period;
        i_rd_we <= '0';         -- Disable write enable

        -- Read back from Register 0 (should still be 0)
        i_rs1_addr <= "00000";
        wait for clk_period;
        assert o_rs1_data = x"00000000" report "Write protection failed for Register 0" severity error;

        -- Test Multiple Reads
        i_rs1_addr <= "00001";  -- Register 1
        i_rs2_addr <= "00000";  -- Register 0
        wait for clk_period;
        assert o_rs1_data = x"DEADBEEF" report "Read operation failed for Register 1" severity error;
        assert o_rs2_data = x"00000000" report "Read operation failed for Register 0" severity error;

        -- Test Overwrite Register
        i_rd_addr <= "00001";   -- Register 1
        i_rd_data <= x"12345678";
        i_rd_we <= '1';
        wait for clk_period;
        i_rd_we <= '0';         -- Disable write enable

        -- Read back from Register 1 to verify the overwrite
        i_rs1_addr <= "00001";
        wait for clk_period;
        assert o_rs1_data = x"12345678" report "Overwrite failed for Register 1" severity error;

        -- End of simulation
        wait;
    end process;
end Behavioral;
