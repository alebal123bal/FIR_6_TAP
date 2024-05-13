library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;


--Single cell to be instantiated 6 times in order to make a FIFO
entity single_cell is
    port(
        RST:    in std_logic;
        CLK:    in std_logic;
        READY:  in std_logic;
        xin:    in data_format;
        yout:   out data_format     -- REG output
    );
end entity single_cell;


architecture BHV of single_cell is

    begin
        -- Assign REGs content
        REG_ASSIGN: process(CLK, RST, xin)
            begin
                if rising_edge(CLK) then
                    -- Active-Low Reset
                    if RST='0' then
                        yout <= (others =>  '0');
                    else
                        --MUX logic
                        if READY = '1' then
                            yout <= xin;
                        else 
                            yout <= yout;
                        end if;
                    end if;
                end if;
            end process REG_ASSIGN;

    end architecture BHV;


