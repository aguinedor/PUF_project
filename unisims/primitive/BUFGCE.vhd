-------------------------------------------------------------------------------
-- Copyright (c) 1995/2018 Xilinx, Inc.
--  All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /     Vendor      : Xilinx 
-- \   \   \/      Version     : 2019.1
--  \   \          Description : Xilinx Functional Simulation Library Component
--  /   /                        General Clock Buffer with Clock Enable
-- /___/   /\      Filename    : BUFGCE.vhd
-- \   \  /  \
--  \___\/\___\
--
-------------------------------------------------------------------------------
-- Revision
--
--  05/15/12 - Initial version.
--  10/17/12 - 682802 - convert GSR H/L to 1/0
--  End Revision
-------------------------------------------------------------------------------

----- CELL BUFGCE -----

library IEEE;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.all;

library STD;
use STD.TEXTIO.all;

library UNISIM;
use UNISIM.VPKG.all;
use UNISIM.VCOMPONENTS.all;

  entity BUFGCE is
    generic (
      CE_TYPE : string := "SYNC";
      IS_CE_INVERTED : bit := '0';
    IS_I_INVERTED : bit := '0';
    SIM_DEVICE : string := "ULTRASCALE";
    STARTUP_SYNC : string := "FALSE"
    );

    port (
      O                    : out std_ulogic;
      CE                   : in std_ulogic;
      I                    : in std_ulogic      
    );
  end BUFGCE;

  architecture BUFGCE_V of BUFGCE is
    
    constant MODULE_NAME : string := "BUFGCE";
  constant OUTCLK_DELAY : time := 100 ps;

