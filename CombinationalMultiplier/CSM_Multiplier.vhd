--------------------------------------------------------------
--------------------------------------------------------------
-- Copyright Dr. Michaela E. Amoo, Howard University 11/2019
-- 11/2019
-- Adv. Dig. Design. II (496)
-- Bit Slice for Shift-Add Multiplier
-- Final Project
-- Jordan Aley
-- 
--------------------------------------------------------------
-- CSM GENERIC SLICE
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;

ENTITY ALEY_CSMSlice IS
  generic(W: integer :=24);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END CSMSlice;

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

ENTITY ALEY_CSMLastSlice IS
  generic(W: integer :=24);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic;
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END CSMSlice;

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
END behv;

-----------------------------------------------------------------------------------------

--------------------------------------------------------------
-- Multiplier Slice(2 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;

ENTITY ALEY_CSMSlice_2B IS
  generic(W: integer :=24, BBITS: integer :=2);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END CSMSlice;

ARCHITECTURE behv OF ALEY_CSMSlice_2B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;
SIGNAL sAout1: std_logic_vector(w+1 downto 0);
SIGNAL sAout2: std_logic_vector(w+bbits downto 0);

SIGNAL s0: std_logic_vector(w downto 0);
SIGNAL s1: std_logic_vector(w+1 downto 0);.
SIGNAL s2: std_logic_vector(w+BBITS downto 0);

SIGNAL c0: std_logic_vector(w downto 0);
SIGNAL c1: std_logic_vector(w+1 downto 0);.
SIGNAL s2: std_logic_vector(w+BBITS downto 0);


begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), s0, c0, sAout1, s1, c1);
InstALEY_CSMSlice2: ALEY_CSMSlice generic map (W+BBITS-1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);

END behv;

--------------------------------------------------------------
-- Multiplier LAST Slice(2 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;

ENTITY ALEY_CSM_LastSlice_2B IS
  generic(W: integer :=24, BBITS: integer :=2);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END CSMSlice;

ARCHITECTURE behv OF ALEY_CSM_LastSlice_2B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;
SIGNAL sAout1: std_logic_vector(w+1 downto 0);
SIGNAL sAout2: std_logic_vector(w+bbits downto 0);

SIGNAL s0: std_logic_vector(w downto 0);
SIGNAL s1: std_logic_vector(w+1 downto 0);.
SIGNAL s2: std_logic_vector(w+BBITS downto 0);

SIGNAL c0: std_logic_vector(w downto 0);
SIGNAL c1: std_logic_vector(w+1 downto 0);.
SIGNAL s2: std_logic_vector(w+BBITS downto 0);


begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), s0, c0, sAout1, s1, c1);
InstALEY_CSMLastSlice: ALEY_CSMLastSlice generic map (W+BBITS-1) port map( sAout1, InB(1), s1, c1, s2, c2);

END behv;

----------------------------------------------------------------------------------------------------------
--------------------------------------------------------------
-- Multiplier Slice(4 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;

ENTITY ALEY_CSMSlice_4B IS
  generic(W: integer :=24, BBITS: integer :=4);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END CSMSlice;

ARCHITECTURE behv OF ALEY_CSMSlice_4B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;
SIGNAL sAout1: std_logic_vector(w+1 downto 0);
SIGNAL sAout2: std_logic_vector(w+2 downto 0);
SIGNAL sAout3: std_logic_vector(w+3 downto 0);
SIGNAL sAout4: std_logic_vector(w+4 downto 0);

SIGNAL s0: std_logic_vector(w downto 0);
SIGNAL s1: std_logic_vector(w+1 downto 0);.
SIGNAL s2: std_logic_vector(w+2 downto 0);
SIGNAL s3: std_logic_vector(w+3 downto 0);
SIGNAL s4: std_logic_vector(w+BBITS downto 0);

SIGNAL c0: std_logic_vector(w downto 0);
SIGNAL c1: std_logic_vector(w+1 downto 0);.
SIGNAL c2: std_logic_vector(w+2 downto 0);
SIGNAL c3: std_logic_vector(w+3 downto 0);.
SIGNAL c4: std_logic_vector(w+BBITS downto 0);.


begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), s0, c0, sAout1, s1, c1);
InstALEY_CSMSlice2: ALEY_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstALEY_CSMSlice3: ALEY_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstALEY_CSMSlice4: ALEY_CSMSlice generic map (W+BBITS-1) port map( sAout3, InB(3), s3, c3, sAout4, s4, c4);

