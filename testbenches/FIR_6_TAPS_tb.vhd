library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;

entity FIR_6_TAPS_tb is
end entity FIR_6_TAPS_tb;

architecture BHV of FIR_6_TAPS_tb is
    component FIR_6_TAPS is
        port(
            START:  in std_logic;
            RST:    in std_logic;
            CLK:    in std_logic;
            x_in    :   in data_format;
            yn      :   out data_format;
            READY:  out std_logic
        );
    end component;

    signal xin_s    :  data_format;

    signal START_s  :   std_logic;
    signal RST_s    :   std_logic;
    signal CLK_s    :   std_logic;
    signal READY_s  :   std_logic;

    signal yn_s     :   data_format;

    begin
        DUT_FIR_6_TAPS: FIR_6_TAPS port map(
            START   => START_s,
            RST     => RST_s,
            CLK     => CLK_s,
            x_in    => xin_s,
            yn      => yn_s,
            READY   => READY_s
        );

        process begin
            -- Active low
            RST_s   <= '0';
            START_s <= '0';
            wait for 20ns;
            RST_s   <= '1';
            START_s <= '1';

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