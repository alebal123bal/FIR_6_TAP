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
        x"000001",
        x"000002",
        x"000003",
        x"000004",
        x"000005",
        x"000006"
    );

	begin
		process(all) begin
			content <= FIR_coeff(to_integer(K));
		end process;
end BHV;



