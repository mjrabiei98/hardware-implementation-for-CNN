LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;
USE IEEE.std_logic_arith.ALL;

ENTITY ram IS
    GENERIC (
        DATA_WIDTH : INTEGER := 8;
        number_of_rows : INTEGER := 16);
    PORT (
        rst : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        address_in_wr, address_in_read : IN STD_LOGIC_VECTOR(data_width-1 DOWNTO 0);
        write_en, read_en : IN STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0));
END ENTITY ram;

ARCHITECTURE behavioral OF ram IS
    TYPE memory_array IS ARRAY (0 TO number_of_rows - 1) OF STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL mem : memory_array := (OTHERS => (OTHERS => '0'));
    FILE input_file : TEXT OPEN READ_MODE IS "mem_init.txt"; -- Open the text file for reading
    SIGNAL init_done : STD_LOGIC := '0';
BEGIN
    PROCESS (rst, write_en)
        VARIABLE line : LINE;
        VARIABLE text_data : STD_LOGIC_VECTOR(1 TO DATA_WIDTH);
        VARIABLE i : INTEGER := 0;
    BEGIN
        IF init_done = '0' THEN
            WHILE i < 16 LOOP
                readline(input_file, line);
                read(line, text_data);
                mem(i) <= (text_data);
                i := i + 1;
            END LOOP;
            file_close(input_file);
            init_done <= '1';

        ELSif write_en = '1' and write_en'event then
            mem(conv_integer(unsigned(address_in_wr))) <= data_in;
        END IF;

    END PROCESS;
    data_out <= mem(conv_integer(unsigned(address_in_read)));
END ARCHITECTURE behavioral;