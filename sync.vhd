 library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.my.all;

ENTITY SYNC IS
PORT(
CLK: IN STD_LOGIC;
HSYNC: OUT STD_LOGIC;					-- horizontal sync
VSYNC: OUT STD_LOGIC;					-- vertical sync
R: OUT STD_LOGIC_VECTOR(7 downto 0);	-- color values for the display
G: OUT STD_LOGIC_VECTOR(7 downto 0);
B: OUT STD_LOGIC_VECTOR(7 downto 0);
num_out : OUT STD_LOGIC_VECTOR(3 downto 0); 

-- keys to control the movement of the squares
KEYS: IN STD_LOGIC_VECTOR(3 downto 0);
S: IN STD_LOGIC_VECTOR(1 downto 0)
);
END SYNC;


ARCHITECTURE MAIN OF SYNC IS
SIGNAL RGB: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL DRAW1, DRAW2, DRAWP: STD_LOGIC;	-- signal to draw square1, square2, and the puck

-- positional indicators for square-1
SIGNAL square1_x_axis: INTEGER RANGE 0 TO 1688:=450;
SIGNAL square1_y_axis: INTEGER RANGE 0 TO 1688:=600;
SIGNAL square_size: INTEGER RANGE 0 TO 100:=100;
SIGNAL default_square_size : INTEGER := 100;
-- positional indicators for square-2
SIGNAL square2_x_axis: INTEGER RANGE 0 TO 1688:=1580;
SIGNAL square2_y_axis: INTEGER RANGE 0 to 1688:= 600; 

SIGNAL px: INTEGER RANGE 0 to 1688 := 400;
SIGNAL py: INTEGER RANGE 0 to 1688 := 600;
SIGNAL DIR: INTEGER RANGE 0 TO 1:=0;
SIGNAL block_speed: INTEGER RANGE 0 TO 15:=5;
SIGNAL endofgame: INTEGER RANGE 0 to 1:= 0; 

SIGNAL collision : INTEGER RANGE 0 to 10 := 0;
-- current position on screen
SIGNAL HPOS: INTEGER RANGE 0 TO 1688:=0;
SIGNAL VPOS: INTEGER RANGE 0 TO 1066:=0;

BEGIN

--draw the two players and the puck
square(HPOS,VPOS,square1_x_axis,square1_y_axis,default_square_size,RGB,DRAW1);
square(HPOS,VPOS,square2_x_axis,square2_y_axis,square_size,RGB, DRAW2);
puck(HPOS, VPOS, px, py, RGB, DRAWP);

 PROCESS(CLK)
 BEGIN


