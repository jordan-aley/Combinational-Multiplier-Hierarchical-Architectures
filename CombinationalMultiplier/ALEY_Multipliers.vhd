--------------------------------------------------------------
--------------------------------------------------------------
-- Copyright Dr. Michaela E. Amoo, Howard University 11/2019
-- 11/2019
-- Adv. Dig. Design. II (496)
-- Bit Slice for Carry-Save Multiplier
-- Jordan Aley
-- 
--------------------------------------------------------------
-- CSM GENERIC SLICE
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY ALEY_CSMSlice IS
  generic(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END ALEY_CSMSlice;

ARCHITECTURE behv OF ALEY_CSMSlice IS

	SIGNAL AB : std_logic_vector(W-1 DOWNTO 0):=(OTHERS=>'0');

BEGIN
	loop1:FOR i IN W-1 DOWNTO 0 GENERATE
			AB(i) <= InA(i) and InB;
		END GENERATE;
	loop2:FOR i IN W-1 DOWNTO 0 GENERATE
    SumOut(i)	<= AB(i) xor SumIn(i) xor CarryIn(i);
		CarryOut(i+1) <= (AB(i) and SumIn(i)) or (AB(i) and CarryIn(i)) or (SumIn(i) and CarryIn(i));
	END GENERATE;
    SumOut(W)	<= '0';
    CarryOut(0) <= '0';
    Aout(W downto 1) <= InA(W-1 downto 0);
    Aout(0)<= '0';
END behv;

--------------------------------------------------------------------
-- CSM LAST SLICE
---------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY ALEY_CSMLastSlice IS
  generic(W: integer :=24);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic;
		SumIn		: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn		: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut		: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END ALEY_CSMLastSlice;

ARCHITECTURE behv OF ALEY_CSMLastSlice IS

	SIGNAL AB : std_logic_vector(W-1 DOWNTO 0):=(OTHERS=>'0');

BEGIN
	loop1:FOR i IN W-1 DOWNTO 0 GENERATE
			AB(i) <= InA(i) and InB;
		END GENERATE;
	loop2:FOR i IN W-1 DOWNTO 0 GENERATE
    SumOut(i)	<= AB(i) xor SumIn(i) xor CarryIn(i);
		CarryOut(i+1) <= (AB(i) and SumIn(i)) or (AB(i) and CarryIn(i)) or (SumIn(i) and CarryIn(i));
	END GENERATE;
    SumOut(W)	<= '0';
    CarryOut(0) <= '0';
END behv;

-----------------------------------------------------------------------------------------

--------------------------------------------------------------
-- Multiplier Slice(2 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY ALEY_CSMSlice_2B IS
  generic(W: integer :=24; BBITS: integer :=2);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END ALEY_CSMSlice_2B;

ARCHITECTURE behv OF ALEY_CSMSlice_2B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);
SIGNAL sAout2: std_logic_vector(w+bbits-1 downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+BBITS-1 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+BBITS-1 downto 0);


begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstALEY_CSMSlice2: ALEY_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);

Aout <= sAout2;
Sumout <= s2;
CarryOut <= c2;

END behv;

--------------------------------------------------------------
-- Multiplier LAST Slice(2 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY ALEY_CSMLastSlice_2B IS
  generic(W: integer :=24; BBITS: integer :=2);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn		: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn		: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut		: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END ALEY_CSMLastSlice_2B;

ARCHITECTURE behv OF ALEY_CSMLastSlice_2B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

COMPONENT ALEY_CSMLastSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+BBITS-1 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+BBITS-1 downto 0);


begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstALEY_CSMLastSlice: ALEY_CSMLastSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, s2, c2);

SumOut <= s2;
CarryOut <= c2;

END behv;

