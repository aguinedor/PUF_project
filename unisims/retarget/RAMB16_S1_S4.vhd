-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 12.1
--  \   \         Description : Xilinx Functional Simulation Library Component
--  /   /                    16K-Bit Data and 2K-Bit Parity Dual Port Block RAM
-- /___/   /\     Filename : RAMB16_S1_S4.vhd
-- \   \  /  \    Timestamp : Thu Oct 28 11:24:54 PST 2010
--  \___\/\___\
--
-- Revision:
--    10/28/10 - Initial version.
--    03/16/12 - Fixed INIT and SRVAL std to and downto problem (CR 651817).
--    03/10/14 - Fixed INIT and SRVAL range problem (CR 777788).
--    10/08/14 - Added SIM_COLLISION_CHECK generic (CR 816426).
-- End Revision

----- CELL RAMB16_S1_S4 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_SIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;



library unisim;
use unisim.VPKG.all;
use unisim.VCOMPONENTS.all;



entity RAMB16_S1_S4 is

  generic (

    INIT_00 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_01 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_02 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_03 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_04 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_05 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_06 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_07 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_08 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_09 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_0F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_10 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_11 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_12 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_13 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_14 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_15 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_16 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_17 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_18 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_19 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_1F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_20 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_21 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_22 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_23 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_24 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_25 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_26 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_27 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_28 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_29 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_2F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_30 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_31 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_32 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_33 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_34 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_35 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_36 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_37 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_38 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_39 : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3A : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3B : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3C : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3D : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3E : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";
    INIT_3F : bit_vector := X"0000000000000000000000000000000000000000000000000000000000000000";


    INIT_A : bit_vector := X"0";
    INIT_B : bit_vector := X"0";


    SIM_COLLISION_CHECK : string := "ALL";

    SRVAL_A : bit_vector := X"0";
    SRVAL_B : bit_vector := X"0";

    WRITE_MODE_A : string := "WRITE_FIRST";
    WRITE_MODE_B : string := "WRITE_FIRST"
    );

  port(
    DOA  : out std_logic_vector(0 downto 0);
    DOB  : out std_logic_vector(3 downto 0);

    ADDRA : in std_logic_vector(13 downto 0);
    ADDRB : in std_logic_vector(11 downto 0);
    CLKA  : in std_ulogic;
    CLKB  : in std_ulogic;
    DIA   : in std_logic_vector(0 downto 0);
    DIB   : in std_logic_vector(3 downto 0);
    ENA   : in std_ulogic;
    ENB   : in std_ulogic;
    SSRA  : in std_ulogic;
    SSRB  : in std_ulogic;
    WEA   : in std_ulogic;
    WEB   : in std_ulogic
    );
end RAMB16_S1_S4;


