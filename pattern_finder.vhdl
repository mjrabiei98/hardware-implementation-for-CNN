LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
PACKAGE generic_array_type IS
    TYPE kernel_array IS ARRAY (0 TO 2, 0 TO 8) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    TYPE bias_array IS ARRAY (0 TO 2) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
END PACKAGE generic_array_type;
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.generic_array_type.ALL;
ENTITY patter_finder IS
    GENERIC (
        data_width : INTEGER := 8;
        number_of_conv : INTEGER := 3;
        kernel_size : INTEGER := 3;
        kernels_array : kernel_array :=
        ((
        "00000000", "00000001", "00000000",
        "00000001", "00000001", "00000001",
        "00000000", "00000001", "00000000"
        ), (
        "00000001", "00000001", "00000001",
        "00000001", "00000000", "00000000",
        "00000001", "00000001", "00000001"
        ), (
        "00000001", "00000001", "00000001",
        "00000000", "00000001", "00000000",
        "00000000", "00000001", "00000000"
        ));
        bias_arrays : bias_array := ("11111111", "11111110", "11111110");
        image_size : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000100"
    );
    PORT (
        start, clk, rst, write_ram : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        address_in_wr : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        done : OUT STD_LOGIC;
        output_pattern : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY patter_finder;

ARCHITECTURE configurable OF patter_finder IS
    SIGNAL ram_data_out : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL write_en, read_en : STD_LOGIC;
    SIGNAL address_out : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    TYPE conv_ouput IS ARRAY (0 TO number_of_conv - 1, 0 TO 3) OF STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL convs_ouput : conv_ouput;
    TYPE relu_out IS ARRAY (0 TO number_of_conv - 1, 0 TO 3) OF STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL relus_out : relu_out;
    TYPE maxpool_out IS ARRAY (0 TO number_of_conv - 1) OF STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL maxpools_out : maxpool_out;
BEGIN
    ram1 : ENTITY work.ram(behavioral)
        GENERIC MAP(8, 16)
        PORT MAP(
            rst,
            data_in,
            address_in_wr, address_out,
            write_en, read_en,
            ram_data_out
        );

    gen_circuit : FOR i IN 0 TO number_of_conv - 1 GENERATE
    BEGIN
        conv_i : ENTITY work.convolution(modular)
        GENERIC MAP(
            bias_arrays(i), image_size, 8, kernels_array(i, 0), kernels_array(i, 1), kernels_array(i, 2),
            kernels_array(i, 3), kernels_array(i, 4), kernels_array(i, 5), kernels_array(i, 6), kernels_array(i, 7), kernels_array(i, 8)
        )
        PORT MAP(
            clk, rst, start, ram_data_out, convs_ouput(i, 0), convs_ouput(i, 1), convs_ouput(i, 2), convs_ouput(i, 3), done, address_out
        );
        relui : ENTITY work.relu(behavioral)
            GENERIC MAP(8)
            PORT MAP(
                convs_ouput(i, 0), convs_ouput(i, 1), convs_ouput(i, 2), convs_ouput(i, 3),
                relus_out(i, 0), relus_out(i, 1), relus_out(i, 2), relus_out(i, 3)
            );
        maxi : ENTITY work.maxpool(behavioral)
            GENERIC MAP(8)
            PORT MAP(
                relus_out(i, 0), relus_out(i, 1), relus_out(i, 2), relus_out(i, 3), maxpools_out(i)
            );

    END GENERATE;

    res2 : ENTITY work.resualt(behavioral)
        GENERIC MAP(8)
        PORT MAP(
            maxpools_out(0), maxpools_out(1), maxpools_out(2), output_pattern
        );

END configurable; -- behavioral



-- COMPONENT conv
    --     GENERIC (
    --         bias_value : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
    --         image_size : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000100";
    --         data_width : INTEGER := 8;
    --         kernet_1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    --         kernet_2 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    --         kernet_3 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    --         kernet_4 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    --         kernet_5 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    --         kernet_6 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    --         kernet_7 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    --         kernet_8 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
    --         kernet_9 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')
    --     );
    --     PORT (
    --         SIGNAL clk, rst, start : IN STD_LOGIC;
    --         SIGNAL data_in : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    --         SIGNAL data_out1, data_out2, data_out3, data_out4 : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    --         SIGNAL done : OUT STD_LOGIC;
    --         SIGNAL address_out : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
    --     );
    -- END COMPONENT conv;


    -- after efingin component in arxhitucture body then we can configure the elements in



-- CONFIGURATION configured_pattern_finder OF patter_finder IS
--     FOR configurable
--         FOR gen_circuit
--             -- FOR conv_i :
--                 FOR ALL : conv USE ENTITY work.convolution(modular)
--                     GENERIC MAP(
--                         bias_arrays(i), image_size, 8, kernels_array(i, 0), kernels_array(i, 1), kernels_array(i, 2),
--                         kernels_array(i, 3), kernels_array(i, 4), kernels_array(i, 5), kernels_array(i, 6), kernels_array(i, 7), kernels_array(i, 8)
--                     );
--                 end for;
--             -- END FOR;
--         END FOR;
--     END FOR;
-- END CONFIGURATION configured_pattern_finder;