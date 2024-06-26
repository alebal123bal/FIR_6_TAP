library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;

entity FIR_6_TAPS is
    port(
        RST:    in std_logic;
        CLK:    in std_logic;
        x_in:   in data_format;
        yn:     out data_format;
        READY:  out std_logic;
        final_yn:   out data_format
    );
end entity FIR_6_TAPS;


architecture BHV of FIR_6_TAPS is
    signal content_s:   data_format;
    signal xk_s:        data_format;
    signal K_s:         k_format;
    signal READY_s:     std_logic;

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
            READY   :   in std_logic;
            CLK     :   in std_logic;
            yn      :   out data_format
        );
    end component;

    component CU is
        port(
            RST:    in std_logic;
            CLK:    in std_logic;
            K:      out k_format;
            READY:  out std_logic
        );
    end component;

    begin
        my_CU:  CU port map(
            RST     => RST,
            CLK     => CLK,
            K       => K_s,
            READY   => READY_s
        );

        my_ROM: ROM port map(
            K       => K_s,
            content => content_s
        );

        my_IN_BUFFER:   IN_BUFFER port map(
            RST     => RST,
            CLK     => CLK,
            READY   => READY_s,
            K       => K_s,
            xn_p_1  => x_in,
            xk      => xk_s
        );

        my_MAC: MAC port map(
            ROM_in  => content_s,
            xk_in   => xk_s,
            RST     => RST,
            READY   => READY_s,
            CLK     => CLK,
            yn      => yn
        );

    OUT_ASSIGN: process(READY_s)
    begin
        READY <= READY_s;
    end process OUT_ASSIGN;

    -- Assign official yn value
    REG_ASSIGN: process(CLK, K_s, yn)
    begin
        if rising_edge(CLK) then
            if RST = '0' then
                final_yn <=  (others => '0');
            else
                if to_integer(K_s) = 5 then --This should latch up final_yn
                    final_yn <= yn;
                end if;
            end if;
        end if;
    end process REG_ASSIGN;
    
    end architecture BHV;