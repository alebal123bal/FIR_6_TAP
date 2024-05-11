library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;


entity IN_BUFFER is
    port(
        RST:    in std_logic;
        CLK:    in std_logic;
        READY:  in std_logic;   -- Used as a LOAD
        xn_p_1: in data_format;
        xk:     out data_format
    );
end entity IN_BUFFER;


architecture BHV of IN_BUFFER is
    component single_cell is
        port(
            RST:    in std_logic;
            CLK:    in std_logic;
            xin:    in data_format;
            yout:   out data_format
        );
    end component;

    component MUX_2_1 is
        port(
            A:  in data_format;
            B:  in data_format
            SEL:    in std_logic;
            Y:  out data_format
        );
    end component MUX_2_1;

    signal Y_s: data_format;

    begin
        IN_MUX: MUX port map(
            A => xn_p_1,
            B => xk_s(xk_s'right),
            SEL => READY,
            Y => Y_s
        );

        -- for generate loop to make the FIFO-like buffer
        FIFO_GEN:   for i in 0 to 5 generate
            FIRST_INST: if i=0 generate
                FIFO_stage_i:  single_cell port map(
                  RST   => RST,
                  CLK   => CLK,
                  xin   => Y_s,
                  yout  => xk_s(i)
                );
            end generate FIRST_INST;

            OTHER_INST: if i>0 generate
                FIFO_stage_i:  single_cell port map(
                  RST   => RST,
                  CLK   => CLK,
                  xin   => xk_s(i-1),
                  yout  => xk_s(i)
                );
            end generate OTHER_INST;
        end generate FIFO_GEN;

        xk <= xk_s(xk_s'right);
            
    end architecture BHV;

