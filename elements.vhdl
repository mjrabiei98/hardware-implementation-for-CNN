LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY reg IS
    GENERIC (register_size : INTEGER := 16);
    PORT (
        clk, rst : IN STD_LOGIC;
        d : IN STD_LOGIC_VECTOR(register_size - 1 DOWNTO 0);
        q : OUT STD_LOGIC_VECTOR(register_size - 1 DOWNTO 0));
END ENTITY reg;

ARCHITECTURE behavioral OF reg IS
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '0' THEN
            q <= (OTHERS => '0');
        ELSIF (clk = '1' AND clk'event) THEN
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
        clk, rst : IN STD_LOGIC;
        counter_out : OUT STD_LOGIC_VECTOR(counter_size - 1 DOWNTO 0);
        cout : OUT STD_LOGIC
    );
END ENTITY counter;

ARCHITECTURE behavioral OF counter IS
    SIGNAL cnt : STD_LOGIC_VECTOR(counter_size - 1 DOWNTO 0);
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '0' THEN
            counter_out <= (OTHERS => '0');
            cnt <= (OTHERS => '0');
            cout <= '0';
        ELSIF (clk = '1' AND clk'event) THEN
            IF (unsigned(cnt) + 1 < counter_limit) THEN
                cnt <= STD_LOGIC_VECTOR(unsigned(cnt) + 1);
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