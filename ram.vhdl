library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use STD.TEXTIO.ALL;
use IEEE.std_logic_arith.all;

ENTITY ram IS
    GENERIC (
        DATA_WIDTH : INTEGER := 8;
        number_of_rows : INTEGER := 16);
    PORT (
        rst : IN STD_LOGIC;
        data_in : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        address_in_wr, address_in_read : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        write_en, read_en : IN STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0));
END ENTITY ram;

ARCHITECTURE behavioral OF ram IS
    TYPE memory_array IS ARRAY (0 TO number_of_rows - 1) OF STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL mem : memory_array := (OTHERS => (OTHERS => '0'));
    FILE input_file : TEXT OPEN READ_MODE IS "mem_init.txt"; -- Open the text file for reading
BEGIN
    PROCESS (rst)
        VARIABLE line : LINE;
        VARIABLE text_data : STD_LOGIC_VECTOR(1 TO DATA_WIDTH);
        VARIABLE i : INTEGER := 0;
    BEGIN
        WHILE i < 15 LOOP
            readline(input_file, line);
            read(line, text_data);
            mem(i) <= (text_data);
            i := i + 1;
        END LOOP;
        file_close(input_file);
    END PROCESS;
    data_out <= mem(conv_integer(unsigned(address_in_read)));
    writeProcess: process(write_en)
    begin
        mem(conv_integer(unsigned(address_in_wr))) <= data_in;
    end process writeProcess;
END ARCHITECTURE behavioral;