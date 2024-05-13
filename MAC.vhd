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
        yn      :   out data_format
    );
end entity MAC;

architecture BHV of MAC is
    signal sum_s:   data_format;            
    signal mult_s:  double_data_format;            

    begin
        -- Compute outputs
        CALC_OUT: process(ROM_in, xk_in, yn, sum_s, mult_s)
        begin
            mult_s  <= ROM_in * xk_in;
            sum_s   <= mult_s(23 downto 0) + yn;
        end process CALC_OUT;

        -- Assign REGs content
        REG_ASSIGN: process(CLK)
            begin
                if rising_edge(CLK) then
                    if RST='0' then
                        yn  <= (others => '0');
                    else
                        yn <= sum_s;
                    end if;
                end if;
            end process REG_ASSIGN;
    end architecture BHV;
