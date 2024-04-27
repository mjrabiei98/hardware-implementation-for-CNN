LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY convolution_datapath IS
    GENERIC (
        bias_value : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
        image_size : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000100";
        data_width : INTEGER := 8;
        kernet_1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_2 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_3 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_4 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_5 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_6 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_7 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_8 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_9 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')
    );
    PORT (
        SIGNAL clk, rst, en_cti, en_ctj, en_ctx, en_cty, temp_reg_en, address_reg_en, out1_reg_en, out2_reg_en, out3_reg_en, out4_reg_en : IN STD_LOGIC;
        SIGNAL data_in : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        SIGNAL data_out1, data_out2, data_out3, data_out4 : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        SIGNAL counter_i_cout, counter_j_cout, counter_x_cout, counter_y_cout : OUT STD_LOGIC;
        SIGNAL adder_mux_1_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        SIGNAL adder_mux_2_sel : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL adr_reg_mux_sel, mult_mux_1_sel, mult_mux_2_sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        SIGNAL cx_out, cy_out, ci_out, cj_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        SIGNAL address_out : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        SIGNAL rst_temp : IN STD_LOGIC
    );
END ENTITY convolution_datapath;

ARCHITECTURE modular OF convolution_datapath IS

    SIGNAL counter_i_out, counter_j_out, counter_x_out, counter_y_out, kernel_mux_out : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL adder_mux_1_out, adder_mux_2_out, adr_reg_mux_out : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL mult_out, adder_out, address_reg_out, mult_mux_1_out, mult_mux_2_out, temp_reg_out : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    SIGNAL cnt_i_cout, cnt_x_cout : STD_LOGIC;

