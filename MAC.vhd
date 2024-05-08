library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;

entity MAC is
    port(
        ROM_in  :   in data_format;
        xk_in   :   in data_format;
        RST     :   in std_logic;
        CLK     :   in std_logic;
        READY   :   in std_logic;
        yn      :   out data_format
    );
end entity MAC;

architecture BHV of MAC is
    begin
    
    end architecture BHV;
