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

    -- Array of single cell outputs
    signal xk_array_s:    data_format_array;
    -- Output of MUX to pick K-th element of BUFFER
    signal xk_s:    data_format;

    begin
        -- for generate loop to make the FIFO-like buffer
        FIFO_GEN:   for i in 0 to 6 generate
            FIRST_INST: if i=0 generate
                FIFO_stage_i:  single_cell port map(
                  RST   => RST,
                  CLK   => CLK,
                  READY => READY,
                  xin   => xn_p_1,
                  yout  => xk_array_s(i)
                );
            end generate FIRST_INST;

            OTHER_INST: if i>0 generate
                FIFO_stage_i:  single_cell port map(
                  RST   => RST,
                  CLK   => CLK,
                  READY => READY,
                  xin   => xk_array_s(i-1),
                  yout  => xk_array_s(i)
                );
            end generate OTHER_INST;
        end generate FIFO_GEN;

        -- Assign REGed output xk sample
        REG_ASSIGN: process(CLK, xk_array_s, K, xn_p_1) 
            begin
            if rising_edge(CLK) then
                if to_integer(K) = 0 then 
                    xk <= xn_p_1;
                else
                    xk <= xk_array_s(to_integer(K));
                end if;
            end if;
        end process REG_ASSIGN;

            
    end architecture BHV;

