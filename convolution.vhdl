LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
USE work.MyPackage.ALL;
ENTITY convolution_datapath IS
    GENERIC (
        image_size : std_logic_vector(7 downto 0) := "00000100";
        data_width : INTEGER := 8;
        kernet_1 : std_logic_vector(7 downto 0) := (others => '0');
        kernet_2 : std_logic_vector(7 downto 0) := (others => '0');
        kernet_3 : std_logic_vector(7 downto 0) := (others => '0');
        kernet_4 : std_logic_vector(7 downto 0) := (others => '0');
        kernet_5 : std_logic_vector(7 downto 0) := (others => '0');
        kernet_6 : std_logic_vector(7 downto 0) := (others => '0');
        kernet_7 : std_logic_vector(7 downto 0) := (others => '0');
        kernet_8 : std_logic_vector(7 downto 0) := (others => '0');
        kernet_9 : std_logic_vector(7 downto 0) := (others => '0')
    );
    PORT (
        SIGNAL clk, rst, en_cti, en_ctj, en_ctx, en_cty, temp_reg_en,address_reg_en, out1_reg_en, out2_reg_en, out3_reg_en, out4_reg_en  : IN STD_LOGIC;
        SIGNAL data_in : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        signal data_out1, data_out2, data_out3, data_out4 : out std_logic_vector(data_width - 1 downto 0) 
    );
END ENTITY convolution_datapath;

ARCHITECTURE modular OF convolution_datapath IS

    SIGNAL counter_i_out, counter_j_out, counter_x_out, counter_y_out, kernel_mux_out : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL counter_i_cout, counter_j_cout, counter_x_cout, counter_y_cout : STD_LOGIC;
    SIGNAL adder_mux_1_out, adder_mux_2_out, mult_mux_1_sel, mult_mux_2_sel, adr_reg_mux_out : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL mult_out, adder_out, address_reg_out, mult_mux_1_out, mult_mux_2_out, temp_reg_out : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL adder_mux_1_sel, adder_mux_2_sel, adr_reg_mux_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);

BEGIN
    counter_i : ENTITY work.counter(behavioral)
        GENERIC MAP(data_width, 3)
        PORT MAP(clk, rst, en_cti, counter_i_out, counter_i_cout);

    counter_j : ENTITY work.counter(behavioral)
        GENERIC MAP(data_width, 3)
        PORT MAP(clk, rst, en_ctj, counter_j_out, counter_j_cout);

    counter_x : ENTITY work.counter(behavioral)
        GENERIC MAP(data_width, 3)
        PORT MAP(clk, rst, en_ctx, counter_x_out, counter_x_cout);

    counter_y : ENTITY work.counter(behavioral)
        GENERIC MAP(data_width, 3)
        PORT MAP(clk, rst, en_cty, counter_y_out, counter_y_cout);

    adder_mux_1 : ENTITY work.mux(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(counter_i_out, counter_j_out, temp_reg_out, (others => 'Z'), adder_mux_1_sel, adder_mux_1_out);

    adder_mux_2 : ENTITY work.mux(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(counter_x_out, counter_y_out, mult_out, (others => 'Z'), adder_mux_2_sel, adder_mux_2_out);

    adr : ENTITY work.adder(behavioral)
        GENERIC MAP(8)
    PORT MAP(adder_mux_1_out, adder_mux_2_out, adder_out);

    mult_mux_1 : ENTITY work.mux(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(address_reg_out, kernel_mux_out, (others => 'Z'), (others => 'Z'), mult_mux_1_sel, mult_mux_1_out);

    mult_mux_2 : ENTITY work.mux(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(image_size, data_in, (others => 'Z'), (others => 'Z'), mult_mux_2_sel, mult_mux_2_out);

    adr_reg_mux : ENTITY work.mux(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(adder_out, mult_out, (others => 'Z'), (others => 'Z'), adr_reg_mux_sel, adr_reg_mux_out);

    kernel_mux1 : ENTITY work.kernel_mux(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(kernet_1, kernet_2, kernet_3, kernet_4, kernet_5, kernet_6, kernet_7, kernet_8, kernet_9, counter_i_out, counter_j_out, kernel_mux_out);

    temp_reg : ENTITY work.reg(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(
            clk, rst, temp_reg_en, adder_out, temp_reg_out);

    address_reg : ENTITY work.reg(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(
            clk, rst, address_reg_en, adr_reg_mux_out, address_reg_out);

    out1_reg : ENTITY work.reg(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(
            clk, rst, out1_reg_en, temp_reg_out, data_out1);

    out2_reg : ENTITY work.reg(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(
            clk, rst, out2_reg_en, temp_reg_out, data_out2);

    out3_reg : ENTITY work.reg(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(
            clk, rst, out3_reg_en, temp_reg_out, data_out3);

    out4_reg : ENTITY work.reg(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(
            clk, rst, out4_reg_en, temp_reg_out, data_out4);

END modular; -- modular

-- LIBRARY library IEEE;
-- USE IEEE.std_logic_1164.ALL;
-- USE IEEE.numeric_std.ALL;
-- ENTITY convolution_controller IS
--     GENERIC (

--     );
--     PORT (

--     );
-- END ENTITY convolution_controller;