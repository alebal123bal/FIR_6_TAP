library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;

-- Input MUX
entity MUX_2_1 is
    port(
        A:  in data_format;
        B:  in data_format;
        SEL:    in std_logic;
        Y:  out data_format
    );
end entity MUX_2_1;


architecture BHV of MUX_2_1 is
    signal x_s:  data_format;

    begin 
        MUX_2_1:    process(A, B, SEL)
            begin
                if SEL='0' then
                    Y <= A;
                else
                    Y <= B;
                end if;
            end process MUX_2_1;
        
    end architecture BHV;


