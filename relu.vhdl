LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY relu IS
    GENERIC (
        data_width : INTEGER := 16
    );
    PORT (
        a, b, c, d : IN STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0);
        d1, d2, d3, d4 : OUT STD_LOGIC_VECTOR(data_width - 1 DOWNTO 0)
    );
END ENTITY relu;

ARCHITECTURE behavioral OF relu IS
BEGIN
    PROCESS (a,b,c,d)
    BEGIN
        
        if a < "00000000" then
            d1 <= (others => '0');
        else
            d1 <= a; 
        end if;

        if b < "00000000" then
            d2 <= (others => '0');
        else
            d2 <= b; 
        end if;

        if c < "00000000" then
            d3 <= (others => '0');
        else
            d3 <= c; 
        end if;

        if d < "00000000" then
            d4 <= (others => '0');
        else
            d4 <= d; 
        end if;

    END PROCESS;
END behavioral; -- behavioral