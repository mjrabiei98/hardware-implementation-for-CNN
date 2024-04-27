LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY testbench IS END ENTITY testbench;

ARCHITECTURE tb OF testbench IS
    SIGNAL start : STD_LOGIC := '0';
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    SIGNAL write_ram : STD_LOGIC;
    SIGNAL data_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL address_in_wr : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL done : STD_LOGIC;
    SIGNAL output_pattern : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN

    p_finder : ENTITY work.patter_finder(behavioral)
        GENERIC MAP(8, 3, 3)
        PORT MAP(
            start, clk, rst, write_ram,
            data_in, address_in_wr, done,
            output_pattern
        );

    clk <= NOT clk AFTER 5 ns WHEN now <= 5000 ns ELSE
        '0';

    PROCESS
    BEGIN
        WAIT FOR 10 ns;
        rst <= '1';
        WAIT FOR 10 ns;
        rst <= '0';
        WAIT FOR 10 ns;
        start <= '1';
        WAIT FOR 10 ns;
        start <= '0';
        WAIT FOR 5000 ns;
        std.env.stop; -- or std.env.stop;
    END PROCESS;

END ARCHITECTURE tb;