----------------------------------------------------------------------------------------------------------
--------------------------------------------------------------
-- Multiplier Slice(4 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY ALEY_CSMSlice_4B IS
  generic(W: integer :=24; BBITS: integer :=4);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END ALEY_CSMSlice_4B;

ARCHITECTURE behv OF ALEY_CSMSlice_4B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);
SIGNAL sAout2: std_logic_vector(w+1 downto 0);
SIGNAL sAout3: std_logic_vector(w+2 downto 0);
SIGNAL sAout4: std_logic_vector(w+3 downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+1 downto 0);
SIGNAL s3: std_logic_vector(w+2 downto 0);
SIGNAL s4: std_logic_vector(w+BBITS-1 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+1 downto 0);
SIGNAL c3: std_logic_vector(w+2 downto 0);
SIGNAL c4: std_logic_vector(w+BBITS-1 downto 0);

begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstALEY_CSMSlice2: ALEY_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstALEY_CSMSlice3: ALEY_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstALEY_CSMSlice4: ALEY_CSMSlice generic map (W+BBITS-1) port map( sAout3, InB(3), s3, c3, sAout4, s4, c4);

Aout <= sAout4;
Sumout <= s4;
CarryOut <= c4;

END behv;

--------------------------------------------------------------
-- LAST Multiplier Slice(4 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY ALEY_CSMLastSlice_4B IS
  generic(W: integer :=24; BBITS: integer :=4);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END ALEY_CSMLastSlice_4B;

ARCHITECTURE behv OF ALEY_CSMLastSlice_4B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

COMPONENT ALEY_CSMLastSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);
SIGNAL sAout2: std_logic_vector(w+1 downto 0);
SIGNAL sAout3: std_logic_vector(w+2 downto 0);
SIGNAL sAout4: std_logic_vector(w+3 downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+1 downto 0);
SIGNAL s3: std_logic_vector(w+2 downto 0);
SIGNAL s4: std_logic_vector(w+BBITS-1 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+1 downto 0);
SIGNAL c3: std_logic_vector(w+2 downto 0);
SIGNAL c4: std_logic_vector(w+BBITS-1 downto 0);


begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstALEY_CSMSlice2: ALEY_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstALEY_CSMSlice3: ALEY_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);

InstALEY_CSMLastSlice: ALEY_CSMLastSlice generic map (W+3) port map( sAout3, InB(3), s3, c3, s4, c4);

Sumout <= s4;
CarryOut <= c4;

END behv;

--------------------------------------------------------------
-- Multiplier Slice(6 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY ALEY_CSMSlice_6B IS
  generic(W: integer :=24; BBITS: integer :=6);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END ALEY_CSMSlice_6B;

ARCHITECTURE behv OF ALEY_CSMSlice_6B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);
SIGNAL sAout2: std_logic_vector(w+1 downto 0);
SIGNAL sAout3: std_logic_vector(w+2 downto 0);
SIGNAL sAout4: std_logic_vector(w+3 downto 0);
SIGNAL sAout5: std_logic_vector(w+4 downto 0);
SIGNAL sAout6: std_logic_vector(w+BBITS-1 downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+1 downto 0);
SIGNAL s3: std_logic_vector(w+2 downto 0);
SIGNAL s4: std_logic_vector(w+3 downto 0);
SIGNAL s5: std_logic_vector(w+4 downto 0);
SIGNAL s6: std_logic_vector(w+5 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+1 downto 0);
SIGNAL c3: std_logic_vector(w+2 downto 0);
SIGNAL c4: std_logic_vector(w+3 downto 0);
SIGNAL c5: std_logic_vector(w+4 downto 0);
SIGNAL c6: std_logic_vector(w+BBITS-1 downto 0);


begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstALEY_CSMSlice2: ALEY_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstALEY_CSMSlice3: ALEY_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstALEY_CSMSlice4: ALEY_CSMSlice generic map (W+3) port map( sAout3, InB(3), s3, c3, sAout4, s4, c4);
InstALEY_CSMSlice5: ALEY_CSMSlice generic map (W+4) port map( sAout4, InB(4), s4, c4, sAout5, s5, c5);
InstALEY_CSMSlice6: ALEY_CSMSlice generic map (W+BBITS-1) port map( sAout5, InB(5), s5, c5, sAout6, s6, c6);

