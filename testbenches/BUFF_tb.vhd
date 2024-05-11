library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;

entity BUFF_tb is
end entity BUFF_tb;

architecture BHV of BUFF_tb is
    component IN_BUFFER is
        port(
            RST:    in std_logic;
            CLK:    in std_logic;
            READY:  in std_logic;
            xn_p_1: in data_format;
            xk:     out data_format
        );
    end component;

    signal xn_p_1_s   :  data_format :=  x"000000";
    signal xk_s   :  data_format :=  x"000000";

    signal RST_s    :   std_logic;
    signal CLK_s    :   std_logic;
    signal READY_s  :   std_logic;

    begin
        DUT_in_buff :   IN_BUFFER port map(
            RST     => RST_s,
            CLK     => CLK_s,
            READY   => READY_s,
            xn_p_1  => xn_p_1_s,
            xk      => xk_s
        );

        process begin            
            -- Active low
            RST_s <= '0';
            READY_s <= '0';

            wait for 20ns;

            RST_s <= '1';
            
            xn_p_1_s <= x"00BEEF";
            READY_s <= '1';
            wait for 20ns;

            READY_s <= '0';
            wait for 100ns;

            xn_p_1_s <= x"00DEAD";
            READY_s <= '1';
            wait for 20ns;
            
            READY_s <= '0';
            wait for 100ns;

            
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