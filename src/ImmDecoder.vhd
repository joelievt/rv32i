library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ImmDecoder is
    port
    (
        instruction : in  std_logic_vector(31 downto 0); --! RV32I instruction
        immediate   : out std_logic_vector(31 downto 0)  --! zero/sign extended 32 bits immediate
    );
end ImmDecoder;

architecture Behavioral of ImmDecoder is
    type t_instr_type is (TYPE_R, TYPE_I, TYPE_S, TYPE_B, TYPE_U, TYPE_J, TYPE_UNK);
    signal instr_type : t_instr_type;

    signal opcode     : std_logic_vector(6 downto 0);

    -- Extracted raw immediates
    signal imm_i      : std_logic_vector(11 downto 0);
    signal imm_s      : std_logic_vector(11 downto 0);
    signal imm_b      : std_logic_vector(12 downto 0);
    signal imm_u      : std_logic_vector(31 downto 0);
    signal imm_j      : std_logic_vector(20 downto 0);

    -- Sign-extended immediates
    signal imm_i_se   : std_logic_vector(31 downto 0);
    signal imm_s_se   : std_logic_vector(31 downto 0);
    signal imm_b_se   : std_logic_vector(31 downto 0);
    signal imm_j_se   : std_logic_vector(31 downto 0);

begin
    opcode <= instruction(6 downto 0);

    -- Determine the instruction type based on the opcode
    with opcode select
        instr_type <= TYPE_R   when "0110011",
                      TYPE_I   when "0000011" | "0010011" | "1100111",
                      TYPE_S   when "0100011",
                      TYPE_B   when "1100011",
                      TYPE_U   when "0110111",
                      TYPE_J   when "1101111",
                      TYPE_UNK when others;

    -- Extract immediate fields based on RISC-V instruction format
    imm_i <= instruction(31 downto 20);
    imm_s <= instruction(31 downto 25) & instruction(11 downto 7);
    imm_b <= instruction(31) & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0';
    imm_u <= instruction(31 downto 12) & "000000000000";
    imm_j <= instruction(31) & instruction(19 downto 12) & instruction(20) & instruction(30 downto 21) & '0';

    -- Sign-extension of required immediates to 32 bits
    imm_i_se <= std_logic_vector(resize(signed(imm_i), 32));
    imm_s_se <= std_logic_vector(resize(signed(imm_s), 32));
    imm_b_se <= std_logic_vector(resize(signed(imm_b), 32));
    imm_j_se <= std_logic_vector(resize(signed(imm_j), 32));

    with instr_type select
        immediate <= (others => '0') when TYPE_R | TYPE_UNK,
                     imm_i_se        when TYPE_I,
                     imm_s_se        when TYPE_S,
                     imm_b_se        when TYPE_B,
                     imm_u           when TYPE_U,
                     imm_j_se        when TYPE_J;

end Behavioral;