Aout <= sAout6;
Sumout <= s6;
CarryOut <= c6;

END behv;

--------------------------------------------------------------
-- LAST Multiplier Slice(6 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY ALEY_CSMLastSlice_6B IS
  generic(W: integer :=24; BBITS: integer :=6);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END ALEY_CSMLastSlice_6B;

ARCHITECTURE behv OF ALEY_CSMLastSlice_6B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

COMPONENT ALEY_CSMLastSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);
SIGNAL sAout2: std_logic_vector(w+1 downto 0);
SIGNAL sAout3: std_logic_vector(w+2 downto 0);
SIGNAL sAout4: std_logic_vector(w+3 downto 0);
SIGNAL sAout5: std_logic_vector(w+4 downto 0);
SIGNAL sAout6: std_logic_vector(w+BBITS-1 downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+1 downto 0);
SIGNAL s3: std_logic_vector(w+2 downto 0);
SIGNAL s4: std_logic_vector(w+3 downto 0);
SIGNAL s5: std_logic_vector(w+4 downto 0);
SIGNAL s6: std_logic_vector(w+5 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+1 downto 0);
SIGNAL c3: std_logic_vector(w+2 downto 0);
SIGNAL c4: std_logic_vector(w+3 downto 0);
SIGNAL c5: std_logic_vector(w+4 downto 0);
SIGNAL c6: std_logic_vector(w+BBITS-1 downto 0);


begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstALEY_CSMSlice2: ALEY_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstALEY_CSMSlice3: ALEY_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstALEY_CSMSlice4: ALEY_CSMSlice generic map (W+3) port map( sAout3, InB(3), s3, c3, sAout4, s4, c4);
InstALEY_CSMSlice5: ALEY_CSMSlice generic map (W+4) port map( sAout4, InB(4), s4, c4, sAout5, s5, c5);
InstALEY_CSMLastSlice: ALEY_CSMLastSlice generic map (W+BBITS-1) port map( sAout5, InB(5), s5, c5, s6, c6);

Sumout <= s6;
CarryOut <= c6;
END behv;

--------------------------------------------------------------
-- Multiplier Slice(8 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY ALEY_CSMSlice_8B IS
  generic(W: integer :=24; BBITS: integer :=8);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END ALEY_CSMSlice_8B;

ARCHITECTURE behv OF ALEY_CSMSlice_8B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);
SIGNAL sAout2: std_logic_vector(w+1 downto 0);
SIGNAL sAout3: std_logic_vector(w+2 downto 0);
SIGNAL sAout4: std_logic_vector(w+3 downto 0);
SIGNAL sAout5: std_logic_vector(w+4 downto 0);
SIGNAL sAout6: std_logic_vector(w+5 downto 0);
SIGNAL sAout7: std_logic_vector(w+6 downto 0);
SIGNAL sAout8: std_logic_vector(w+7 downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+1 downto 0);
SIGNAL s3: std_logic_vector(w+2 downto 0);
SIGNAL s4: std_logic_vector(w+3 downto 0);
SIGNAL s5: std_logic_vector(w+4 downto 0);
SIGNAL s6: std_logic_vector(w+5 downto 0);
SIGNAL s7: std_logic_vector(w+6 downto 0);
SIGNAL s8: std_logic_vector(w+BBITS-1 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+1 downto 0);
SIGNAL c3: std_logic_vector(w+2 downto 0);
SIGNAL c4: std_logic_vector(w+3 downto 0);
SIGNAL c5: std_logic_vector(w+4 downto 0);
SIGNAL c6: std_logic_vector(w+5 downto 0);
SIGNAL c7: std_logic_vector(w+6 downto 0);
SIGNAL c8: std_logic_vector(w+BBITS-1 downto 0);

begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstALEY_CSMSlice2: ALEY_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstALEY_CSMSlice3: ALEY_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstALEY_CSMSlice4: ALEY_CSMSlice generic map (W+3) port map( sAout3, InB(3), s3, c3, sAout4, s4, c4);
InstALEY_CSMSlice5: ALEY_CSMSlice generic map (W+4) port map( sAout4, InB(4), s4, c4, sAout5, s5, c5);
InstALEY_CSMSlice6: ALEY_CSMSlice generic map (W+5) port map( sAout5, InB(5), s5, c5, sAout6, s6, c6);
InstALEY_CSMSlice7: ALEY_CSMSlice generic map (W+6) port map( sAout6, InB(6), s6, c6, sAout7, s7, c7);
InstALEY_CSMSlice8: ALEY_CSMSlice generic map (W+BBITS-1) port map( sAout7, InB(7), s7, c7, sAout8, s8, c8);

Aout <= sAout8;
Sumout <= s8;
CarryOut <= c8;

END behv;

--------------------------------------------------------------
-- LAST Multiplier Slice(8 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY ALEY_CSMLastSlice_8B IS
  generic(W: integer :=24; BBITS: integer :=8);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END ALEY_CSMLastSlice_8B;

ARCHITECTURE behv OF ALEY_CSMLastSlice_8B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

COMPONENT ALEY_CSMLastSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w downto 0);
SIGNAL sAout2: std_logic_vector(w+1 downto 0);
SIGNAL sAout3: std_logic_vector(w+2 downto 0);
SIGNAL sAout4: std_logic_vector(w+3 downto 0);
SIGNAL sAout5: std_logic_vector(w+4 downto 0);
SIGNAL sAout6: std_logic_vector(w+5 downto 0);
SIGNAL sAout7: std_logic_vector(w+6 downto 0);

SIGNAL s1: std_logic_vector(w downto 0);
SIGNAL s2: std_logic_vector(w+1 downto 0);
SIGNAL s3: std_logic_vector(w+2 downto 0);
SIGNAL s4: std_logic_vector(w+3 downto 0);
SIGNAL s5: std_logic_vector(w+4 downto 0);
SIGNAL s6: std_logic_vector(w+5 downto 0);
SIGNAL s7: std_logic_vector(w+6 downto 0);
SIGNAL s8: std_logic_vector(w+7 downto 0);

SIGNAL c1: std_logic_vector(w downto 0);
SIGNAL c2: std_logic_vector(w+1 downto 0);
SIGNAL c3: std_logic_vector(w+2 downto 0);
SIGNAL c4: std_logic_vector(w+3 downto 0);
SIGNAL c5: std_logic_vector(w+4 downto 0);
SIGNAL c6: std_logic_vector(w+5 downto 0);
SIGNAL c7: std_logic_vector(w+6 downto 0);
SIGNAL c8: std_logic_vector(w+7 downto 0);

begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), SumIn, CarryIn, sAout1, s1, c1);
InstALEY_CSMSlice2: ALEY_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstALEY_CSMSlice3: ALEY_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstALEY_CSMSlice4: ALEY_CSMSlice generic map (W+3) port map( sAout3, InB(3), s3, c3, sAout4, s4, c4);
InstALEY_CSMSlice5: ALEY_CSMSlice generic map (W+4) port map( sAout4, InB(4), s4, c4, sAout5, s5, c5);
InstALEY_CSMSlice6: ALEY_CSMSlice generic map (W+5) port map( sAout5, InB(5), s5, c5, sAout6, s6, c6);
InstALEY_CSMSlice7: ALEY_CSMSlice generic map (W+6) port map( sAout6, InB(6), s6, c6, sAout7, s7, c7);
InstALEY_CSMLastSlice: ALEY_CSMLastSlice generic map (W+BBITS-1) port map( sAout7, InB(7), s7, c7, s8, c8);

Sumout <= s8;
CarryOut <= c8;
END behv;


---------------------------------------------------------
-- TOP_LEVEL MODULE OF w-bit CARRY SAVE MULTIPLIER
---------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

ENTITY ALEY_CSMultiplier IS
  generic(W: integer :=24; BITS2: integer :=2; BITS4:integer :=4; BITS6:integer :=6; BITS8:integer :=8);
	PORT(	InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut		: OUT std_logic_vector(2*W-1 DOWNTO 0));
END ALEY_CSMultiplier;

