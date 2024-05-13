library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;


--Single cell to be instantiated 6 times in order to make a FIFO
entity single_cell is
    port(
        RST:    in std_logic;
        CLK:    in std_logic;
        xin:    in data_format;
        yout:   out data_format     -- REG output
    );
end entity single_cell;


architecture BHV of single_cell is
    signal x_s:  data_format;

    begin
        process(RST, xin)
            begin
                -- Active-Low Reset
                if RST='0' then
                    x_s     <= (others => '0');
                    yout    <= (others => '0');
                else
                    x_s <= xin;
                end if;
            end process;
        
        -- Assign REGs content
        REG_ASSIGN: process(CLK)
            begin
                if rising_edge(CLK) then
                    yout <= x_s;
                end if;
            end process REG_ASSIGN;

    end architecture BHV;


