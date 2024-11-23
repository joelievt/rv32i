library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Memory is
    generic (
        ADDR_OFFSET : std_logic_vector(31 downto 0) := x"00000000";
        DEPTH       : positive                      := 16384 -- 64 kB
    );
    port (
        i_din   : in  std_logic_vector(31 downto 0); --! Data input
        i_wen   : in  std_logic;                     --! Write enable
        i_addr  : in  std_logic_vector(31 downto 0); --! Read/Write address
        i_clk   : in  std_logic;                     --! Clock
        o_dout  : out std_logic_vector(31 downto 0); --! Data output
        o_valid : out std_logic                      --! Valid address flag
    );
end Memory;

architecture Behavioral of Memory is
    signal internal_address : integer range 0 to DEPTH;

    type t_memarray is array (DEPTH downto 0) of std_logic_vector(31 downto 0);
    signal memarray : t_memarray := (others => (others => '0'));

    signal w_valid : std_logic;
begin

    o_valid <= w_valid;

    comb : process (i_addr)
        variable below_range : boolean;
        variable above_range : boolean;
    begin
        below_range := to_integer(unsigned(i_addr)) < to_integer(unsigned(ADDR_OFFSET));
        above_range := internal_address >= DEPTH;
        if below_range = false and above_range = false then
            w_valid <= '1';
            internal_address <= to_integer(unsigned(i_addr(31 downto 2))) - to_integer(unsigned(ADDR_OFFSET(31 downto 2)));
        else
            w_valid <= '0';
            internal_address <= 0;
        end if;
    end process comb;

    -- Asynchronous read
    o_dout <= memarray(internal_address) when w_valid = '1' else (others => '0');

    write : process (i_clk)
    begin
        if rising_edge(i_clk) then
            if i_wen = '1' and w_valid = '1' then
                memarray(internal_address) <= i_din;
            end if;
        end if;
    end process write;
end Behavioral;
