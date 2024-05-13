library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;

entity CU is
    port(
        RST:    in std_logic;
        CLK:    in std_logic;
        K:      out k_format;
        READY:  out std_logic
    );
end entity CU;

architecture BHV of CU is
    signal state:   state_type;
    
    begin
        -- Assign REGs content
        REG_ASSIGN: process(CLK, RST, K, READY, state)
            begin
                if rising_edge(CLK) then
                    if RST = '0' then
                        K       <= "000";
                        READY   <= '0';
                        state   <= IDLE;
                    else
                        if state = IDLE then
                            state   <= ITERATE;
                            K       <= "000";
                            READY   <= '1'; 
                        else    -- ITERATE state
                            if to_integer(K) < 5 then
                                state   <= ITERATE;
                                K       <= K+1;
                                READY   <= '0'; 
                            else
                                state   <= ITERATE;
                                K       <= "000";
                                READY   <= '1'; 
                            end if;
                        end if;
                    end if;

                end if;
            end process REG_ASSIGN;

end architecture BHV;
