library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;

entity FIR_6_TAPS is
    port(
        START:  in std_logic;
        RST:    in std_logic;
        CLK:    in std_logic;
        x_in    :   in data_format;
        yn      :   out data_format;
        READY:  out std_logic
    );
end entity FIR_6_TAPS;


architecture BHV of FIR_6_TAPS is
    signal content_s:   data_format;
    signal xk_s:        data_format;
    signal K_s:         k_format;

    component ROM is
        port(
            K:          in k_format;
            content:    out data_format
        );
    end component;

    component IN_BUFFER is
        port(
            RST:    in std_logic;
            CLK:    in std_logic;
            READY:  in std_logic;
            K:      in k_format;
            xn_p_1: in data_format;
            xk:     out data_format
        );
    end component;

    component MAC is
        port(
            ROM_in  :   in data_format;
            xk_in   :   in data_format;
            RST     :   in std_logic;
            CLK     :   in std_logic;
            READY   :   in std_logic;
            yn      :   out data_format
        );
    end component;

    component CU is
        port(
            START:  in std_logic;
            RST:    in std_logic;
            CLK:    in std_logic;
            K:      out k_format;
            READY:  out std_logic
        );
    end component;

    begin
        my_CU:  CU port map(
            START   => START,
            RST     => RST,
            CLK     => CLK,
            K       => K_s,
            READY   => READY
        );

        my_ROM: ROM port map(
            K       => K_s,
            content => content_s
        );

        my_IN_BUFFER:   IN_BUFFER port map(
            RST     => RST,
            CLK     => CLK,
            READY   => READY,
            K       => K_s,
            xn_p_1  => x_in,
            xk      => xk_s
        );

        my_MAC: MAC port map(
            ROM_in  => content_s,
            xk_in   => xk_s,
            RST     => RST,
            CLK     => CLK,
            READY   => READY,
            yn      => yn
        );


    end architecture BHV;