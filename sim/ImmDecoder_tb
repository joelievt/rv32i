library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ImmDecoder_tb is
end ImmDecoder_tb;

architecture Behavioral of ImmDecoder_tb is
    component ImmDecoder
        port
        (
            instruction : in  std_logic_vector(31 downto 0);
            immediate   : out std_logic_vector(31 downto 0)
        );
    end component;

    signal instruction : std_logic_vector(31 downto 0);
    signal immediate   : std_logic_vector(31 downto 0);

    signal done : std_logic := '0';

begin
    uut : ImmDecoder
    port map
    (
        instruction => instruction,
        immediate   => immediate
    );

    process
        variable expected_immediate : std_logic_vector(31 downto 0);
        variable instr_type_str     : string(1 to 6);

        procedure test_case(
            instr    : in std_logic_vector(31 downto 0);
            expected : in std_logic_vector(31 downto 0)
        ) is
        begin
            instruction <= instr;
            wait for 10 ns;

            case instr(6 downto 0) is
                when "0110011"                         => instr_type_str := "TYPE_R";
                when "0000011" | "0010011" | "1100111" => instr_type_str := "TYPE_I";
                when "0100011"                         => instr_type_str := "TYPE_S";
                when "1100011"                         => instr_type_str := "TYPE_B";
                when "0110111"                         => instr_type_str := "TYPE_U";
                when "1101111"                         => instr_type_str := "TYPE_J";
                when others                            => instr_type_str := "TYPE_X";
            end case;

            report "Instruction Type: " & instr_type_str &
                ", Instruction: " & to_hstring(instr) &
                ", Expected Immediate: " & to_hstring(expected) &
                ", Obtained Immediate: " & to_hstring(immediate);

            assert immediate = expected
                report "Mismatch in immediate value!"
                severity error;
        end procedure;

    begin
        -- Test cases for different instruction types

        -- R-type
        test_case("00000000000000000000000000110011", x"00000000");

        -- I-type
        test_case("10101011110000000000000010010011", x"FFFFFABC");

        -- S-type
        test_case("01000001011000000110000000100011", x"00000400");

        -- B-type
        test_case("10000010100000000100000001100011", x"FFFFF020");

        -- U-type
        test_case("00010010001101000101000010110111", x"12345000");

        -- J-type
        test_case("10000000110100101111000011101111", x"FFF2F80C");

        -- End of test
        done <= '1';
        wait;
    end process;

    process
    begin
        wait until done = '1';
        report "All test cases completed.";
        wait;
    end process;

end Behavioral;
