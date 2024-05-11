library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;


entity IN_BUFFER is
    port(
        RST:    in std_logic;
        CLK:    in std_logic;
        READY:  in std_logic;   -- Used as a LOAD
        K:      in k_format;
        xn_p_1: in data_format;
        xk:     out data_format
    );
end entity IN_BUFFER;


architecture BHV of IN_BUFFER is
    -- Output of MUX to pick K-th element of BUFFER
    signal xk_s:    data_format_array;
    signal yk_s:    data_format_array;

    signal y_s:     data_format;

    begin
        GET_XK: process(RST, READY, xn_p_1, yk_s)
        begin
            if RST = '0' then
                for i in xk_s'range loop
                    xk_s    <=  (others => '0');
                end loop;
            else
                if READY = '1' then
                    xk_s(0) <= xn_p_1;
                    xk_s(1) <= yk_s(0);
                    xk_s(2) <= yk_s(0);
                    xk_s(3) <= yk_s(2);
                    xk_s(4) <= yk_s(3);
                    xk_s(5) <= yk_s(4);
                else
                    xk_s    <= yk_s;
                end if;
            end if;
        end process GET_XK;

        ASSIGN_OUT: process(CLK)
        begin
            yk_s    <=  xk_s;
        end process ASSIGN_OUT;

            
    end architecture BHV;

