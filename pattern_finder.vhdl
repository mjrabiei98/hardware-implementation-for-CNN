LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY patter_finder IS
    GENERIC (
        data_width : INTEGER := 8;
        number_of_conv : INTEGER := 3
    );
    PORT (
        start, clk, rst, write_ram : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        address_in_wr : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        done : OUT STD_LOGIC;
        output_pattern : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY patter_finder;

ARCHITECTURE behavioral OF patter_finder IS
    SIGNAL ram_data_out : STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL write_en, read_en : STD_LOGIC;
    SIGNAL conv1_data_out1, conv1_data_out2, conv1_data_out3, conv1_data_out4 : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL conv2_data_out1, conv2_data_out2, conv2_data_out3, conv2_data_out4 : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL conv3_data_out1, conv3_data_out2, conv3_data_out3, conv3_data_out4 : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);

    SIGNAL relu1_data_out1, relu1_data_out2, relu1_data_out3, relu1_data_out4 : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL relu2_data_out1, relu2_data_out2, relu2_data_out3, relu2_data_out4 : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL relu3_data_out1, relu3_data_out2, relu3_data_out3, relu3_data_out4 : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL maxpool1_out, maxpool2_out, maxpool3_out : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    signal address_out : std_logic_vector(data_width - 1 downto 0);
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
    -- component
    -- conv2to0 : FOR i IN 1 TO number_of_conv GENERATE
    -- BEGIN
    --     conv_i : ENTITY work.convolution(behavioral)
    --         GENERIC MAP()
    --         PORT MAP();
    -- END GENERATE;

    conv1 : ENTITY work.convolution(modular)
        GENERIC MAP(
            "11111111", "00000100", 8, "00000000", "00000001", "00000000",
            "00000001", "00000001", "00000001", "00000000", "00000001", "00000000"
        )
        PORT MAP(
            clk, rst, start, ram_data_out, conv1_data_out1, conv1_data_out2, conv1_data_out3, conv1_data_out4, done, address_out
        );

    conv2 : ENTITY work.convolution(modular)
        GENERIC MAP(
            "11111110", "00000100", 8, "00000001", "00000001", "00000001",
            "00000001", "00000000", "00000000", "00000001", "00000001", "00000001"
        )
        PORT MAP(
            clk, rst, start, ram_data_out, conv2_data_out1, conv2_data_out2, conv2_data_out3, conv2_data_out4, done, address_out
        );

    conv3 : ENTITY work.convolution(modular)
        GENERIC MAP(
            "00000000", "00000100", 8, "00000001", "00000001", "00000001",
            "00000000", "00000001", "00000000", "00000000", "00000001", "00000000"
        )
        PORT MAP(
            clk, rst, start, ram_data_out, conv3_data_out1, conv3_data_out2, conv3_data_out3, conv3_data_out4, done, address_out
        );

    relu1 : ENTITY work.relu(behavioral)
        GENERIC MAP(8)
        PORT MAP(
            conv1_data_out1, conv1_data_out2, conv1_data_out3, conv1_data_out4,
            relu1_data_out1, relu1_data_out2, relu1_data_out3, relu1_data_out4
        );

    relu2 : ENTITY work.relu(behavioral)
        GENERIC MAP(8)
        PORT MAP(
            conv2_data_out1, conv2_data_out2, conv2_data_out3, conv2_data_out4,
            relu2_data_out1, relu2_data_out2, relu2_data_out3, relu2_data_out4
        );

    relu3 : ENTITY work.relu(behavioral)
        GENERIC MAP(8)
        PORT MAP(
            conv3_data_out1, conv3_data_out2, conv3_data_out3, conv3_data_out4,
            relu3_data_out1, relu3_data_out2, relu3_data_out3, relu3_data_out4
        );

    max1 : ENTITY work.maxpool(behavioral)
        GENERIC MAP(8)
        PORT MAP(
            relu1_data_out1, relu1_data_out2, relu1_data_out3, relu1_data_out4, maxpool1_out
        );

    max2 : ENTITY work.maxpool(behavioral)
        GENERIC MAP(8)
        PORT MAP(
            relu2_data_out1, relu2_data_out2, relu2_data_out3, relu2_data_out4, maxpool2_out
        );

    max3 : ENTITY work.maxpool(behavioral)
        GENERIC MAP(8)
        PORT MAP(
            relu3_data_out1, relu3_data_out2, relu3_data_out3, relu3_data_out4, maxpool3_out
        );


    res : ENTITY work.resualt(behavioral)
        GENERIC MAP(8)
        PORT MAP(
            maxpool1_out, maxpool2_out, maxpool3_out, output_pattern
        );

END behavioral; -- behavioral