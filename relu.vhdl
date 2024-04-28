LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY relu IS
    GENERIC (
        data_width : INTEGER := 8
    );
    PORT (
        a, b, c, d : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        d1, d2, d3, d4 : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
    );
END ENTITY relu;

ARCHITECTURE behavioral OF relu IS
BEGIN
    PROCESS (a, b, c, d)
    BEGIN

        IF signed(a) < 0 THEN
            d1 <= (OTHERS => '0');
        ELSE
            d1 <= a;
        END IF;

        IF signed(b) < 0 THEN
            d2 <= (OTHERS => '0');
        ELSE
            d2 <= b;
        END IF;

        IF signed(c) < 0 THEN
            d3 <= (OTHERS => '0');
        ELSE
            d3 <= c;
        END IF;

        IF signed(d) < 0 THEN
            d4 <= (OTHERS => '0');
        ELSE
            d4 <= d;
        END IF;

    END PROCESS;
END behavioral; -- behavioral