-- Parameter encodings and registers
  constant CE_TYPE_ASYNC : std_logic_vector(1 downto 0) := "01";
  constant CE_TYPE_HARDSYNC : std_logic_vector(1 downto 0) := "10";
  constant CE_TYPE_SYNC : std_logic_vector(1 downto 0) := "00";
  constant SIM_DEVICE_7SERIES : std_logic_vector(2 downto 0) := "001";
  constant SIM_DEVICE_ULTRASCALE : std_logic_vector(2 downto 0) := "000";
  constant SIM_DEVICE_ULTRASCALE_PLUS : std_logic_vector(2 downto 0) := "010";
  constant SIM_DEVICE_VERSAL : std_logic_vector(2 downto 0) := "011";
  constant SIM_DEVICE_VERSAL_ES1 : std_logic_vector(2 downto 0) := "100";
  constant SIM_DEVICE_VERSAL_ES2 : std_logic_vector(2 downto 0) := "101";
  constant STARTUP_SYNC_FALSE : std_ulogic := '0';
  constant STARTUP_SYNC_TRUE : std_ulogic := '1';

  signal CE_TYPE_BIN : std_logic_vector(1 downto 0);
    signal IS_CE_INVERTED_BIN : std_ulogic;
    signal IS_I_INVERTED_BIN : std_ulogic;
  signal SIM_DEVICE_BIN : std_logic_vector(2 downto 0);
  signal STARTUP_SYNC_BIN : std_ulogic;

    signal glblGSR : std_ulogic;
    signal xil_attr_test : boolean := false;
    
    signal O_out : std_ulogic;
    
    signal CE_in : std_ulogic;
    signal I_in : std_ulogic;

  -- begin behavioral model declarations
    signal ice : std_ulogic := 'X';
    signal enable_clk : std_ulogic := '0';
    signal ce_inv : std_ulogic := 'X';

  -- end behavioral model declarations

  begin
    glblGSR     <= TO_X01(GSR);
   
    O <= O_out;
    
    CE_in <= '1' when (CE = 'U') else CE xor IS_CE_INVERTED_BIN; -- rv 1
    I_in <= I xor IS_I_INVERTED_BIN;
    
    CE_TYPE_BIN <= 
      CE_TYPE_SYNC when (CE_TYPE = "SYNC") else
      CE_TYPE_ASYNC when (CE_TYPE = "ASYNC") else
      CE_TYPE_HARDSYNC when (CE_TYPE = "HARDSYNC") else
      CE_TYPE_SYNC;
      
    IS_CE_INVERTED_BIN <= TO_X01(IS_CE_INVERTED);
    IS_I_INVERTED_BIN <= TO_X01(IS_I_INVERTED);
  SIM_DEVICE_BIN <= 
      SIM_DEVICE_ULTRASCALE when (SIM_DEVICE = "ULTRASCALE") else
      SIM_DEVICE_7SERIES when (SIM_DEVICE = "7SERIES") else
      SIM_DEVICE_ULTRASCALE_PLUS when (SIM_DEVICE = "ULTRASCALE_PLUS") else
      SIM_DEVICE_VERSAL when (SIM_DEVICE = "VERSAL") else
      SIM_DEVICE_VERSAL_ES1 when (SIM_DEVICE = "VERSAL_ES1") else
      SIM_DEVICE_VERSAL_ES2 when (SIM_DEVICE = "VERSAL_ES2") else
      SIM_DEVICE_ULTRASCALE;
  
  STARTUP_SYNC_BIN <= 
      STARTUP_SYNC_FALSE when (STARTUP_SYNC = "FALSE") else
      STARTUP_SYNC_TRUE when (STARTUP_SYNC = "TRUE") else
      STARTUP_SYNC_FALSE;
  

  INIPROC : process
    variable Message : line;
    variable attr_err : boolean := false;
    begin
    -------- CE_TYPE check
      if((xil_attr_test) or
         ((CE_TYPE /= "SYNC") and 
          (CE_TYPE /= "ASYNC") and 
          (CE_TYPE /= "HARDSYNC"))) then
        attr_err := true;
        Write ( Message, string'("Error : [Unisim "));
        Write ( Message, string'(MODULE_NAME));
        Write ( Message, string'("-101] CE_TYPE attribute is set to """));
        Write ( Message, string'(CE_TYPE));
        Write ( Message, string'(""". Legal values for this attribute are "));
        Write ( Message, string'("""SYNC"", "));
        Write ( Message, string'("""ASYNC"" or "));
        Write ( Message, string'("""HARDSYNC"". "));
        Write ( Message, string'("Instance "));
        Write ( Message, string'(BUFGCE_V'PATH_NAME));
        writeline(output, Message);
        DEALLOCATE (Message);
      end if;
    -------- SIM_DEVICE check
      if((xil_attr_test) or
         ((SIM_DEVICE /= "ULTRASCALE") and 
          (SIM_DEVICE /= "7SERIES") and 
          (SIM_DEVICE /= "ULTRASCALE_PLUS") and 
          (SIM_DEVICE /= "VERSAL") and 
          (SIM_DEVICE /= "VERSAL_ES1") and 
          (SIM_DEVICE /= "VERSAL_ES2"))) then
        attr_err := true;
        Write ( Message, string'("Error : [Unisim "));
        Write ( Message, string'(MODULE_NAME));
        Write ( Message, string'("-104] SIM_DEVICE attribute is set to """));
        Write ( Message, string'(SIM_DEVICE));
        Write ( Message, string'(""". Legal values for this attribute are "));
        Write ( Message, string'("""ULTRASCALE"", "));
        Write ( Message, string'("""7SERIES"", "));
        Write ( Message, string'("""ULTRASCALE_PLUS"", "));
        Write ( Message, string'("""VERSAL"", "));
        Write ( Message, string'("""VERSAL_ES1"" or "));
        Write ( Message, string'("""VERSAL_ES2"". "));
        Write ( Message, string'("Instance "));
        Write ( Message, string'(BUFGCE_V'PATH_NAME));
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
        Write ( Message, string'("-105] STARTUP_SYNC attribute is set to """));
        Write ( Message, string'(STARTUP_SYNC));
        Write ( Message, string'(""". Legal values for this attribute are "));
        Write ( Message, string'("""FALSE"" or "));
        Write ( Message, string'("""TRUE"". "));
        Write ( Message, string'("Instance "));
        Write ( Message, string'(BUFGCE_V'PATH_NAME));
        writeline(output, Message);
        DEALLOCATE (Message);
      end if;
    if  (attr_err) then
      Write ( Message, string'("[Unisim "));
      Write ( Message, string'(MODULE_NAME));
      Write ( Message, string'("-104] Attribute Error(s) encountered. "));
      Write ( Message, string'("Instance "));
      Write ( Message, string'(BUFGCE_V'PATH_NAME));
      assert FALSE
      report Message.all
      severity error;
      end if;
      wait;
    end process INIPROC;

-- begin behavioral model

    prcs_1 : process(glblGSR, CE_in, I_in)
    begin
      if (glblGSR = '1') then
        enable_clk <= '0';
      elsif ((CE_TYPE_BIN = CE_TYPE_ASYNC) or (I_in = '0')) then
        enable_clk <= CE_in;
      end if;  
    end process prcs_1;

    O_out <= enable_clk and I_in;

-- end behavioral model

  end BUFGCE_V;
