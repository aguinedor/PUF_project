-------------------------------------------------------------------------------
-- Copyright (c) 1995/2018 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/      Version     : 2019.1
--  \   \         Description : Xilinx Functional Simulation Library Component
--  /   /                        A high-fanout buffer for low-skew distribution of the PS Clock signals
-- /___/   /\     Filename : BUFG_PS.vhd
-- \   \  /  \
--  \___\/\___\
--
-------------------------------------------------------------------------------
-- Revision
--    03/10/15 - Initial version
-- End Revision
-------------------------------------------------------------------------------

----- CELL BUFG_PS -----

library IEEE;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.all;

library STD;
use STD.TEXTIO.all;

library UNISIM;
use UNISIM.VPKG.all;
use UNISIM.VCOMPONENTS.all;

entity BUFG_PS is
  generic (
    SIM_DEVICE : string := "ULTRASCALE_PLUS";
    STARTUP_SYNC : string := "FALSE"
  );
  
  port(
    O : out std_ulogic;
    I : in std_ulogic
    );
end BUFG_PS;

architecture BUFG_PS_V of BUFG_PS is

  constant MODULE_NAME : string := "BUFG_PS";
  constant OUTCLK_DELAY : time := 100 ps;
  
-- Parameter encodings and registers
  constant SIM_DEVICE_ULTRASCALE_PLUS : std_logic_vector(1 downto 0) := "00";
  constant SIM_DEVICE_VERSAL : std_logic_vector(1 downto 0) := "01";
  constant SIM_DEVICE_VERSAL_ES1 : std_logic_vector(1 downto 0) := "10";
  constant SIM_DEVICE_VERSAL_ES2 : std_logic_vector(1 downto 0) := "11";
  constant STARTUP_SYNC_FALSE : std_ulogic := '0';
  constant STARTUP_SYNC_TRUE : std_ulogic := '1';

  signal SIM_DEVICE_BIN : std_logic_vector(1 downto 0);
  signal STARTUP_SYNC_BIN : std_ulogic;

  signal xil_attr_test : boolean := false;
  
  -- begin behavioral model declarations
  
  -- end behavioral model declarations
  
  begin
  SIM_DEVICE_BIN <= 
      SIM_DEVICE_ULTRASCALE_PLUS when (SIM_DEVICE = "ULTRASCALE_PLUS") else
      SIM_DEVICE_VERSAL when (SIM_DEVICE = "VERSAL") else
      SIM_DEVICE_VERSAL_ES1 when (SIM_DEVICE = "VERSAL_ES1") else
      SIM_DEVICE_VERSAL_ES2 when (SIM_DEVICE = "VERSAL_ES2") else
      SIM_DEVICE_ULTRASCALE_PLUS;
  
  STARTUP_SYNC_BIN <= 
      STARTUP_SYNC_FALSE when (STARTUP_SYNC = "FALSE") else
      STARTUP_SYNC_TRUE when (STARTUP_SYNC = "TRUE") else
      STARTUP_SYNC_FALSE;
  
  
  INIPROC : process
  variable Message : line;
  variable attr_err : boolean := false;
  begin
    -------- SIM_DEVICE check
      if((xil_attr_test) or
         ((SIM_DEVICE /= "ULTRASCALE_PLUS") and 
          (SIM_DEVICE /= "VERSAL") and 
          (SIM_DEVICE /= "VERSAL_ES1") and 
          (SIM_DEVICE /= "VERSAL_ES2"))) then
        attr_err := true;
        Write ( Message, string'("Error : [Unisim "));
        Write ( Message, string'(MODULE_NAME));
        Write ( Message, string'("-101] SIM_DEVICE attribute is set to """));
        Write ( Message, string'(SIM_DEVICE));
        Write ( Message, string'(""". Legal values for this attribute are "));
        Write ( Message, string'("""ULTRASCALE_PLUS"", "));
        Write ( Message, string'("""VERSAL"", "));
        Write ( Message, string'("""VERSAL_ES1"" or "));
        Write ( Message, string'("""VERSAL_ES2"". "));
        Write ( Message, string'("Instance "));
        Write ( Message, string'(BUFG_PS_V'PATH_NAME));
        writeline(output, Message);
        DEALLOCATE (Message);
      end if;
    -------- STARTUP_SYNC check
      if((xil_attr_test) or
         ((STARTUP_SYNC /= "FALSE") and 
          (STARTUP_SYNC /= "TRUE"))) then
        attr_err := true;
        Write ( Message, string'("Error : [Unisim "));
        Write ( Message, string'(MODULE_NAME));
        Write ( Message, string'("-102] STARTUP_SYNC attribute is set to """));
        Write ( Message, string'(STARTUP_SYNC));
        Write ( Message, string'(""". Legal values for this attribute are "));
        Write ( Message, string'("""FALSE"" or "));
        Write ( Message, string'("""TRUE"". "));
        Write ( Message, string'("Instance "));
        Write ( Message, string'(BUFG_PS_V'PATH_NAME));
        writeline(output, Message);
        DEALLOCATE (Message);
      end if;
    if  (attr_err) then
      Write ( Message, string'("[Unisim "));
      Write ( Message, string'(MODULE_NAME));
      Write ( Message, string'("-103] Attribute Error(s) encountered. "));
      Write ( Message, string'("Instance "));
      Write ( Message, string'(BUFG_PS_V'PATH_NAME));
      assert FALSE
      report Message.all
      severity error;
    end if;
    wait;
    end process INIPROC;
    
-- begin behavioral model
  O <= TO_X01(I);

-- end behavioral model

end BUFG_PS_V;