ARCHITECTURE CSM_2B OF ALEY_CSMultiplier IS

COMPONENT ALEY_CSMSlice_2B
  generic(W: integer :=24; BBITS: integer :=2);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END COMPONENT;

COMPONENT ALEY_CSMLastSlice_2B
  generic(W: integer :=24; BBITS: integer :=2);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W+BBITS-1 DOWNTO 0);
		CarryOut: OUT std_logic_vector(W+BBITS-1 DOWNTO 0));
END COMPONENT;

SIGNAL sSumOut0 : std_logic_vector(W-1 downto 0) := (others => '0');
SIGNAL sSumOut1 : std_logic_vector(W+BITS2-1 downto 0);
SIGNAL sSumOut2 : std_logic_vector(W+2*BITS2-1 downto 0);
SIGNAL sSumOut3 : std_logic_vector(W+3*BITS2-1 downto 0);
SIGNAL sSumOut4 : std_logic_vector(W+4*BITS2-1 downto 0);
SIGNAL sSumOut5 : std_logic_vector(W+5*BITS2-1 downto 0);
SIGNAL sSumOut6 : std_logic_vector(W+6*BITS2-1 downto 0);
SIGNAL sSumOut7 : std_logic_vector(W+7*BITS2-1 downto 0);
SIGNAL sSumOut8 : std_logic_vector(W+8*BITS2-1 downto 0);
SIGNAL sSumOut9 : std_logic_vector(W+9*BITS2-1 downto 0);
SIGNAL sSumOut10 : std_logic_vector(W+10*BITS2-1 downto 0);
SIGNAL sSumOut11 : std_logic_vector(W+11*BITS2-1 downto 0);
SIGNAL sSumOut12 : std_logic_vector(W+12*BITS2-1 downto 0);

SIGNAL sAout1 : std_logic_vector(W+BITS2-1 downto 0);
SIGNAL sAout2 : std_logic_vector(W+2*BITS2-1 downto 0);
SIGNAL sAout3 : std_logic_vector(W+3*BITS2-1 downto 0);
SIGNAL sAout4 : std_logic_vector(W+4*BITS2-1 downto 0);
SIGNAL sAout5 : std_logic_vector(W+5*BITS2-1 downto 0);
SIGNAL sAout6 : std_logic_vector(W+6*BITS2-1 downto 0);
SIGNAL sAout7 : std_logic_vector(W+7*BITS2-1 downto 0);
SIGNAL sAout8 : std_logic_vector(W+8*BITS2-1 downto 0);
SIGNAL sAout9 : std_logic_vector(W+9*BITS2-1 downto 0);
SIGNAL sAout10 : std_logic_vector(W+10*BITS2-1 downto 0);
SIGNAL sAout11 : std_logic_vector(W+11*BITS2-1 downto 0);

SIGNAL sCarryIn : std_logic_vector(W-1 downto 0) := (others => '0');
SIGNAL sCarryOut1 : std_logic_vector(W+BITS2-1 downto 0);
SIGNAL sCarryOut2 : std_logic_vector(W+2*BITS2-1 downto 0);
SIGNAL sCarryOut3 : std_logic_vector(W+3*BITS2-1 downto 0);
SIGNAL sCarryOut4 : std_logic_vector(W+4*BITS2-1 downto 0);
SIGNAL sCarryOut5 : std_logic_vector(W+5*BITS2-1 downto 0);
SIGNAL sCarryOut6 : std_logic_vector(W+6*BITS2-1 downto 0);
SIGNAL sCarryOut7 : std_logic_vector(W+7*BITS2-1 downto 0);
SIGNAL sCarryOut8 : std_logic_vector(W+8*BITS2-1 downto 0);
SIGNAL sCarryOut9 : std_logic_vector(W+9*BITS2-1 downto 0);
SIGNAL sCarryOut10 : std_logic_vector(W+10*BITS2-1 downto 0);
SIGNAL sCarryOut11 : std_logic_vector(W+11*BITS2-1 downto 0);
SIGNAL sCarryOut12 : std_logic_vector(W+12*BITS2-1 downto 0);

