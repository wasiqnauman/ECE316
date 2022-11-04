library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Generate VGA signal for the display to the monitor
ENTITY VGA IS
PORT(
CLOCK_24: IN STD_LOGIC_VECTOR(1 downto 0);
VGA_HS,VGA_VS:OUT STD_LOGIC;
VGA_R,VGA_B,VGA_G: OUT STD_LOGIC_VECTOR(7 downto 0);
VGA_CLK: OUT STD_LOGIC;
num : out std_logic_vector(3 downto 0);
KEY: IN STD_LOGIC_VECTOR(3 downto 0);
SW: IN STD_LOGIC_VECTOR(1 downto 0);
seven_seg : out std_logic_vector(6 downto 0) 
);
END VGA;


ARCHITECTURE MAIN OF VGA IS
SIGNAL VGACLK,RESET:STD_LOGIC:='0';
 
COMPONENT SYNC IS
 PORT(
	CLK: IN STD_LOGIC;
	HSYNC: OUT STD_LOGIC;
	VSYNC: OUT STD_LOGIC;
	R: OUT STD_LOGIC_VECTOR(7 downto 0);
	G: OUT STD_LOGIC_VECTOR(7 downto 0);
	B: OUT STD_LOGIC_VECTOR(7 downto 0);
	num_out: out std_logic_vector(3 downto 0); 
   KEYS: IN STD_LOGIC_VECTOR(3 downto 0);
   S: IN STD_LOGIC_VECTOR(1 downto 0)
	);
	
END COMPONENT SYNC;
	signal num_o: std_logic_vector(3 downto 0); 

component pll is
		port (
			clk_in_clk  : in  std_logic := 'X'; -- clk
			reset_reset : in  std_logic := 'X'; -- reset
			clk_out_clk : out std_logic         -- clk
		);
end component pll;


-- seven segment display for the score
component sev_seg_display is
	PORT(
		num_i : in std_logic_vector(3 downto 0);
		sev_seg_o: out std_logic_vector(6 downto 0)
	);
end component sev_seg_display; 

BEGIN

 C: pll PORT MAP (CLOCK_24(0),RESET,VGACLK); -- port mappings for PLL
 C1: SYNC PORT MAP(VGACLK,VGA_HS,VGA_VS,VGA_R,VGA_G,VGA_B, num_O, KEY, SW);
 C2: sev_seg_display PORT MAP(num_o, seven_seg); 

 VGA_CLK <= VGACLK;
 
 END MAIN;
 
