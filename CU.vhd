library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;

entity CU is
    port(
        START:  in std_logic;
        RST:    in std_logic;
        CLK:    in std_logic;
        K:      out k_format;
        READY:  out std_logic
    );
end entity CU;

architecture BHV of CU is
    signal state:   state_type;
    signal state_s:   state_type;
    signal K_s: unsigned(2 downto 0);
    signal READY_s: std_logic;
    
    begin
        CALC_NEXT:  process(START, RST, READY_s, K, state)
            begin
                -- Active low
                if RST = '1' then
                    if state = ITERATE then
                        if K_s = "101" then
                            state_s <= ITERATE; -- Keep iterating; don't stop
                            K_s <= "000";   -- But do restart counting
                            READY_s   <= '1';
                        else
                            state_s <= ITERATE;
                            K_s <= K + 1;
                            READY_s   <= '0';
                        end if;
                    else
                        if start = '1' then
                            state_s <= ITERATE;
                        else
                            state_s <= IDLE;
                        end if;
                        K_s     <= "000";
                        READY_s <= '0';
                    end if;
                else
                    state_s   <= IDLE;
                    K_s       <= "000";
                    READY_s   <= '0';
                end if;
            end process CALC_NEXT;

        -- Assign REGs content
        REG_ASSIGN: process(CLK)
            begin
                if rising_edge(CLK) then
                    state   <= state_s;
                    K       <= K_s;
                    READY   <= READY_s;
                end if;
            end process REG_ASSIGN;

end architecture BHV;