END behv;

--------------------------------------------------------------
-- LAST Multiplier Slice(4 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;

ENTITY ALEY_CSMLastSlice_4B IS
  generic(W: integer :=24, BBITS: integer :=4);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END CSMSlice;

ARCHITECTURE behv OF ALEY_CSMLastSlice_4B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;
SIGNAL sAout1: std_logic_vector(w+1 downto 0);
SIGNAL sAout2: std_logic_vector(w+2 downto 0);
SIGNAL sAout3: std_logic_vector(w+3 downto 0);
SIGNAL sAout4: std_logic_vector(w+4 downto 0);

SIGNAL s0: std_logic_vector(w downto 0);
SIGNAL s1: std_logic_vector(w+1 downto 0);.
SIGNAL s2: std_logic_vector(w+2 downto 0);
SIGNAL s3: std_logic_vector(w+3 downto 0);
SIGNAL s4: std_logic_vector(w+BBITS downto 0);

SIGNAL c0: std_logic_vector(w downto 0);
SIGNAL c1: std_logic_vector(w+1 downto 0);.
SIGNAL c2: std_logic_vector(w+2 downto 0);
SIGNAL c3: std_logic_vector(w+3 downto 0);.
SIGNAL c4: std_logic_vector(w+BBITS downto 0);.


begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), s0, c0, sAout1, s1, c1);
InstALEY_CSMSlice2: ALEY_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstALEY_CSMSlice3: ALEY_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstALEY_CSMLastSlice: ALEY_CSMLastSlice generic map (W+BBITS-1) port map( sAout3, InB(3), s3, c3, s4, c4);

END behv;

--------------------------------------------------------------
-- Multiplier Slice(6 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;

ENTITY ALEY_CSMSlice_6B IS
  generic(W: integer :=24, BBITS: integer :=6);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END CSMSlice;

ARCHITECTURE behv OF ALEY_CSMSlice_6B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w+1 downto 0);
SIGNAL sAout2: std_logic_vector(w+2 downto 0);
SIGNAL sAout3: std_logic_vector(w+3 downto 0);
SIGNAL sAout4: std_logic_vector(w+4 downto 0);
SIGNAL sAout5: std_logic_vector(w+5 downto 0);
SIGNAL sAout6: std_logic_vector(w+BBITS downto 0);

SIGNAL s0: std_logic_vector(w downto 0);
SIGNAL s1: std_logic_vector(w+1 downto 0);.
SIGNAL s2: std_logic_vector(w+2 downto 0);
SIGNAL s3: std_logic_vector(w+3 downto 0);
SIGNAL s4: std_logic_vector(w+4 downto 0);
SIGNAL s5: std_logic_vector(w+5 downto 0);
SIGNAL s6: std_logic_vector(w+6 downto 0);

SIGNAL c0: std_logic_vector(w downto 0);
SIGNAL c1: std_logic_vector(w+1 downto 0);.
SIGNAL c2: std_logic_vector(w+2 downto 0);
SIGNAL c3: std_logic_vector(w+3 downto 0);.
SIGNAL c4: std_logic_vector(w+4 downto 0);
SIGNAL c5: std_logic_vector(w+5 downto 0);
SIGNAL c6: std_logic_vector(w+BBITS downto 0);


begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), s0, c0, sAout1, s1, c1);
InstALEY_CSMSlice2: ALEY_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstALEY_CSMSlice3: ALEY_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstALEY_CSMSlice4: ALEY_CSMSlice generic map (W+3) port map( sAout3, InB(3), s3, c3, sAout4, s4, c4);
InstALEY_CSMSlice5: ALEY_CSMSlice generic map (W+4) port map( sAout4, InB(4), s4, c4, sAout5, s5, c5);
InstALEY_CSMSlice6: ALEY_CSMSlice generic map (W+BBITS-1) port map( sAout5, InB(5), s5, c5, sAout6, s6, c6);


END behv;

--------------------------------------------------------------
-- LAST Multiplier Slice(6 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;

ENTITY ALEY_CSMLastSlice_6B IS
  generic(W: integer :=24, BBITS: integer :=6);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END CSMSlice;

ARCHITECTURE behv OF ALEY_CSMLastSlice_6B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w+1 downto 0);
SIGNAL sAout2: std_logic_vector(w+2 downto 0);
SIGNAL sAout3: std_logic_vector(w+3 downto 0);
SIGNAL sAout4: std_logic_vector(w+4 downto 0);
SIGNAL sAout5: std_logic_vector(w+5 downto 0);
SIGNAL sAout6: std_logic_vector(w+BBITS downto 0);

