LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY resualt IS
    GENERIC (
        data_width : INTEGER := 8
    );
    PORT (
        a, b, c : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        output : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY resualt;

ARCHITECTURE behavioral OF resualt IS
BEGIN
    PROCESS (a, b, c)
    BEGIN
        output <= "000";

        IF a > b and a > c THEN
            output <= "001";
        END IF;

        IF b > a and b > c THEN
            output <= "010";
        END IF;

        IF c > b and c > a THEN
            output <= "100";
        END IF;

    END PROCESS;
END behavioral; -- behavioral