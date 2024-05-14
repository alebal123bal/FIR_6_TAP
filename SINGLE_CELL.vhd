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
        next_y: out data_format;
        yout:   out data_format
    );
end entity single_cell;


architecture BHV of single_cell is
    signal REGed_yout: data_format;
    signal current_yout: data_format;

    begin
        -- TODO: make this out combinatorial too
        CALC_NEXT: process(RST, READY, xin, REGed_yout)
        begin
            -- Active-Low Reset
            if RST='0' then
                current_yout <= (others =>  '0');
            else
                --MUX logic
                if READY = '1' then
                    current_yout <= xin;
                else 
                    current_yout <= REGed_yout;
                end if;
            end if;
        end process CALC_NEXT;

        -- Assign combinatorial and REGed outputs
        OUT_ASSIGN: process(current_yout, REGed_yout)
        begin
            next_y  <= current_yout;
            yout    <= REGed_yout;
        end process OUT_ASSIGN;

        -- Assign REGs content
        REG_ASSIGN: process(CLK)
            begin
                if rising_edge(CLK) then
                    REGed_yout <= current_yout;
                end if;
            end process REG_ASSIGN;

    end architecture BHV;


