-- $Header:  $
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 12.1
--  \   \         Description : Xilinx Functional Simulation Library Component
--  /   /                  5-input NAND Gate (Discontinue in 13.1)
-- /___/   /\     Filename : NAND5.vhd
-- \   \  /  \    Timestamp : Mon May 24 12:03:33 PDT 2010

--  \___\/\___\
--
-- Revision:
--    05/24/10 - Initial version.

----- CELL NAND5 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library unisim;
use unisim.VPKG.all;
use unisim.VCOMPONENTS.all;

entity NAND5 is
  port(
    O : out std_ulogic;

    I0 : in std_ulogic;
    I1 : in std_ulogic;
    I2 : in std_ulogic;
    I3 : in std_ulogic;
    I4 : in std_ulogic
    );
end NAND5;

architecture NAND5_V of NAND5 is
begin
    L5 : LUT5
    generic map(
      INIT => X"7FFFFFFF"
    )
    port map (
      O  => O,
      I0 => I0,
      I1 => I1,
      I2 => I2,
      I3 => I3,
      I4 => I4
);
end NAND5_V;


