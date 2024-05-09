library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;

entity CU is
    port(
        START:  in std_logic;
        RST:    in std_logic;
        CLK:    in std_logic;
        K:      out k_format;
        READY:  out std_logic
    );
end entity CU;

