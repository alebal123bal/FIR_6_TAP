library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_ROM.all;


--Single cell to be instantiated 6 times in order to make a FIFO
entity single_cell is
    port(
        RST:    in std_logic;
        CLK:    in std_logic;
        READY:  in std_logic;
        xin:    in data_format;
        yout:   out data_format
    );
end entity single_cell;


architecture BHV of single_cell is
    signal xs:  data_format;
    signal ys:  data_format;

    begin
        -- Input MUX 
        MUX_2_1:    process(RST, READY, xin, yout, xs, ys)
            begin
                -- Active-Low Reset
                if RST='0' then
                    ys <= (others => '0');
                    xs <= (others => '0');
                else
                    ys <= yout;

                    if READY='0' then
                        xs <= ys;
                    else
                        xs <= xin;
                    end if;
                end if;
            end process MUX_2_1;
        
        -- Assign REGs content
        REG_ASSIGN: process(CLK)
            begin
                if rising_edge(CLK) then
                    yout <= xs;
                end if;
            end process REG_ASSIGN;

    end architecture BHV;