BEGIN
    address_out <= address_reg_out;
    cx_out <= counter_x_out;
    cy_out <= counter_y_out;
    ci_out <= counter_i_out;
    cj_out <= counter_j_out;
    counter_i_cout <= cnt_i_cout;
    counter_x_cout <= cnt_x_cout;
    counter_i : ENTITY work.counter(behavioral)
        GENERIC MAP(data_width, 3)
        PORT MAP(clk, rst, en_cti, counter_i_out, cnt_i_cout);

    counter_j : ENTITY work.counter(behavioral)
        GENERIC MAP(data_width, 3)
        PORT MAP(clk, rst, en_ctj, counter_j_out, counter_j_cout);

    counter_x : ENTITY work.counter(behavioral)
        GENERIC MAP(data_width, 2)
        PORT MAP(clk, rst, en_ctx, counter_x_out, cnt_x_cout);

    counter_y : ENTITY work.counter(behavioral)
        GENERIC MAP(data_width, 2)
        PORT MAP(clk, rst, en_cty, counter_y_out, counter_y_cout);

    adder_mux_1 : ENTITY work.mux(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(bias_value, counter_j_out, temp_reg_out, address_reg_out, adder_mux_1_sel, adder_mux_1_out);

    adder_mux_2 : ENTITY work.mux_5to1(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(counter_x_out, counter_y_out, mult_out, counter_i_out, bias_value, adder_mux_2_sel, adder_mux_2_out);

    adr : ENTITY work.adder(behavioral)
        GENERIC MAP(8)
        PORT MAP(adder_mux_1_out, adder_mux_2_out, adder_out);

    mult : ENTITY work.mult(behavioral)
        GENERIC MAP(8)
        PORT MAP(mult_mux_1_out, mult_mux_2_out, mult_out);

    mult_mux_1 : ENTITY work.mux(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(address_reg_out, kernel_mux_out, (OTHERS => 'Z'), (OTHERS => 'Z'), mult_mux_1_sel, mult_mux_1_out);

    mult_mux_2 : ENTITY work.mux(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(image_size, data_in, (OTHERS => 'Z'), (OTHERS => 'Z'), mult_mux_2_sel, mult_mux_2_out);

    adr_reg_mux : ENTITY work.mux(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(adder_out, mult_out, (OTHERS => 'Z'), (OTHERS => 'Z'), adr_reg_mux_sel, adr_reg_mux_out);

    kernel_mux1 : ENTITY work.kernel_mux(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(kernet_1, kernet_2, kernet_3, kernet_4, kernet_5, kernet_6, kernet_7, kernet_8, kernet_9, counter_i_out, counter_j_out, kernel_mux_out);

    temp_reg : ENTITY work.reg(behavioral)
        GENERIC MAP(data_width)
        PORT MAP(
            clk, rst_temp, temp_reg_en, adder_out, temp_reg_out);

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

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY convolution_controller IS
    PORT (
        SIGNAL clk, rst, start : IN STD_LOGIC;
        SIGNAL en_cti, en_ctj, en_ctx, en_cty, temp_reg_en, address_reg_en, out1_reg_en, out2_reg_en, out3_reg_en, out4_reg_en : OUT STD_LOGIC;
        SIGNAL counter_i_cout, counter_j_cout, counter_x_cout, counter_y_cout : IN STD_LOGIC;
        SIGNAL adder_mux_1_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        SIGNAL adder_mux_2_sel : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIGNAL adr_reg_mux_sel, mult_mux_1_sel, mult_mux_2_sel : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        SIGNAL counter_x_out, counter_y_out, counter_i_out, counter_j_out : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        SIGNAL done : OUT STD_LOGIC;
        SIGNAL rst_temp : OUT STD_LOGIC
    );
END ENTITY convolution_controller;

ARCHITECTURE behavioral OF convolution_controller IS

    TYPE state IS (
        idle, adr_gen1, adr_gen2, adr_gen3,
        adr_gen4, kerlent_mult, add_bias, load_output, done_state, stable
    );

    SIGNAL pstate, nstate : state := idle;

BEGIN

    PROCESS (clk, rst)
    BEGIN
        IF (rst = '1') THEN
            pstate <= idle;
        ELSIF (clk = '1' AND clk'EVENT) THEN
            pstate <= nstate;
        END IF;
    END PROCESS;

    PROCESS (pstate, start, counter_j_out, counter_i_out, counter_y_out, counter_x_out) BEGIN
        en_cti <= '0';
        done <= '0';
        en_ctj <= '0';
        en_ctx <= '0';
        en_cty <= '0';
        temp_reg_en <= '0';
        address_reg_en <= '0';
        out1_reg_en <= '0';
        out2_reg_en <= '0';
        out3_reg_en <= '0';
        out4_reg_en <= '0';
        adder_mux_1_sel <= "00";
        adder_mux_2_sel <= "000";
        adr_reg_mux_sel <= "00";
        mult_mux_1_sel <= "00";
        mult_mux_2_sel <= "00";
        rst_temp <= '0';

        CASE pstate IS

            WHEN idle =>
                rst_temp <= '1';
                IF start = '0' AND start'event THEN
                    nstate <= adr_gen1;
                ELSE
                    nstate <= idle;
                END IF;

            WHEN adr_gen1 =>
                nstate <= adr_gen2;
                adder_mux_1_sel <= "01";
                adder_mux_2_sel <= "001";
                adr_reg_mux_sel <= "00";
                address_reg_en <= '1';

            WHEN adr_gen2 =>
                nstate <= adr_gen3;
                mult_mux_1_sel <= "00";
                mult_mux_2_sel <= "00";
                adr_reg_mux_sel <= "01";
                address_reg_en <= '1';

            WHEN adr_gen3 =>
                nstate <= adr_gen4;
                adder_mux_1_sel <= "11";
                adder_mux_2_sel <= "000";
                adr_reg_mux_sel <= "00";
                address_reg_en <= '1';

            WHEN adr_gen4 =>
                nstate <= kerlent_mult;
                adder_mux_1_sel <= "11";
                adder_mux_2_sel <= "011";
                adr_reg_mux_sel <= "00";
                address_reg_en <= '1';

            WHEN kerlent_mult =>
                mult_mux_1_sel <= "01";
                mult_mux_2_sel <= "01";
                adder_mux_1_sel <= "10";
                adder_mux_2_sel <= "010";
                temp_reg_en <= '1';
                en_cti <= '1';

                IF counter_i_out = "00000010" THEN
                    en_ctj <= '1';
                END IF;
                nstate <= stable;

            WHEN stable =>
                IF counter_j_out = "00000010" AND counter_i_out = "00000010" THEN
                    nstate <= add_bias;
                ELSE
                    nstate <= adr_gen1;
                END IF;

            WHEN add_bias =>
                nstate <= load_output;
                adder_mux_1_sel <= "10";
                adder_mux_2_sel <= "100";
                adr_reg_mux_sel <= "00";
                temp_reg_en <= '1';

            WHEN load_output =>
                IF counter_y_out = "00000000" AND counter_x_out = "00000000" THEN
                    out1_reg_en <= '1';
                ELSIF counter_y_out = "00000000" AND counter_x_out = "00000001" THEN
                    out2_reg_en <= '1';
                ELSIF counter_y_out = "00000001" AND counter_x_out = "00000000" THEN
                    out3_reg_en <= '1';
                ELSIF counter_y_out = "00000001" AND counter_x_out = "00000001" THEN
                    out4_reg_en <= '1';
                END IF;
                IF counter_y_out = "00000001" THEN
                    nstate <= done_state;
                ELSE
                    nstate <= adr_gen1;
                END IF;
                en_ctx <= '1';
                IF counter_x_out = "00000001" THEN
                    en_cty <= '1';
                END IF;
                rst_temp <= '1';

            WHEN done_state =>
                done <= '1';
        END CASE;

    END PROCESS;

END behavioral; -- arch
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY convolution IS
    GENERIC (
        bias_value : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
        image_size : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000100";
        data_width : INTEGER := 8;
        kernet_1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_2 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_3 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_4 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_5 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_6 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_7 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_8 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');
        kernet_9 : STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')
    );
    PORT (
        SIGNAL clk, rst, start : IN STD_LOGIC;
        SIGNAL data_in : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        SIGNAL data_out1, data_out2, data_out3, data_out4 : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        SIGNAL done : OUT STD_LOGIC;
        SIGNAL address_out : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
    );
END ENTITY convolution;
ARCHITECTURE modular OF convolution IS

    SIGNAL en_cti, en_ctj, en_ctx, en_cty, temp_reg_en, address_reg_en, out1_reg_en, out2_reg_en, out3_reg_en, out4_reg_en : STD_LOGIC;
    SIGNAL counter_i_cout, counter_j_cout, counter_x_cout, counter_y_cout : STD_LOGIC;
    SIGNAL adder_mux_1_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL adder_mux_2_sel : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL adr_reg_mux_sel, mult_mux_1_sel, mult_mux_2_sel : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL counter_x_out, counter_y_out, counter_i_out, counter_j_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL rst_temp : STD_LOGIC;

BEGIN

    datapath : ENTITY work.convolution_datapath(modular)
        GENERIC MAP(
            bias_value, image_size, data_width, kernet_1, kernet_2, kernet_3,
            kernet_4, kernet_5, kernet_6, kernet_7, kernet_8, kernet_9
        )
        PORT MAP(
            clk, rst, en_cti, en_ctj, en_ctx, en_cty, temp_reg_en, address_reg_en, out1_reg_en, out2_reg_en, out3_reg_en, out4_reg_en,
            data_in,
            data_out1, data_out2, data_out3, data_out4,
            counter_i_cout, counter_j_cout, counter_x_cout, counter_y_cout,
            adder_mux_1_sel, adder_mux_2_sel, adr_reg_mux_sel, mult_mux_1_sel, mult_mux_2_sel,
            counter_x_out, counter_y_out, counter_i_out, counter_j_out, address_out, rst_temp
        );
    controller : ENTITY work.convolution_controller(behavioral)
        PORT MAP(
            clk, rst, start, en_cti, en_ctj, en_ctx, en_cty, temp_reg_en, address_reg_en, out1_reg_en, out2_reg_en, out3_reg_en, out4_reg_en,
            counter_i_cout, counter_j_cout, counter_x_cout, counter_y_cout,
            adder_mux_1_sel, adder_mux_2_sel, adr_reg_mux_sel, mult_mux_1_sel, mult_mux_2_sel,
            counter_x_out, counter_y_out, counter_i_out, counter_j_out,
            done, rst_temp
        );

END ARCHITECTURE modular;