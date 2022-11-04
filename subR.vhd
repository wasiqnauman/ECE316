library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- subroutine for drawing the objects
PACKAGE MY IS
PROCEDURE square(SIGNAL Xcur,Ycur,Xpos,Ypos,square_size:IN INTEGER;SIGNAL RGB:OUT STD_LOGIC_VECTOR(3 downto 0);SIGNAL DRAW: OUT STD_LOGIC);
PROCEDURE puck(SIGNAL Xcur,Ycur,Xpos,Ypos:IN INTEGER;SIGNAL RGB:OUT STD_LOGIC_VECTOR(3 downto 0);SIGNAL DRAW: OUT STD_LOGIC);
END MY;

PACKAGE BODY MY IS
PROCEDURE square(SIGNAL Xcur,Ycur,Xpos,Ypos, square_size:IN INTEGER;SIGNAL RGB:OUT STD_LOGIC_VECTOR(3 downto 0);SIGNAL DRAW: OUT STD_LOGIC) IS
BEGIN
-- if Xcur is between Xpos and Xpos+100, and Ycur is betwwen Ypos and Ypos+100, set RGB pixels
-- and set DRAW signal to 1

     IF(Xcur>Xpos AND Xcur<(Xpos+30) AND Ycur>Ypos AND Ycur<(Ypos+square_size))THEN
	     RGB<="1111";
	     DRAW<='1';
     ELSE
	     DRAW<='0';
     END IF;
 
END square;

PROCEDURE puck(SIGNAL Xcur, Ycur, Xpos, Ypos: IN INTEGER; SIGNAL RGB: OUT STD_LOGIC_VECTOR(3 downto 0); SIGNAL DRAW: OUT STD_LOGIC ) IS
BEGIN
-- same logic as the squares
     IF(Xcur>Xpos AND Xcur<(Xpos+10) AND Ycur>Ypos AND Ycur<(Ypos+10))THEN
	     RGB<="1111";
	     DRAW<='1';
     ELSE
	     DRAW<='0';
     END IF;
END puck; 
END MY;


