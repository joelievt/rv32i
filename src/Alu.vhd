library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Alu is
    port
    (
        i_a      : in  std_logic_vector(31 downto 0); --! `A` operand
        i_b      : in  std_logic_vector(31 downto 0); --! `B` operand
        i_alu_op : in  std_logic_vector( 3 downto 0); --! Operation code (see constants)
        o_c      : out std_logic_vector(31 downto 0); --! `C` result
        o_zero   : out std_logic                      --! Result-is-zero flag
    );
end Alu;

architecture Behavioral of Alu is
    constant OP_ADD     : std_logic_vector(3 downto 0) := "0000"; --! Add operation
    constant OP_SUB     : std_logic_vector(3 downto 0) := "0001"; --! Subtract operation
    constant OP_AND     : std_logic_vector(3 downto 0) := "0010"; --! Bitwise `and` operation
    constant OP_OR      : std_logic_vector(3 downto 0) := "0011"; --! Bitwise `or` operation
    constant OP_SRL     : std_logic_vector(3 downto 0) := "0100"; --! Shift-Right-Logical operation
    constant OP_SLL     : std_logic_vector(3 downto 0) := "0101"; --! Shift-Left-Logical operaiton
    constant OP_SRA     : std_logic_vector(3 downto 0) := "0110"; --! Shift-Right-Arithmetic operation
    constant OP_XOR     : std_logic_vector(3 downto 0) := "0111"; --! Bitwise `xor` operation
    constant OP_SLT     : std_logic_vector(3 downto 0) := "1000"; --! Set-(if)-Less-Than operation

    signal a_add_b      : std_logic_vector(31 downto 0);
    signal a_sub_b      : std_logic_vector(31 downto 0);
    signal a_or_b       : std_logic_vector(31 downto 0);
    signal a_and_b      : std_logic_vector(31 downto 0);
    signal a_srl_b      : std_logic_vector(31 downto 0);
    signal a_sll_b      : std_logic_vector(31 downto 0);
    signal a_sra_b      : std_logic_vector(31 downto 0);
    signal a_xor_b      : std_logic_vector(31 downto 0);
    signal a_lt_b       : std_logic_vector(31 downto 0);

    signal w_c          : std_logic_vector(31 downto 0);

begin

    o_c <= w_c;
    with i_alu_op select
        w_c <= a_add_b         when OP_ADD,
               a_sub_b         when OP_SUB,
               a_and_b         when OP_AND,
               a_or_b          when OP_OR,
               a_srl_b         when OP_SRL,
               a_sll_b         when OP_SLL,
               a_sra_b         when OP_SRA,
               a_xor_b         when OP_XOR,
               a_lt_b          when OP_SLT,
               (others => '0') when others;

    o_zero <= '1' when to_integer(unsigned(w_C)) = 0 else
              '0';

    a_add_b <= std_logic_vector(signed(i_A) + signed(i_B));
    a_sub_b <= std_logic_vector(signed(i_A) - signed(i_B));

    a_or_b  <= i_a or  i_b;
    a_and_b <= i_a and i_b;
    a_xor_b <= i_a xor i_b;

    a_srl_b <= std_logic_vector(shift_right(unsigned(i_a), to_integer(unsigned(i_b(3 downto 0)))));
    a_sll_b <= std_logic_vector(shift_left (unsigned(i_a), to_integer(unsigned(i_b(3 downto 0)))));
    a_sra_b <= std_logic_vector(shift_right(  signed(i_a), to_integer(unsigned(i_b(3 downto 0)))));

    a_lt_b  <= x"00000001" when (signed(i_a) < signed(i_b)) else
               x"00000000";
end Behavioral;
