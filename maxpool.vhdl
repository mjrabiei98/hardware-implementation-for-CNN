LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY maxpool IS
    GENERIC (
        data_width : INTEGER := 8
    );
    PORT (
        a, b, c, d : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
    );
END ENTITY maxpool;

ARCHITECTURE behavioral OF maxpool IS
BEGIN
    PROCESS (a,b,c,d)
        VARIABLE max_var : STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
    BEGIN
        max_var := a;

        IF b > max_var THEN
            max_var := b;
        END IF;

        IF c > max_var THEN
            max_var := c;
        END IF;

        IF d > max_var THEN
            max_var := d;
        END IF;
        output <= max_var;
    END PROCESS;
END behavioral; -- behavioral