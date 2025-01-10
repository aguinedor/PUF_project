-------------------------------------------------------------------------------
-- Copyright (c) 1995/2017 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /     Vendor      : Xilinx 
-- \   \   \/      Version     : 2018.1
--  \   \          Description : Xilinx Functional Simulation Library Component
--  /   /                        Synchronizer for BUFG_GT Control Signals
-- /___/   /\      Filename    : BUFG_GT_SYNC.vhd
-- \   \  /  \
--  \___\/\___\
--
-------------------------------------------------------------------------------
-- Revision
--  02/03/14 - Initial version.
--  End Revision
-------------------------------------------------------------------------------

----- CELL BUFG_GT_SYNC -----

library IEEE;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.all;

library STD;
use STD.TEXTIO.all;

library UNISIM;
use UNISIM.VPKG.all;
use UNISIM.VCOMPONENTS.all;

  entity BUFG_GT_SYNC is
    port (
      CESYNC               : out std_ulogic;
      CLRSYNC              : out std_ulogic;
      CE                   : in std_ulogic;
      CLK                  : in std_ulogic;
      CLR                  : in std_ulogic
    );
  end BUFG_GT_SYNC;

  architecture BUFG_GT_SYNC_V of BUFG_GT_SYNC is
    
    constant MODULE_NAME : string := "BUFG_GT_SYNC";
  constant OUTCLK_DELAY : time := 100 ps;
  
-- Parameter encodings and registers


  signal glblGSR       : std_ulogic;
  
  signal CE_in : std_ulogic;
  signal CLK_in : std_ulogic;
  signal CLR_in : std_ulogic;
  
  -- begin behavioral model declarations
  
  -- end behavioral model declarations
  
  begin
  glblGSR     <= TO_X01(GSR);
  CE_in <= '1' when (CE = 'U') else CE; -- rv 1
  CLK_in <= CLK;
  CLR_in <= '0' when (CLR = 'U') else CLR; -- rv 0
  
-- begin behavioral model
  CESYNC <= CE_in;
  CLRSYNC <= CLR_in;

-- end behavioral model
 
 end BUFG_GT_SYNC_V;