begin

InstALEY_CSMSlice_2B1: ALEY_CSMSlice_2B generic map (W) port map( InA, InB(BITS2-1 downto 0), sSumOut0, sCarryIn, sAout1, sSumOut1, sCarryOut1);
InstALEY_CSMSlice_2B2: ALEY_CSMSlice_2B generic map (W+BITS2) port map( sAout1, InB(2*BITS2-1 downto BITS2), sSumOut1, sCarryOut1, sAout2, sSumOut2, sCarryOut2);
InstALEY_CSMSlice_2B3: ALEY_CSMSlice_2B generic map (W+2*BITS2) port map( sAout2, InB(3*BITS2-1 downto 2*BITS2), sSumOut2, sCarryOut2, sAout3, sSumOut3, sCarryOut3);
InstALEY_CSMSlice_2B4: ALEY_CSMSlice_2B generic map (W+3*BITS2) port map( sAout3, InB(4*BITS2-1 downto 3*BITS2), sSumOut3, sCarryOut3, sAout4, sSumOut4, sCarryOut4);
InstALEY_CSMSlice_2B5: ALEY_CSMSlice_2B generic map (W+4*BITS2) port map( sAout4, InB(5*BITS2-1 downto 4*BITS2), sSumOut4, sCarryOut4, sAout5, sSumOut5, sCarryOut5);
InstALEY_CSMSlice_2B6: ALEY_CSMSlice_2B generic map (W+5*BITS2) port map( sAout5, InB(6*BITS2-1 downto 5*BITS2), sSumOut5, sCarryOut5, sAout6, sSumOut6, sCarryOut6);
InstALEY_CSMSlice_2B7: ALEY_CSMSlice_2B generic map (W+6*BITS2) port map( sAout6, InB(7*BITS2-1 downto 6*BITS2), sSumOut6, sCarryOut6, sAout7, sSumOut7, sCarryOut7);
InstALEY_CSMSlice_2B8: ALEY_CSMSlice_2B generic map (W+7*BITS2) port map( sAout7, InB(8*BITS2-1 downto 7*BITS2), sSumOut7, sCarryOut7, sAout8, sSumOut8, sCarryOut8);
InstALEY_CSMSlice_2B9: ALEY_CSMSlice_2B generic map (W+8*BITS2) port map( sAout8, InB(9*BITS2-1 downto 8*BITS2), sSumOut8, sCarryOut8, sAout9, sSumOut9, sCarryOut9);
InstALEY_CSMSlice_2B10: ALEY_CSMSlice_2B generic map (W+9*BITS2) port map( sAout9, InB(10*BITS2-1 downto 9*BITS2), sSumOut9, sCarryOut9, sAout10, sSumOut10, sCarryOut10);
InstALEY_CSMSlice_2B11: ALEY_CSMSlice_2B generic map (W+10*BITS2) port map( sAout10, InB(11*BITS2-1 downto 10*BITS2), sSumOut10, sCarryOut10, sAout11, sSumOut11, sCarryOut11);

InstALEY_CSMLastSlice_2B12: ALEY_CSMLastSlice_2B generic map (W+11*BITS2) port map( sAout11, InB(12*BITS2-1 downto 11*BITS2), sSumOut11, sCarryOut11, sSumOut12, sCarryOut12);

SumOut <= sSumOut12 + sCarryOut12;


end CSM_2B;

-----------------------------------------------------------

ARCHITECTURE CSM_4B OF ALEY_CSMultiplier IS

COMPONENT ALEY_CSMSlice_4B
  generic(W: integer :=24; BBITS: integer :=4);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

COMPONENT ALEY_CSMLastSlice_4B
  generic(W: integer :=24; BBITS: integer :=4);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sSumOut0 : std_logic_vector(W-1 downto 0) := (others => '0');
