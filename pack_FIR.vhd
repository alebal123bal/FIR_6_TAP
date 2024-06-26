library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package pack_FIR is
    subtype data_format is signed(23 downto 0);
    subtype double_data_format is signed(47 downto 0);
    type data_format_array is array(0 to 5) of data_format;
    subtype k_format is unsigned(2 downto 0);
    
    type state_type is (IDLE, ITERATE);
end package pack_FIR;
