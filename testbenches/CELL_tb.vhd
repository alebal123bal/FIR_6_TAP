library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_ROM.all;

entity CELL_tb is
end entity CELL_tb;

architecture BHV of CELL_tb is
    component single_cell is
        port(
            RST:    in std_logic;
            CLK:    in std_logic;
            READY:  in std_logic;
            xin:    in data_format;
            yout:   out data_format
        );
    end component;

    signal xs   :  data_format :=  x"00DEAD";
    signal ys   :  data_format :=  x"000000";

    signal RST_s    :   std_logic;
    signal CLK_s    :   std_logic;
    signal READY_s  :   std_logic;

    begin
        DUT_single_cell :   single_cell port map(
            RST     => RST_s,
            CLK     => CLK_s,
            READY   => READY_s,
            xin     => xs,
            yout     => ys
        );

        process begin
            -- Active low
            RST_s <= '0';
            READY_s <= '0';
            wait for 20ns;
            RST_s <= '1';

            READY_s <= '1';
            wait for 20ns;
            READY_s <= '0';

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