library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;

entity FIR_6_TAPS_tb is
end entity FIR_6_TAPS_tb;

architecture BHV of FIR_6_TAPS_tb is
    component FIR_6_TAPS is
        port(
            RST:    in std_logic;
            CLK:    in std_logic;
            x_in:   in data_format;
            yn:     out data_format;
            READY:  out std_logic;
            final_yn:   out data_format
        );
    end component;

    signal xin_s    :  data_format;

    signal RST_s    :   std_logic;
    signal CLK_s    :   std_logic;
    signal READY_s  :   std_logic:= '0';

    signal yn_s     :   data_format;
    signal final_yn_s     :   data_format;

    begin
        DUT_FIR_6_TAPS: FIR_6_TAPS port map(
            RST     => RST_s,
            CLK     => CLK_s,
            x_in    => xin_s,
            yn      => yn_s,
            READY   => READY_s,
            final_yn => final_yn_s
        );

        process begin
            -- Active low
            RST_s   <= '0';
            xin_s   <= x"000001";    --Constant input
            wait for 30ns;
            RST_s   <= '1';

            wait for 400ns;

            std.env.stop(0);
        end process;

        -- Generate clock pulses
        CLK_gen: process
            begin
                CLK_s <= '0';
                wait for 10ns;
                CLK_s <= '1';
                wait for 10ns;
            end process CLK_gen;

    end architecture BHV;