SIGNAL sSumOut1 : std_logic_vector(W+BITS4-1 downto 0);
SIGNAL sSumOut2 : std_logic_vector(W+2*BITS4-1 downto 0);
SIGNAL sSumOut3 : std_logic_vector(W+3*BITS4-1 downto 0);
SIGNAL sSumOut4 : std_logic_vector(W+4*BITS4-1 downto 0);
SIGNAL sSumOut5 : std_logic_vector(W+5*BITS4-1 downto 0);
SIGNAL sSumOut6 : std_logic_vector(W+6*BITS4-1 downto 0);


SIGNAL sAout1 : std_logic_vector(W+BITS4-1 downto 0);
SIGNAL sAout2 : std_logic_vector(W+2*BITS4-1 downto 0);
SIGNAL sAout3 : std_logic_vector(W+3*BITS4-1 downto 0);
SIGNAL sAout4 : std_logic_vector(W+4*BITS4-1 downto 0);
SIGNAL sAout5 : std_logic_vector(W+5*BITS4-1 downto 0);

SIGNAL sCarryIn : std_logic_vector(W-1 downto 0) := (others => '0');
SIGNAL sCarryOut1 : std_logic_vector(W+BITS4-1 downto 0);
SIGNAL sCarryOut2 : std_logic_vector(W+2*BITS4-1 downto 0);
SIGNAL sCarryOut3 : std_logic_vector(W+3*BITS4-1 downto 0);
SIGNAL sCarryOut4 : std_logic_vector(W+4*BITS4-1 downto 0);
SIGNAL sCarryOut5 : std_logic_vector(W+5*BITS4-1 downto 0);
SIGNAL sCarryOut6 : std_logic_vector(W+6*BITS4-1 downto 0);


begin

InstALEY_CSMSlice_4B1: ALEY_CSMSlice_4B generic map (W) port map( InA, InB(BITS4-1 downto 0), sSumOut0, sCarryIn, sAout1, sSumOut1, sCarryOut1);
InstALEY_CSMSlice_4B2: ALEY_CSMSlice_4B generic map (W+BITS4) port map( sAout1, InB(2*BITS4-1 downto BITS4), sSumOut1, sCarryOut1, sAout2, sSumOut2, sCarryOut2);
InstALEY_CSMSlice_4B3: ALEY_CSMSlice_4B generic map (W+2*BITS4) port map( sAout2, InB(3*BITS4-1 downto 2*BITS4), sSumOut2, sCarryOut2, sAout3, sSumOut3, sCarryOut3);
InstALEY_CSMSlice_4B4: ALEY_CSMSlice_4B generic map (W+3*BITS4) port map( sAout3, InB(4*BITS4-1 downto 3*BITS4), sSumOut3, sCarryOut3, sAout4, sSumOut4, sCarryOut4);
InstALEY_CSMSlice_4B5: ALEY_CSMSlice_4B generic map (W+4*BITS4) port map( sAout4, InB(5*BITS4-1 downto 4*BITS4), sSumOut4, sCarryOut4, sAout5, sSumOut5, sCarryOut5);

InstALEY_CSMLastSlice_4B: ALEY_CSMLastSlice_4B generic map (W+5*BITS4) port map( sAout5, InB(6*BITS4-1 downto 5*BITS4), sSumOut5, sCarryOut5, sSumOut6, sCarryOut6);

SumOut <= sSumOut6+sCarryOut6;

end CSM_4B;

-----------------------------------------------------------

ARCHITECTURE CSM_6B OF ALEY_CSMultiplier IS

COMPONENT ALEY_CSMSlice_6B
  generic(W: integer :=24; BBITS: integer :=6);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

COMPONENT ALEY_CSMLastSlice_6B
  generic(W: integer :=24; BBITS: integer :=6);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sSumOut0 : std_logic_vector(W-1 downto 0) := (others => '0');
SIGNAL sSumOut1 : std_logic_vector(W+BITS6-1 downto 0);
SIGNAL sSumOut2 : std_logic_vector(W+2*BITS6-1 downto 0);
SIGNAL sSumOut3 : std_logic_vector(W+3*BITS6-1 downto 0);
SIGNAL sSumOut4 : std_logic_vector(W+4*BITS6-1 downto 0);