architecture RAMB16_S1_S4_V of RAMB16_S1_S4 is
signal DOA_BUS : std_logic_vector(15 downto 0);
signal DOB_BUS : std_logic_vector(15 downto 0);
signal DIA_BUS : std_logic_vector(15 downto 0);
signal DIB_BUS : std_logic_vector(15 downto 0);
signal WEA_BUS : std_logic_vector(1 downto 0);
signal WEB_BUS : std_logic_vector(3 downto 0);
signal ADDRB_BUS : std_logic_vector(13 downto 0);
begin
     WEA_BUS <= "0" & WEA;
     WEB_BUS <= "000" & WEB;
     DIA_BUS <= "000000000000000" & DIA(0);
     DIB_BUS <= "000000000000" & DIB;
     ADDRB_BUS <= ADDRB(11 downto 0) & "0" & "0";
     R1 : RAMB18E1
     generic map (
	INIT_A => INIT_A,
	INIT_B => INIT_B,
	SRVAL_A => SRVAL_A,
	SRVAL_B => SRVAL_B,
	WRITE_MODE_A => WRITE_MODE_A,
	WRITE_MODE_B => WRITE_MODE_B,
	READ_WIDTH_A => 1,
	READ_WIDTH_B => 4,
	WRITE_WIDTH_A => 1,
	WRITE_WIDTH_B => 4,
        SIM_COLLISION_CHECK => SIM_COLLISION_CHECK,
	SIM_DEVICE => "VIRTEX6",
        RSTREG_PRIORITY_A => "REGCE",
        RSTREG_PRIORITY_B => "REGCE",
        INIT_00 => INIT_00, 
	INIT_01 => INIT_01, 
	INIT_02 => INIT_02, 
	INIT_03 => INIT_03, 
	INIT_04 => INIT_04, 
	INIT_05 => INIT_05, 
	INIT_06 => INIT_06, 
	INIT_07 => INIT_07, 
	INIT_08 => INIT_08, 
	INIT_09 => INIT_09, 
	INIT_0A => INIT_0A, 
	INIT_0B => INIT_0B, 
	INIT_0C => INIT_0C, 
	INIT_0D => INIT_0D, 
	INIT_0E => INIT_0E, 
	INIT_0F => INIT_0F, 
	INIT_10 => INIT_10, 
	INIT_11 => INIT_11, 
	INIT_12 => INIT_12, 
	INIT_13 => INIT_13, 
	INIT_14 => INIT_14, 
	INIT_15 => INIT_15, 
	INIT_16 => INIT_16, 
	INIT_17 => INIT_17, 
	INIT_18 => INIT_18, 
	INIT_19 => INIT_19, 
	INIT_1A => INIT_1A, 
	INIT_1B => INIT_1B, 
	INIT_1C => INIT_1C, 
	INIT_1D => INIT_1D, 
	INIT_1E => INIT_1E, 
	INIT_1F => INIT_1F, 
	INIT_20 => INIT_20, 
	INIT_21 => INIT_21, 
	INIT_22 => INIT_22, 
	INIT_23 => INIT_23, 
	INIT_24 => INIT_24, 
	INIT_25 => INIT_25, 
	INIT_26 => INIT_26, 
	INIT_27 => INIT_27, 
	INIT_28 => INIT_28, 
	INIT_29 => INIT_29, 
	INIT_2A => INIT_2A, 
	INIT_2B => INIT_2B, 
	INIT_2C => INIT_2C, 
	INIT_2D => INIT_2D, 
	INIT_2E => INIT_2E, 
	INIT_2F => INIT_2F, 
	INIT_30 => INIT_30, 
	INIT_31 => INIT_31, 
	INIT_32 => INIT_32, 
	INIT_33 => INIT_33, 
	INIT_34 => INIT_34, 
	INIT_35 => INIT_35, 
	INIT_36 => INIT_36, 
	INIT_37 => INIT_37, 
	INIT_38 => INIT_38,
	INIT_39 => INIT_39, 
	INIT_3A => INIT_3A, 
	INIT_3B => INIT_3B, 
	INIT_3C => INIT_3C, 
	INIT_3D => INIT_3D, 
	INIT_3E => INIT_3E, 
	INIT_3F => INIT_3F 
   )  
      port map (   	
	DOADO => DOA_BUS, 
	DOBDO => DOB_BUS, 
	DOPADOP => open, 
	DOPBDOP => open, 
	ADDRARDADDR => ADDRA, 
	ADDRBWRADDR => ADDRB_BUS, 
	CLKARDCLK => CLKA, 
	CLKBWRCLK => CLKB, 
	DIADI => DIA_BUS, 
	DIBDI => DIB_BUS, 
	DIPADIP => "00", 
	DIPBDIP => "00", 
	ENARDEN => ENA, 
	ENBWREN => ENB, 
	REGCEAREGCE => '0', 
	REGCEB => '0',  
	RSTRAMARSTRAM => SSRA, 
	RSTRAMB => SSRB, 
	RSTREGARSTREG => SSRA,
        RSTREGB => SSRB,
        WEA => WEA_BUS,
        WEBWE => WEB_BUS
  );
        DOA <= DOA_BUS(0 downto 0);
        DOB <= DOB_BUS(3 downto 0);
end RAMB16_S1_S4_V;
