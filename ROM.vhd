library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use WORK.pack_FIR.all;

entity ROM is
	port(
        K:          in k_format;
        content:    out data_format
	);
end ROM;

--Contains FIR coefficient values
architecture BHV of ROM is
    signal FIR_coeff: data_format_array := 
    (
        x"00000A",
        x"00000B",
        x"00000C",
        x"00000D",
        x"00000E",
        x"00000F",
        x"000001"
    );

	begin
		process(all) begin
			content <= FIR_coeff(to_integer(K));
		end process;
end BHV;



