library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;

entity MAC is
    port(
        ROM_in  :   in data_format;
        xk_in   :   in data_format;
        RST     :   in std_logic;
        READY   :   in std_logic;
        CLK     :   in std_logic;
        yn      :   out data_format
    );
end entity MAC;

architecture BHV of MAC is
    signal sum_s:   data_format;            
    signal mult_s:  double_data_format; 
    signal REGed_y: data_format;           

    begin
        -- Compute outputs
        CALC_OUT: process(RST, READY, ROM_in, xk_in, REGed_y, sum_s, mult_s)
        begin
            if RST = '0' then
                mult_s  <= (others => '0');
                sum_s   <= (others => '0');
            else
                mult_s  <= ROM_in * xk_in;
                if READY = '0' then
                    sum_s   <= mult_s(23 downto 0) + REGed_y;
                else
                    sum_s   <= mult_s(23 downto 0);
                end if;
            end if;
        end process CALC_OUT;

        -- Assign combinatorial outputs
        OUT_ASSIGN:  process(sum_s)
        begin
            yn <= sum_s;
        end process OUT_ASSIGN;

        -- Assign REGs content
        REG_ASSIGN: process(CLK)
            begin
                if rising_edge(CLK) then
                    REGed_y <= sum_s;
                end if;
            end process REG_ASSIGN;
    end architecture BHV;
