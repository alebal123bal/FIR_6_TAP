library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;

entity MAC_tb is
end entity MAC_tb;

architecture BHV of MAC_tb is
    component MAC is
        port(
            ROM_in  :   in data_format;
            xk_in   :   in data_format;
            RST     :   in std_logic;
            CLK     :   in std_logic;
            yn      :   out data_format
        );
    end component;

    signal ROM_s    :  data_format :=  x"000001";
    signal xk_s     :  data_format :=  x"000001";

    signal RST_s    :   std_logic;
    signal CLK_s    :   std_logic;
    signal READY_s  :   std_logic;

    signal y_s      :   data_format;

    begin
        DUT_MAC:    MAC port map(
            ROM_in  => ROM_s,
            xk_in   => xk_s,
            RST     => RST_s,
            CLK     => CLK_s,
            yn      => y_s
        );

        process begin
            -- Active low
            RST_s <= '0';
            READY_s <= '0';
            wait for 20ns;
            RST_s <= '1';

            ROM_s   <= x"000001";
            xk_s   <= x"000001";
            wait for 80ns;
            READY_s <= '1';
            wait for 20ns;
            
            ROM_s   <= x"000002";
            xk_s   <= x"000002";
            READY_s <= '0';
            wait for 80ns;
            READY_s <= '1';
            wait for 20ns;

            READY_s <= '0';
            wait for 20ns;
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