IF(CLK'EVENT AND CLK='1')THEN
-----------------------------------------------
-- code to control the squares
    IF(DRAW1='1')THEN
    -- if square1 is selected, draw it in red otherwise draw it in white
        IF(S(0)='1')THEN
            R<=(OTHERS=>'1');
            G<=(OTHERS=>'0');
            B<=(OTHERS=>'0');
        ELSE 
            R<=(OTHERS=>'1');
            G<=(OTHERS=>'1');
            B<=(OTHERS=>'1'); 
        END IF;
    END IF;

    IF(DRAW2='1')THEN
   --  if s1 is toggled, the bar moves automatically
        IF(S(1)='1')THEN
            R<=(OTHERS=>'0');
            G<=(OTHERS=>'1');
            B<=(OTHERS=>'1');	
				
        ELSE
            R<=(OTHERS=>'1');
            G<=(OTHERS=>'1');
            B<=(OTHERS=>'1');
        END IF;
		  
		  
		  --color change on p2 on collision
		  IF (collision >= 1) THEN
					case (collision mod 7) is
						when 0 => 
							R<= "11111111"; 
							G<="00000000"; 
							B<="11111111";
						when 1 => 
							R<= "11110000"; 
							G<="00000000"; 
							B<="11111111"; 
						when 2 => 
							R<= "11110000"; 
							G<="00000000"; 
							B<="11110000";
						when 3 => 
							R<= "11110000"; 
							G<="00000000"; 
							B<="00001111";
						when 4 => 
							R<= "11111111"; 
							G<="11110000"; 
							B<="00000000";
						when 5 => 
							R<= "00000000"; 
							G<="10101110"; 
							B<="10101010";
						when 6 => 
							R<= "10101010"; 
							G<="00000000"; 
							B<="10101010";
							
						when others =>
							R<= "11111111"; 
							G<="11000100"; 
							B<="11111111";	
					END CASE;
		END IF; 
    END IF;

    
    IF(DRAW1='0' AND DRAW2='0')THEN
        R<=(OTHERS=>'0');
        G<=(OTHERS=>'0');
        B<=(OTHERS=>'0');
    END IF;
	 
    IF(DRAWP='1')THEN
        R<=(OTHERS=>'0');
        G<=(OTHERS=>'1');
        B<=(OTHERS=>'0');
    END IF;
	 
	 IF(endofgame = 1) THEN
	     R<=(OTHERS=>'0');
        G<=(OTHERS=>'0');
        B<=(OTHERS=>'0');
	 END IF;
-----------------------------------------------
	--Frame control code
    IF (HPOS<1688)THEN
        HPOS<=HPOS+1;
    ELSE
        HPOS<=0;
        IF(VPOS<1066)THEN
            VPOS<=VPOS+1;
        ELSE
				--collisions to sev seg control code
				case collision is
					when 0 => num_out <= "0000";
					when 1 => num_out <= "0001";
					when 2 => num_out <= "0010";
					when 3 => num_out <= "0011";
					when 4 => num_out <= "0100";
					when 5 => num_out <= "0101";
					when 6 => num_out <= "0110";
					when 7 => num_out <= "0111";
					when 8 => num_out <= "1000";
					when 9 => num_out <= "1001";
					when 10 => num_out <="1010";
					
					when others => num_out <="1111";
				END CASE;
				
				-- the shooting puck
				IF(px<1688)THEN
					IF(px+10 >= square2_x_axis and py>= square2_y_axis and py<=square2_y_axis+100) THEN
						collision<= collision + 1;
						IF(collision = 9) THEN
							endofgame <= 1;
						END IF;
						
						--we want to end the game to stop speeding up p2 after 3 hits
						IF(block_speed <= 15) THEN 
						block_speed<=block_speed+5;
						ELSE
						block_speed <= 5; 
						END IF; 

						--we want the game to end when p2 gets 10 hits, so its size would be 0
						IF(square_size > 0) THEN
							square_size <= square_size - 10;
						ELSE
							endofgame <= 1;
						END IF; 

						py<=1000;
					END IF;
					px<=px+10;
				ELSE
					px<=square1_x_axis+30;
					py<=square1_y_axis+50;
				END IF;
            -- CONTROL THE SQUARES
            IF(S(0)='1')THEN
                IF(KEYS(0)='0')THEN
                    square1_y_axis<=square1_y_axis+5;
                END IF;
                IF(KEYS(1)='0')THEN
                    square1_y_axis<=square1_y_axis-5;
                END IF;
                IF(KEYS(2)='0')THEN
                    square2_y_axis<=square2_y_axis+block_speed;
						  DIR <= 0; --going down
                END IF;
                IF(KEYS(3)='0')THEN
                    square2_y_axis<=square2_y_axis-block_speed;
						  DIR <= 1;  --going up
                END IF;
            END IF;
				 IF(S(1)='1')THEN
					IF(DIR=0 and square2_y_axis>= 0 and square2_y_axis<1600)THEN --going down
						square2_y_axis<=square2_y_axis+block_speed;
					ELSE
						IF(DIR=1 and square2_y_axis>0) THEN -- going up and reach a certain pt
							square2_y_axis<= square2_y_axis-block_speed;
						END IF;
					END IF;
				 ELSE
					IF(DIR = 0 and square2_y_axis >= 1000) THEN
						square2_y_axis <= square2_y_axis - block_speed;
					ELSE
						IF(DIR = 1 and square2_y_axis <= 0 + square_size - (square_size/2)) THEN
							square2_y_axis <= square2_y_axis + block_speed; 
						END IF; 
					END IF; 
				 END IF;
--             IF(S(1)='1')THEN
--                IF(KEYS(0)='0')THEN
--                    square2_x_axis<=square2_x_axis+5;
--                END IF;
--                IF(KEYS(1)='0')THEN
--                    square2_x_axis<=square2_x_axis-5;
--                END IF;
--                 IF(KEYS(2)='0')THEN
--                    square2_y_axis<=square2_y_axis+5;
--                END IF;
--                IF(KEYS(3)='0')THEN
--                    square2_y_axis<=square2_y_axis-5;
--                END IF;
--            END IF;

            VPOS<=0;
        END IF;
    END IF;
	
	--Porch control code
	-- HSYNC goes low between FP and BP
    IF(HPOS>48 AND HPOS<160)THEN
        HSYNC<='0';
    ELSE
        HSYNC<='1';
    END IF;
    IF(VPOS>0 AND VPOS<4)THEN
        VSYNC<='0';
    ELSE
        VSYNC<='1';
    END IF;
	--Synch control code
	-- RGB signal should go low from FP to BP
    IF ((HPOS>0 AND HPOS<408) OR (VPOS > 0 AND VPOS < 42))THEN
        R<=(OTHERS=>'0');
        G<=(OTHERS=>'0');
        B<=(OTHERS=>'0');
    END IF;


 END IF;
 END PROCESS;
 END MAIN;
