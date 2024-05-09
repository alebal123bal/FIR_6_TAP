library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;

entity CU_tb is
end entity CU_tb;

architecture BHV of CU_tb is
    component CU is
        port(
            START:  in std_logic;
            RST:    in std_logic;
            CLK:    in std_logic;
            K:      out k_format;
            READY:  out std_logic
        );
    end component;

    signal K_s   :  k_format;

    signal RST_s    :   std_logic;
    signal CLK_s    :   std_logic;
    signal START_s  :   std_logic;
    signal READY_s  :   std_logic;

    begin
        DUT_CU :   CU port map(
            START   => START_s,
            RST     => RST_s,
            CLK     => CLK_s,
            K       => K_s,
            READY   => READY_s
        );

        process begin
            -- Active low
            RST_s <= '0';
            wait for 20ns;
            RST_s <= '1';
            START_s <= '1';

            wait for 200ns;
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