LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY reg IS
    GENERIC (register_size : INTEGER := 16);
    PORT (
        clk, rst, en : IN STD_LOGIC;
        d : IN STD_LOGIC_VECTOR(register_size - 1 DOWNTO 0);
        q : OUT STD_LOGIC_VECTOR(register_size - 1 DOWNTO 0));
END ENTITY reg;

ARCHITECTURE behavioral OF reg IS
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            q <= (OTHERS => '0');
        ELSIF (clk = '1' AND clk'event and en = '1') THEN
            q <= d;
        END IF;

    END PROCESS;
END behavioral; -- behavioral
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY counter IS
    GENERIC (
        counter_size : INTEGER := 4;
        counter_limit : INTEGER := 3);
    PORT (
        clk, rst, en : IN STD_LOGIC;
        counter_out : OUT STD_LOGIC_VECTOR(counter_size - 1 DOWNTO 0);
        cout : OUT STD_LOGIC
    );
END ENTITY counter;

ARCHITECTURE behavioral OF counter IS
    SIGNAL cnt : STD_LOGIC_VECTOR(counter_size - 1 DOWNTO 0);
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            cnt <= (OTHERS => '0');
            cout <= '0';
        ELSIF (clk = '1' AND clk'event AND en = '1') THEN
            IF (unsigned(cnt) + 1 < counter_limit) THEN
                cnt <= STD_LOGIC_VECTOR(unsigned(cnt) + 1);
                cout <= '0';
            ELSE
                cnt <= (OTHERS => '0');
                cout <= '1';
            END IF;
        END IF;
    END PROCESS;
    counter_out <= cnt;
END behavioral; -- behavioral

---------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY adder IS
    GENERIC (
        input_size : INTEGER := 8
    );
    PORT (
        a, b : IN STD_LOGIC_VECTOR(input_size - 1 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(input_size - 1 DOWNTO 0)
    );
END ENTITY adder;

ARCHITECTURE behavioral OF adder IS
BEGIN

    output <= STD_LOGIC_VECTOR(unsigned(a) + unsigned(b));

END behavioral; -- behavioral
-------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY mult IS
    GENERIC (
        input_size : INTEGER := 8
    );
    PORT (
        a, b : IN STD_LOGIC_VECTOR(input_size - 1 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(input_size - 1 DOWNTO 0)
    );
END ENTITY mult;

ARCHITECTURE behavioral OF mult IS

    SIGNAL temp : STD_LOGIC_VECTOR(2 * input_size - 1 DOWNTO 0);

BEGIN

    temp <= STD_LOGIC_VECTOR(unsigned(a) * unsigned(b));
    output <= temp(input_size - 1 DOWNTO 0);
END behavioral; -- behavioral
-----------

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY mux IS
    GENERIC (
        input_size : INTEGER := 8
    );
    PORT (
        a, b, c, d : IN STD_LOGIC_VECTOR(input_size - 1 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(input_size - 1 DOWNTO 0)
    );
END ENTITY mux;

ARCHITECTURE behavioral OF mux IS

BEGIN
    WITH sel SELECT
        output <= a WHEN "00",
        b WHEN "01",
        c WHEN "10",
        d WHEN "11",
        a WHEN OTHERS;

END behavioral; -- behavioral
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY kernel_mux IS
    GENERIC (
        input_size : INTEGER := 8
    );
    PORT (
        a, b, c, d, e, f, g, h, k : IN STD_LOGIC_VECTOR(input_size - 1 DOWNTO 0);
        i, j : IN STD_LOGIC_VECTOR(input_size - 1 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(input_size - 1 DOWNTO 0)
    );
END ENTITY kernel_mux;

ARCHITECTURE behavioral OF kernel_mux IS

BEGIN
    PROCESS (i, j)
    BEGIN
        IF (i = "00000000" AND j = "00000000") THEN
            output <= a;
        ELSIF (i = "00000001" AND j = "00000000") THEN
            output <= b;
        ELSIF (i = "00000010" AND j = "00000000") THEN
            output <= c;
        ELSIF (i = "00000000" AND j = "00000001") THEN
            output <= d;
        ELSIF (i = "00000001" AND j = "00000001") THEN
            output <= e;
        ELSIF (i = "00000010" AND j = "00000001") THEN
            output <= f;
        ELSIF (i = "00000000" AND j = "00000010") THEN
            output <= g;
        ELSIF (i = "00000001" AND j = "00000010") THEN
            output <= h;
        ELSIF (i = "00000010" AND j = "00000010") THEN
            output <= k;
        ELSE
            output <= (OTHERS => '0');
        END IF;
    END PROCESS;
END behavioral; -- behavioral