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
--  /   /                  3-input XNOR Gate (Discontinue in 13.1)
-- /___/   /\     Filename : XNOR3.vhd
-- \   \  /  \    Timestamp : Mon May 24 16:20:41 PDT 2010

--  \___\/\___\
--
-- Revision:
--    05/24/10 - Initial version.

----- CELL XNOR3 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library unisim;
use unisim.VPKG.all;
use unisim.VCOMPONENTS.all;

entity XNOR3 is
  port(
    O : out std_ulogic;

    I0 : in std_ulogic;
    I1 : in std_ulogic;
    I2 : in std_ulogic
    );
end XNOR3;

architecture XNOR3_V of XNOR3 is
begin
    L3 : LUT3
    generic map(
      INIT => X"69"
    )
    port map (
      O  => O,
      I0 => I0,
      I1 => I1,
      I2 => I2
);
end XNOR3_V;
