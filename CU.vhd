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
    signal current_state:   state_type;
    signal REGed_state:     state_type;
    signal current_k:       k_format;
    signal REGed_K:         k_format;
    signal READY_s:         std_logic;

    begin
        -- current_k is used as output, since I need a combinatorial output
        CALC_NEXT: process(RST, K, current_k, REGed_K, current_state, REGed_state, READY_s)
        begin
            if RST = '0' then
                current_state <= IDLE;
                current_k   <= "000";
                READY_s     <= '0';
            else
                current_state <= ITERATE;

                if REGed_state = IDLE then
                    current_k   <= "000";
                    READY_s     <= '1';
                else
                    if to_integer(REGed_K) < 5 then
                        current_k   <=  REGed_K + 1;
                        READY_s <= '0';
                    else
                        current_k <= "000";
                        READY_s <= '1';
                    end if;
                end if;
            end if;
        end process CALC_NEXT;

        -- Assign combinatorial outputs
        OUT_ASSIGN: process(current_k, READY_s)
        begin
            READY   <= READY_s;
            K       <= current_k;
        end process OUT_ASSIGN;

        -- Assign internal registers; K is not the output but the saved REG
        REG_ASSIGN: process(CLK) begin
            if rising_edge(CLK) then
                REGed_state <= current_state;
                REGed_K <= current_k;
            end if;
        end process REG_ASSIGN;

end architecture BHV;
