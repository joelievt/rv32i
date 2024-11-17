library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
    port
    (
        clk        : in  std_logic;                     --! System clock
        reset      : in  std_logic;                     --! Reset signal to clear registers
        i_rs1_addr : in  std_logic_vector( 4 downto 0);  --! Address of source register 1 
        i_rs2_addr : in  std_logic_vector( 4 downto 0);  --! Address of source register 2
        i_rd_addr  : in  std_logic_vector( 4 downto 0);  --! Address of destination register
        i_rd_data  : in  std_logic_vector(31 downto 0); --! Data to write in destination register
        i_rd_we    : in  std_logic;                     --! Write enable to destination register
        o_rs1_data : out std_logic_vector(31 downto 0); --! Data from source register 1
        o_rs2_data : out std_logic_vector(31 downto 0)  --! Data from source register 2
    );
end RegisterFile;

architecture Behavioral of RegisterFile is
    type t_memory is array(0 to 31) of std_logic_vector(31 downto 0);
    signal memory : t_memory := (others => (others => '0'));
begin

    o_rs1_data <= memory(to_integer(unsigned(i_rs1_addr)));
    o_rs2_data <= memory(to_integer(unsigned(i_rs2_addr)));

    synchronous_write: process (clk) is
    begin
        if rising_edge(clk) then
            if reset = '1' then
                for i in 0 to 31 loop
                    memory(i) <= (others => '0');
                end loop;
            else
                if i_rd_we = '1' and i_rd_addr /= "00000" then
                    memory(to_integer(unsigned(i_rd_addr))) <= i_rd_data;
                end if;
            end if;
        end if;
    end process synchronous_write;

end Behavioral;
