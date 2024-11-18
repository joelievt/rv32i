library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity Alu_tb is
end Alu_tb;

architecture Behavioral of Alu_tb is
    component Alu
        port (
            i_a      : in  std_logic_vector(31 downto 0);
            i_b      : in  std_logic_vector(31 downto 0);
            i_alu_op : in  std_logic_vector( 3 downto 0);
            o_c      : out std_logic_vector(31 downto 0);
            o_zero   : out std_logic
        );
    end component;
    
    -- Test signals
    signal i_a      : std_logic_vector(31 downto 0) := (others => '0');
    signal i_b      : std_logic_vector(31 downto 0) := (others => '0');
    signal i_alu_op : std_logic_vector( 3 downto 0) := (others => '0');
    signal o_c      : std_logic_vector(31 downto 0);
    signal o_zero   : std_logic;
    
    function slv_to_binary_string(slv : std_logic_vector) return string is
        variable result : string(1 to slv'length);
    begin
        for i in slv'range loop
            result(slv'length - i) := character'value(std_ulogic'image(slv(i)));
        end loop;
        return result;
    end function;


begin
    uut: Alu
        port map (
            i_a      => i_a,
            i_b      => i_b,
            i_alu_op => i_alu_op,
            o_c      => o_c,
            o_zero   => o_zero
        );

    process
    begin
        -- Test ADD operation
        i_a <= std_logic_vector(to_signed(1234, 32));
        i_b <= std_logic_vector(to_signed(8765, 32));
        i_alu_op <= "0000";  -- OP_ADD
        wait for 10 ns;
        report integer'image(to_integer(signed(i_a))) & " + "
             & integer'image(to_integer(signed(i_b))) & " = "
             & integer'image(to_integer(signed(o_c)));
        
        i_a <= std_logic_vector(to_signed( 9999, 32));
        i_b <= std_logic_vector(to_signed(-8765, 32));
        i_alu_op <= "0000";  -- OP_ADD
        wait for 10 ns;
        report integer'image(to_integer(signed(i_a))) & " + "
             & integer'image(to_integer(signed(i_b))) & " = "
             & integer'image(to_integer(signed(o_c)));
        
        -- Test SUB operation
        i_a <= std_logic_vector(to_signed(9999, 32));
        i_b <= std_logic_vector(to_signed(8765, 32));
        i_alu_op <= "0001";  -- OP_SUB
        wait for 10 ns;
        report integer'image(to_integer(signed(i_a))) & " - "
             & integer'image(to_integer(signed(i_b))) & " = "
             & integer'image(to_integer(signed(o_c)));
        
        i_a <= std_logic_vector(to_signed( 1234, 32));
        i_b <= std_logic_vector(to_signed(-8765, 32));
        i_alu_op <= "0001";  -- OP_SUB
        wait for 10 ns;
        report integer'image(to_integer(signed(i_a))) & " - "
             & integer'image(to_integer(signed(i_b))) & " = "
             & integer'image(to_integer(signed(o_c)));
        
        -- Test AND operation
        i_a <= "01001100011100001111000001111100";
        i_b <= "00000011111100000111110000111100";
        i_alu_op <= "0010";
        wait for 10 ns;
        report slv_to_binary_string(i_a) & " and " & character'VAL(10) & "      "
             & slv_to_binary_string(i_b) & " = "   & character'VAL(10) & "      "
             & slv_to_binary_string(o_c);
        
        -- Test OR operation
        i_a <= "01001100011100001111000001111100";
        i_b <= "00000011111100000111110000111100";
        i_alu_op <= "0011";
        wait for 10 ns;
        report slv_to_binary_string(i_a) & " or " & character'VAL(10) & "      "
             & slv_to_binary_string(i_b) & " = "  & character'VAL(10) & "      "
             & slv_to_binary_string(o_c);
        
        -- Test SRL operation
        i_a <= "11001100011100001111000001111100";
        i_b <= std_logic_vector(to_signed(5, 32));
        i_alu_op <= "0100";
        wait for 10 ns;
        report slv_to_binary_string(i_a) & " >> "
             & integer'image(to_integer(signed(i_b))) & " = " & character'VAL(10) & "      "
             & slv_to_binary_string(o_c);
        
        -- Test SLL operation
        i_a <= "11001100011100001111000001111100";
        i_b <= std_logic_vector(to_signed(5, 32));
        i_alu_op <= "0101";
        wait for 10 ns;
        report slv_to_binary_string(i_a) & " << "
             & integer'image(to_integer(signed(i_b))) & " = " & character'VAL(10) & "      "
             & slv_to_binary_string(o_c);
        
        -- Test SRA operation
        i_a <= "11001100011100001111000001111100";
        i_b <= std_logic_vector(to_signed(5, 32));
        i_alu_op <= "0110";
        wait for 10 ns;
        report slv_to_binary_string(i_a) & " >>> "
             & integer'image(to_integer(signed(i_b))) & " = " & character'VAL(10) & "      "
             & slv_to_binary_string(o_c);
        
        i_a <= "01001100011100001111000001111100";
        i_b <= std_logic_vector(to_signed(5, 32));
        i_alu_op <= "0110";
        wait for 10 ns;
        report slv_to_binary_string(i_a) & " >>> "
             & integer'image(to_integer(signed(i_b))) & " = " & character'VAL(10) & "      "
             & slv_to_binary_string(o_c);
        
        -- Test XOR operation
        i_a <= "01001100011100001111000001111100";
        i_b <= "00000011111100000111110000111100";
        i_alu_op <= "0111";
        wait for 10 ns;
        report slv_to_binary_string(i_a) & " xor " & character'VAL(10) & "      "
             & slv_to_binary_string(i_b) & " = "   & character'VAL(10) & "      "
             & slv_to_binary_string(o_c);
        
        -- Test SLT operation
        i_a <= std_logic_vector(to_signed(1234, 32));
        i_b <= std_logic_vector(to_signed(8765, 32));
        i_alu_op <= "1000";  -- OP_ADD
        wait for 10 ns;
        report integer'image(to_integer(signed(i_a))) & " < "
             & integer'image(to_integer(signed(i_b))) & " ? "
             & integer'image(to_integer(signed(o_c)));
        
        i_a <= std_logic_vector(to_signed(8765, 32));
        i_b <= std_logic_vector(to_signed(1234, 32));
        i_alu_op <= "1000";  -- OP_ADD
        wait for 10 ns;
        report integer'image(to_integer(signed(i_a))) & " < "
             & integer'image(to_integer(signed(i_b))) & " ? "
             & integer'image(to_integer(signed(o_c)));
        
        i_a <= std_logic_vector(to_signed(1234, 32));
        i_b <= std_logic_vector(to_signed(-8765, 32));
        i_alu_op <= "1000";  -- OP_ADD
        wait for 10 ns;
        report integer'image(to_integer(signed(i_a))) & " < "
             & integer'image(to_integer(signed(i_b))) & " ? "
             & integer'image(to_integer(signed(o_c)));
             
        i_a <= std_logic_vector(to_signed(1234, 32));
        i_b <= std_logic_vector(to_signed(1234, 32));
        i_alu_op <= "1000";  -- OP_ADD
        wait for 10 ns;
        report integer'image(to_integer(signed(i_a))) & " < "
             & integer'image(to_integer(signed(i_b))) & " ? "
             & integer'image(to_integer(signed(o_c)));
        
 
        wait;
    end process;
end Behavioral;
