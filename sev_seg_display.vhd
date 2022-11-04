library ieee;
use ieee.std_logic_signed.all;
use ieee.std_logic_1164.all;

-- trivial implementation of seven segment display for the score



entity sev_seg_display is
PORT (	
	num_i : in std_logic_vector(3 downto 0);
	sev_seg_o: out std_logic_vector(0 to 6)
	);
end sev_seg_display;


architecture behavioral of sev_seg_display is
	begin
	process(num_i)
		begin
		case num_i is
			when "0000" => sev_seg_o <= "0000001"; -- 0
			when "0001" => sev_seg_o <= "1001111"; -- 1
			when "0010" => sev_seg_o <= "0010010"; -- 2
			when "0011" => sev_seg_o <= "0000110"; -- 3
			when "0100" => sev_seg_o <= "1001100"; -- 4
			when "0101" => sev_seg_o <= "0100100"; -- 5
			when "0110" => sev_seg_o <= "0100000"; -- 6
			when "0111" => sev_seg_o <= "0001111"; -- 7
			when "1000" => sev_seg_o <= "0000000"; -- 8
			when "1001" => sev_seg_o <= "0001100"; -- 9
			when "1010" => sev_seg_o <= "1110001"; -- 10
			when others => sev_Seg_o <= "1111111"; -- ||
		end case;
	end process;
end behavioral;

 
	