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
    component single_cell is
        port(
            RST:    in std_logic;
            CLK:    in std_logic;
            READY:  in std_logic;
            xin:    in data_format;
            yout:   out data_format
        );
    end component;

    -- Output of MUX to pick K-th element of BUFFER
    signal xk_s:    data_format_array;

    signal y_s:     data_format;

    begin
        -- for generate loop to make the FIFO-like buffer
        FIFO_GEN:   for i in 0 to 5 generate
            FIRST_INST: if i=0 generate
                FIFO_stage_i:  single_cell port map(
                  RST   => RST,
                  CLK   => CLK,
                  READY => READY,
                  xin   => xn_p_1,
                  yout  => xk_s(i)
                );
            end generate FIRST_INST;

            OTHER_INST: if i>0 generate
                FIFO_stage_i:  single_cell port map(
                  RST   => RST,
                  CLK   => CLK,
                  READY => READY,
                  xin   => xk_s(i-1),
                  yout  => xk_s(i)
                );
            end generate OTHER_INST;
        end generate FIFO_GEN;

        GET_XK: process(xk_s, K)
            begin
                y_s <= xk_s(to_integer(K));
            end process GET_XK;
            
        -- I chose to use CLK = '1' instead of rising edge since the 
        -- output of the single cell, xk_s(i), is not yet changed during the
        -- rising edge, so I get the older value    
        ASSIGN_OUT: process(CLK, y_s)
        begin
            if CLK = '1' then
                xk <= y_s;
            end if;
        end process ASSIGN_OUT;

    end architecture BHV;