SIGNAL sAout1 : std_logic_vector(W+BITS6-1 downto 0);
SIGNAL sAout2 : std_logic_vector(W+2*BITS6-1 downto 0);
SIGNAL sAout3 : std_logic_vector(W+3*BITS6-1 downto 0);

SIGNAL sCarryIn : std_logic_vector(W-1 downto 0) := (others => '0');
SIGNAL sCarryOut1 : std_logic_vector(W+BITS6-1 downto 0);
SIGNAL sCarryOut2 : std_logic_vector(W+2*BITS6-1 downto 0);
SIGNAL sCarryOut3 : std_logic_vector(W+3*BITS6-1 downto 0);
SIGNAL sCarryOut4 : std_logic_vector(W+4*BITS6-1 downto 0);

begin

InstALEY_CSMSlice_6B1: ALEY_CSMSlice_6B generic map (W) port map( InA, InB(BITS6-1 downto 0), sSumOut0, sCarryIn, sAout1, sSumOut1, sCarryOut1);
InstALEY_CSMSlice_6B2: ALEY_CSMSlice_6B generic map (W+BITS6) port map( sAout1, InB(2*BITS6-1 downto BITS6), sSumOut1, sCarryOut1, sAout2, sSumOut2, sCarryOut2);
InstALEY_CSMSlice_6B3: ALEY_CSMSlice_6B generic map (W+2*BITS6) port map( sAout2, InB(3*BITS6-1 downto 2*BITS6), sSumOut2, sCarryOut2, sAout3, sSumOut3, sCarryOut3);

InstALEY_CSMLastSlice_6B: ALEY_CSMLastSlice_6B generic map (W+3*BITS6) port map( sAout3, InB(4*BITS6-1 downto 3*BITS6), sSumOut3, sCarryOut3, sSumOut4, sCarryOut4);

SumOut <= sSumOut4 + sCarryOut4;


end CSM_6B;


-----------------------------------------------------------

ARCHITECTURE CSM_8B OF ALEY_CSMultiplier IS

COMPONENT ALEY_CSMSlice_8B
  generic(W: integer :=24; BBITS: integer :=8);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

COMPONENT ALEY_CSMLastSlice_8B
  generic(W: integer :=24; BBITS: integer :=8);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sSumOut0 : std_logic_vector(W-1 downto 0) := (others => '0');
SIGNAL sSumOut1 : std_logic_vector(W+BITS8-1 downto 0);
SIGNAL sSumOut2 : std_logic_vector(W+2*BITS8-1 downto 0);
SIGNAL sSumOut3 : std_logic_vector(W+3*BITS8-1 downto 0);

SIGNAL sAout1 : std_logic_vector(W+BITS8-1 downto 0);
SIGNAL sAout2 : std_logic_vector(W+2*BITS8-1 downto 0);

SIGNAL sCarryIn : std_logic_vector(W-1 downto 0) := (others => '0');
SIGNAL sCarryOut1 : std_logic_vector(W+BITS8-1 downto 0);
SIGNAL sCarryOut2 : std_logic_vector(W+2*BITS8-1 downto 0);
SIGNAL sCarryOut3 : std_logic_vector(W+3*BITS8-1 downto 0);

begin

InstALEY_CSMSlice_8B1: ALEY_CSMSlice_8B generic map (W) port map( InA, InB(BITS8-1 downto 0), sSumOut0, sCarryIn, sAout1, sSumOut1, sCarryOut1);
InstALEY_CSMSlice_8B2: ALEY_CSMSlice_8B generic map (W+BITS8) port map( sAout1, InB(2*BITS8-1 downto BITS8), sSumOut1, sCarryOut1, sAout2, sSumOut2, sCarryOut2);

InstALEY_CSMLastSlice_8B: ALEY_CSMLastSlice_8B generic map (W+2*BITS8) port map( sAout2, InB(3*BITS8-1 downto 2*BITS8), sSumOut2, sCarryOut2, sSumOut3, sCarryOut3);

SumOut <= sSumOut3 + sCarryOut3;

end CSM_8B;

