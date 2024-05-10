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
    -- Combinational logic signals
    signal mult_s   :   double_data_format;
    signal sum_s    :   data_format;

    -- Clocked signals out of REG
    signal sum_s_clkd    :   data_format;

    begin
        CALC_OUT: process(RST, ROM_in, xk_in, READY, mult_s, sum_s, sum_s_clkd)
        begin
            if RST='0' then
                mult_s <= (others => '0');
                sum_s <= (others => '0');
            else
                mult_s  <=  ROM_in * xk_in;
                sum_s   <=  mult_s(23 downto 0) + sum_s_clkd;
            end if;

        end process CALC_OUT;

        -- Assign REGs content
        REG_ASSIGN: process(CLK)
            begin
                if rising_edge(CLK) then
                    sum_s_clkd <= sum_s;
                end if;
            end process REG_ASSIGN;
        
        -- Assign output only when is ready
        OUT_ASSIGN: process(READY)
        begin
            if READY='1' then
                yn <= sum_s_clkd;
            else
                yn <= yn;
            end if;
        end process OUT_ASSIGN;    
    end architecture BHV;