SIGNAL s0: std_logic_vector(w downto 0);
SIGNAL s1: std_logic_vector(w+1 downto 0);.
SIGNAL s2: std_logic_vector(w+2 downto 0);
SIGNAL s3: std_logic_vector(w+3 downto 0);
SIGNAL s4: std_logic_vector(w+4 downto 0);
SIGNAL s5: std_logic_vector(w+5 downto 0);
SIGNAL s6: std_logic_vector(w+6 downto 0);

SIGNAL c0: std_logic_vector(w downto 0);
SIGNAL c1: std_logic_vector(w+1 downto 0);.
SIGNAL c2: std_logic_vector(w+2 downto 0);
SIGNAL c3: std_logic_vector(w+3 downto 0);.
SIGNAL c4: std_logic_vector(w+4 downto 0);
SIGNAL c5: std_logic_vector(w+5 downto 0);
SIGNAL c6: std_logic_vector(w+BBITS downto 0);


begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), s0, c0, sAout1, s1, c1);
InstALEY_CSMSlice2: ALEY_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstALEY_CSMSlice3: ALEY_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstALEY_CSMSlice4: ALEY_CSMSlice generic map (W+3) port map( sAout3, InB(3), s3, c3, sAout4, s4, c4);
InstALEY_CSMSlice5: ALEY_CSMSlice generic map (W+4) port map( sAout4, InB(4), s4, c4, sAout5, s5, c5);
InstALEY_CSMLastSlice: ALEY_CSMLastSlice generic map (W+BBITS-1) port map( sAout5, InB(5), s5, c5, s6, c6);


END behv;

--------------------------------------------------------------
-- Multiplier Slice(8 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;

ENTITY ALEY_CSMSlice_8B IS
  generic(W: integer :=24, BBITS: integer :=8);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END CSMSlice;

ARCHITECTURE behv OF ALEY_CSMSlice_8B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w+1 downto 0);
SIGNAL sAout2: std_logic_vector(w+2 downto 0);
SIGNAL sAout3: std_logic_vector(w+3 downto 0);
SIGNAL sAout4: std_logic_vector(w+4 downto 0);
SIGNAL sAout5: std_logic_vector(w+5 downto 0);
SIGNAL sAout6: std_logic_vector(w+6 downto 0);
SIGNAL sAout7: std_logic_vector(w+7 downto 0);
SIGNAL sAout8: std_logic_vector(w+BBITS downto 0);

SIGNAL s0: std_logic_vector(w downto 0);
SIGNAL s1: std_logic_vector(w+1 downto 0);.
SIGNAL s2: std_logic_vector(w+2 downto 0);
SIGNAL s3: std_logic_vector(w+3 downto 0);
SIGNAL s4: std_logic_vector(w+4 downto 0);
SIGNAL s5: std_logic_vector(w+5 downto 0);
SIGNAL s6: std_logic_vector(w+6 downto 0);
SIGNAL s7: std_logic_vector(w+7 downto 0);
SIGNAL s8: std_logic_vector(w+BBITS downto 0);

SIGNAL c0: std_logic_vector(w downto 0);
SIGNAL c1: std_logic_vector(w+1 downto 0);.
SIGNAL c2: std_logic_vector(w+2 downto 0);
SIGNAL c3: std_logic_vector(w+3 downto 0);.
SIGNAL c4: std_logic_vector(w+4 downto 0);
SIGNAL c5: std_logic_vector(w+5 downto 0);
SIGNAL c6: std_logic_vector(w+6 downto 0);
SIGNAL c7: std_logic_vector(w+7 downto 0);
SIGNAL c8: std_logic_vector(w+BBITS downto 0);

begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), s0, c0, sAout1, s1, c1);
InstALEY_CSMSlice2: ALEY_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstALEY_CSMSlice3: ALEY_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstALEY_CSMSlice4: ALEY_CSMSlice generic map (W+3) port map( sAout3, InB(3), s3, c3, sAout4, s4, c4);
InstALEY_CSMSlice5: ALEY_CSMSlice generic map (W+4) port map( sAout4, InB(4), s4, c4, sAout5, s5, c5);
InstALEY_CSMSlice6: ALEY_CSMSlice generic map (W+5) port map( sAout5, InB(5), s5, c5, sAout6, s6, c6);
InstALEY_CSMSlice5: ALEY_CSMSlice generic map (W+6) port map( sAout6, InB(6), s6, c6, sAout7, s7, c7);
InstALEY_CSMSlice6: ALEY_CSMSlice generic map (W+BBITS-1) port map( sAout7, InB(7), s7, c7, sAout8, s8, c8);

END behv;

--------------------------------------------------------------
-- LAST Multiplier Slice(8 Bits per Block)
--------------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;

ENTITY ALEY_CSMLastSlice_8B IS
  generic(W: integer :=24, BBITS: integer :=8);
	PORT(InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END CSMSlice;

ARCHITECTURE behv OF ALEY_CSMLastSlice_8B IS

COMPONENT ALEY_CSMSlice
	GENERIC(W: integer :=24);
	PORT(InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

SIGNAL sAout1: std_logic_vector(w+1 downto 0);
SIGNAL sAout2: std_logic_vector(w+2 downto 0);
SIGNAL sAout3: std_logic_vector(w+3 downto 0);
SIGNAL sAout4: std_logic_vector(w+4 downto 0);
SIGNAL sAout5: std_logic_vector(w+5 downto 0);
SIGNAL sAout6: std_logic_vector(w+6 downto 0);
SIGNAL sAout7: std_logic_vector(w+7 downto 0);
SIGNAL sAout8: std_logic_vector(w+BBITS downto 0);

SIGNAL s0: std_logic_vector(w downto 0);
SIGNAL s1: std_logic_vector(w+1 downto 0);.
SIGNAL s2: std_logic_vector(w+2 downto 0);
SIGNAL s3: std_logic_vector(w+3 downto 0);
SIGNAL s4: std_logic_vector(w+4 downto 0);
SIGNAL s5: std_logic_vector(w+5 downto 0);
SIGNAL s6: std_logic_vector(w+6 downto 0);
SIGNAL s7: std_logic_vector(w+7 downto 0);
SIGNAL s8: std_logic_vector(w+BBITS downto 0);

SIGNAL c0: std_logic_vector(w downto 0);
SIGNAL c1: std_logic_vector(w+1 downto 0);.
SIGNAL c2: std_logic_vector(w+2 downto 0);
SIGNAL c3: std_logic_vector(w+3 downto 0);.
SIGNAL c4: std_logic_vector(w+4 downto 0);
SIGNAL c5: std_logic_vector(w+5 downto 0);
SIGNAL c6: std_logic_vector(w+6 downto 0);
SIGNAL c7: std_logic_vector(w+7 downto 0);
SIGNAL c8: std_logic_vector(w+BBITS downto 0);

begin

InstALEY_CSMSlice1: ALEY_CSMSlice generic map (W) port map( InA, InB(0), s0, c0, sAout1, s1, c1);
InstALEY_CSMSlice2: ALEY_CSMSlice generic map (W+1) port map( sAout1, InB(1), s1, c1, sAout2, s2, c2);
InstALEY_CSMSlice3: ALEY_CSMSlice generic map (W+2) port map( sAout2, InB(2), s2, c2, sAout3, s3, c3);
InstALEY_CSMSlice4: ALEY_CSMSlice generic map (W+3) port map( sAout3, InB(3), s3, c3, sAout4, s4, c4);
InstALEY_CSMSlice5: ALEY_CSMSlice generic map (W+4) port map( sAout4, InB(4), s4, c4, sAout5, s5, c5);
InstALEY_CSMSlice6: ALEY_CSMSlice generic map (W+5) port map( sAout5, InB(5), s5, c5, sAout6, s6, c6);
InstALEY_CSMSlice5: ALEY_CSMSlice generic map (W+6) port map( sAout6, InB(6), s6, c6, sAout7, s7, c7);
InstALEY_CSMLastSlice: ALEY_CSMLastSlice generic map (W+BBITS-1) port map( sAout7, InB(7), s7, c7, s8, c8);

END behv;


---------------------------------------------------------
-- TOP_LEVEL MODULE OF w-bit CARRY SAVE MULTIPLIER
---------------------------------------------------------

Library IEEE;  
use IEEE.std_logic_1164.all;

ENTITY ALEY_CSMultiplier IS
  generic(W: integer :=24);
	PORT(	InA		: IN std_logic_vector(W-1 DOWNTO 0);
		InB		: IN std_logic_vector(W-1 DOWNTO 0);
		SumOut		: OUT std_logic_vector(W DOWNTO 0);
		CarryOut	: OUT std_logic_vector(W DOWNTO 0));
END ALEY_CSMultiplier;

ARCHITECTURE CSM_2B OF ALEY_CSMultiplier IS

COMPONENT ALEY_CSMSlice_2B
  generic(W: integer :=24, BBITS: integer :=2);
	PORT(	InA	: IN std_logic_vector(W-1 DOWNTO 0);
		InB	: IN std_logic_vector(BBITS-1 DOWNTO 0);
		SumIn	: IN std_logic_vector(W-1 DOWNTO 0);
		CarryIn	: IN std_logic_vector(W-1 DOWNTO 0);
		Aout	: OUT std_logic_vector(W DOWNTO 0);
		SumOut	: OUT std_logic_vector(W DOWNTO 0);
		CarryOut: OUT std_logic_vector(W DOWNTO 0));
END COMPONENT;

begin

InstALEY_CSMSlice_2B1: ALEY_CSMSlice2B generic map (W) port map( InA, InB(BBITS-1 downto 0), sSumOut0, sCarryIn, sAout1, sSumOut1, sCarryOut1);
InstALEY_CSMSlice_2B2: ALEY_CSMSlice2B generic map (W+BBITS) port map( sAout1, InB(2*BBITS-1 downto BBITS), sSumOut1, sCarryOut1, sAout2, sSumOut2, sCarryOut2);
InstALEY_CSMSlice_2B3: ALEY_CSMSlice2B generic map (W+2*BBITS) port map( sAout2, InB(3*BBITS-1 downto 2*BBITS), sSumOut2, sCarryOut2, sAout3, sSumOut3, sCarryOut3);
InstALEY_CSMSlice_2B4: ALEY_CSMSlice2B generic map (W+3*BBITS) port map( sAout3, InB(4*BBITS-1 downto 3*BBITS), sSumOut3, sCarryOut3, sAout4, sSumOut4, sCarryOut4);
InstALEY_CSMSlice_2B5: ALEY_CSMSlice2B generic map (W+4*BBITS) port map( sAout4, InB(5*BBITS-1 downto 4*BBITS), sSumOut4, sCarryOut4, sAout5, sSumOut5, sCarryOut5);
InstALEY_CSMSlice_2B6: ALEY_CSMSlice2B generic map (W+5*BBITS) port map( sAout5, InB(6*BBITS-1 downto 5*BBITS), sSumOut5, sCarryOut5, sAout6, sSumOut6, sCarryOut6);
InstALEY_CSMSlice_2B7: ALEY_CSMSlice2B generic map (W+6*BBITS) port map( sAout6, InB(7*BBITS-1 downto 6*BBITS), sSumOut6, sCarryOut6, sAout7, sSumOut7, sCarryOut7);
InstALEY_CSMSlice_2B8: ALEY_CSMSlice2B generic map (W+7*BBITS) port map( sAout7, InB(8*BBITS-1 downto 7*BBITS), sSut7, sCarryOut7, sAout8, sSumOut8, sCarryOut8);
InstALEY_CSMSlice_2B9: ALEY_CSMSlice2B generic map (W+8*BBITS) port map( sAout8, InB(9*BBITS-1 downto 8*BBITS), sSumOut8, sCarryOut8, sAout9, sSumOut9, sCarryOut9);
InstALEY_CSMSlice_2B10: ALEY_CSMSlice2B generic map (W+9*BBITS) port map( sAout9, InB(10*BBITS-1 downto 9*BBITS), sSumOut9, sCarryOut9, sAout10, sSumOut10, sCarryOut10);
InstALEY_CSMSlice_2B11: ALEY_CSMSlice2B generic map (W+0*BBITS) port map( sAout10, InB(11*BBITS-1 downto 10*BBITS), sSumOut10, sCarryOut10, sAout11, sSumOut11, sCarryOut11);

InstALEY_CSMLastSlice_2B: ALEY_CSMSlice2B generic map (W+11*BBITS) port map( InA, InB(12*BBITS-1 downto 11*BBITS), sSumOut11, sCarryOut11, sSumOut12, sCarryOut12);

sSumOut <= sSumOut12+sCarryOut12;
sCarryOut <= 



end CSM_2B;
