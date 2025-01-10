-------------------------------------------------------------------------------
-- Copyright (c) 1995/2018 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/      Version     : 2019.1
--  \   \         Description : Xilinx Functional Simulation Library Component
--  /   /                        General Clock Control Buffer
-- /___/   /\     Filename : BUFGCTRL.vhd
-- \   \  /  \
--  \___\/\___\
--
-------------------------------------------------------------------------------
-- Revision
--    03/23/04 - Initial version.
--    11/28/05 - CR 221551 fix.
--    08/13/07 - CR 413180 Initialization mismatch fix for unisims.
--    04/07/08 - CR 469973 -- Header Description fix
--    05/22/08 - Add init_done to pass initial values (CR 473625).
--    10/17/12 - 682802 - convert GSR H/L to 1/0
-- End Revision
-------------------------------------------------------------------------------

----- CELL BUFGCTRL -----

library IEEE;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_1164.all;

library STD;
use STD.TEXTIO.all;

library UNISIM;
use UNISIM.VPKG.all;
use UNISIM.VCOMPONENTS.all;

entity BUFGCTRL is
  generic(
    CE_TYPE_CE0         : string := "SYNC";
    CE_TYPE_CE1         : string := "SYNC";
    INIT_OUT            : integer := 0;
    IS_CE0_INVERTED     : bit := '0';
    IS_CE1_INVERTED     : bit := '0';
    IS_I0_INVERTED      : bit := '0';
    IS_I1_INVERTED      : bit := '0';
    IS_IGNORE0_INVERTED : bit := '0';
    IS_IGNORE1_INVERTED : bit := '0';
    IS_S0_INVERTED      : bit := '0';
    IS_S1_INVERTED      : bit := '0';
    PRESELECT_I0        : boolean := FALSE;
    PRESELECT_I1        : boolean := FALSE;
    SIM_DEVICE          : string := "ULTRASCALE";
    STARTUP_SYNC : string := "FALSE"
    );

  port(
    O       : out std_ulogic;
    CE0     : in  std_ulogic;
    CE1     : in  std_ulogic;
    I0      : in  std_ulogic;
    I1      : in  std_ulogic;
    IGNORE0 : in  std_ulogic;
    IGNORE1 : in  std_ulogic;
    S0      : in  std_ulogic;
    S1      : in  std_ulogic
    );
end BUFGCTRL;

architecture BUFGCTRL_V of BUFGCTRL is


  -- Parameter encodings and registers
  constant MODULE_NAME                : string := "BUFGCTRL";
  constant CE_TYPE_ASYNC              : std_logic_vector(1 downto 0) := "01";
  constant CE_TYPE_HARDSYNC           : std_logic_vector(1 downto 0) := "10";
  constant CE_TYPE_SYNC               : std_logic_vector(1 downto 0) := "00";
  constant SIM_DEVICE_7SERIES         : std_logic_vector(2 downto 0) := "001";
  constant SIM_DEVICE_ULTRASCALE      : std_logic_vector(2 downto 0) := "000";
  constant SIM_DEVICE_ULTRASCALE_PLUS : std_logic_vector(2 downto 0) := "010";
  constant SIM_DEVICE_VERSAL          : std_logic_vector(2 downto 0) := "011";
  constant SIM_DEVICE_VERSAL_ES1      : std_logic_vector(2 downto 0) := "100";
  constant SIM_DEVICE_VERSAL_ES2      : std_logic_vector(2 downto 0) := "101";
  constant STARTUP_SYNC_FALSE : std_ulogic := '0';
  constant STARTUP_SYNC_TRUE : std_ulogic := '1';

  signal CE_TYPE_CE0_BIN    : std_logic_vector(1 downto 0);
  signal CE_TYPE_CE1_BIN    : std_logic_vector(1 downto 0);
  signal SIM_DEVICE_BIN     : std_logic_vector(2 downto 0);
  signal STARTUP_SYNC_BIN   : std_ulogic;
  signal INIT_OUT_BIN       : std_ulogic;

  signal CE0_dly            : std_ulogic := 'X';
  signal CE1_dly            : std_ulogic := 'X';
  signal I0_dly             : std_ulogic := 'X';
  signal I1_dly             : std_ulogic := 'X';
  signal IGNORE0_dly        : std_ulogic := 'X';
  signal IGNORE1_dly        : std_ulogic := 'X';
  signal GSR_I0_dly         : std_ulogic := 'X';
  signal GSR_I1_dly         : std_ulogic := 'X';
  signal S0_dly             : std_ulogic := 'X';
  signal S1_dly             : std_ulogic := 'X';

  signal O_zd               : std_ulogic := 'X';

  signal q0                 : std_ulogic := 'X';
  signal q1                 : std_ulogic := 'X';
  signal q0_p1              : std_ulogic := 'X';
  signal q1_p1              : std_ulogic := 'X';
  signal q0_enable          : std_ulogic := 'X';
  signal q1_enable          : std_ulogic := 'X';

  signal preslct_i0         : std_ulogic := 'X';
  signal preslct_i1         : std_ulogic := 'X';

  signal I0_int             : std_ulogic := 'X';
  signal I1_int             : std_ulogic := 'X';
  signal init_done          : boolean := false;
  
  signal q0_ignore          : std_ulogic := 'X';
  signal q1_ignore          : std_ulogic := 'X';
  signal O_out              : std_ulogic := '0';
  signal CE0_reg            : std_logic_vector(2 downto 0) := "000";
  signal CE1_reg            : std_logic_vector(2 downto 0) := "000";
  signal CE0_int            : std_ulogic := 'X';
  signal CE1_int            : std_ulogic := 'X';
  signal enable_I0          : std_logic_vector(2 downto 0) := "000";
  signal enable_I1          : std_logic_vector(2 downto 0) := "000";
  signal enable_I0_2        : std_ulogic := '0';
  signal enable_I1_2        : std_ulogic := '0';
  signal I0t                : std_ulogic := 'X';
  signal I1t                : std_ulogic := 'X';

begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  CE0_dly     <= not CE0 when IS_CE0_INVERTED = '1' else CE0;
  CE1_dly     <= not CE1 when IS_CE1_INVERTED = '1' else CE1;
  GSR_I0_dly  <= TO_X01(GSR);
  GSR_I1_dly  <= TO_X01(GSR);
  I0_dly      <= not I0 when IS_I0_INVERTED = '1' else I0;
  I1_dly      <= not I1 when IS_I1_INVERTED = '1' else I1;
  IGNORE0_dly <= not IGNORE0 when IS_IGNORE0_INVERTED = '1' else IGNORE0;
  IGNORE1_dly <= not IGNORE1 when IS_IGNORE1_INVERTED = '1' else IGNORE1;
  S0_dly      <= not S0 when IS_S0_INVERTED = '1' else S0;
  S1_dly      <= not S1 when IS_S1_INVERTED = '1' else S1;

  
  --------------------
  --  BEHAVIOR SECTION
  --------------------
  CE_TYPE_CE0_BIN  <= 
      CE_TYPE_SYNC     when (CE_TYPE_CE0 = "SYNC") else
      CE_TYPE_HARDSYNC when (CE_TYPE_CE0 = "HARDSYNC") else
      CE_TYPE_SYNC;

  CE_TYPE_CE1_BIN  <= 
      CE_TYPE_SYNC     when (CE_TYPE_CE1 = "SYNC") else
      CE_TYPE_HARDSYNC when (CE_TYPE_CE1 = "HARDSYNC") else
      CE_TYPE_SYNC;

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
  
 
  INIT_OUT_BIN <= 
      '1' when (INIT_OUT = 1) else
      '0';

--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process
  variable FIRST_TIME       : boolean := true;
  variable Message          : line;
  variable attr_err : boolean := false;
  variable preslct_i0_var   : std_ulogic;
  variable preslct_i1_var   : std_ulogic;
  ---constant ce_type_ce0_var  : std_logic_vector(1 downto 0) := "00";
  ---constant ce_type_ce1_var  : std_logic_vector(1 downto 0) := "00";
  ---constant sim_device_var   : std_logic_vector(2 downto 0) := "000";
  ---constant startup_sync_var : std_ulogic := '1';

  begin
    if(FIRST_TIME) then

      if(((CE_TYPE_CE0 /= "SYNC") and 
          (CE_TYPE_CE0 /= "HARDSYNC"))) then
         assert false report
           "*** Attribute Syntax Error: Legal values for CE_TYPE_CE0 are SYNC or HARDSYNC."
          severity failure;
      end if;

      if(((CE_TYPE_CE1 /= "SYNC") and 
          (CE_TYPE_CE1 /= "HARDSYNC"))) then
         assert false report
           "*** Attribute Syntax Error: Legal values for CE_TYPE_CE1 are SYNC or HARDSYNC."
          severity failure;
      end if;


      -- check for PRESELECT_I0
      case PRESELECT_I0  is
        when true  => preslct_i0_var := '1';
        when false => preslct_i0_var := '0';
        when others =>
         assert false report
           "*** Attribute Syntax Error: Legal values for PRESELECT_I0 are TRUE or FALSE"
          severity failure;
      end case;

      -- check for PRESELECT_I1
      case PRESELECT_I1  is
        when true  => preslct_i1_var := '1';
        when false => preslct_i1_var := '0';
        when others =>
         assert false report
           "*** Attribute Syntax Error: Legal values for PRESELECT_I0 are TRUE or FALSE"
          severity failure;
      end case;

      -- both preslcts can not be 1 simultaneously 
      if((preslct_i0_var = '1') and (preslct_i1_var = '1')) then
         assert false report
           "*** Attribute Syntax Error: The attributes PRESELECT_I0 and PRESELECT_I1 should not be set to TRUE simultaneously"
          severity failure;
      end if;
        
      preslct_i0 <= preslct_i0_var;
      preslct_i1 <= preslct_i1_var;

      -- check for INIT_OUT
      if((INIT_OUT /= 0) and (INIT_OUT /= 1)) then
         assert false report
           "*** Attribute Syntax Error: Legal values for INIT_OUT are 0 or 1 "
          severity failure;
      end if;

      if(((SIM_DEVICE /= "ULTRASCALE") and 
          (SIM_DEVICE /= "ULTRASCALE_PLUS") and 
          (SIM_DEVICE /= "7SERIES") and 
          (SIM_DEVICE /= "VERSAL") and 
          (SIM_DEVICE /= "VERSAL_ES1") and 
          (SIM_DEVICE /= "VERSAL_ES2"))) then
         assert false report
           "*** Attribute Syntax Error: Legal values for SIM_DEVICE are ULTRASCALE, 7SERIES, ULTRASCALE_PLUS, VERSAL, VERSAL_ES1 or VERSAL_ES2."
          severity failure;
      end if;

      if(((STARTUP_SYNC /= "TRUE") and 
          (STARTUP_SYNC /= "FALSE"))) then
         assert false report
           "*** Attribute Syntax Error: Legal values for STARTUP_SYNC are TRUE or FALSE."
          severity failure;
      end if;


      FIRST_TIME := false;
      init_done <= true;

    end if;
    wait;

  end process prcs_init;


----- *** Start

  I0t <= INIT_OUT_BIN xor I0_int;
  I1t <= INIT_OUT_BIN xor I1_int;

  I0_int  <= I0_dly when (((SIM_DEVICE_BIN /= SIM_DEVICE_VERSAL) and
                           (SIM_DEVICE_BIN /= SIM_DEVICE_VERSAL_ES1) and
                           (SIM_DEVICE_BIN /= SIM_DEVICE_VERSAL_ES2)) or
                           (STARTUP_SYNC_BIN = STARTUP_SYNC_FALSE)  or (enable_I0(2)='1')) 
             else '0';

  I1_int  <= I1_dly  when (((SIM_DEVICE_BIN /= SIM_DEVICE_VERSAL) and
                            (SIM_DEVICE_BIN /= SIM_DEVICE_VERSAL_ES1) and
                            (SIM_DEVICE_BIN /= SIM_DEVICE_VERSAL_ES2)) or
                            (STARTUP_SYNC_BIN = STARTUP_SYNC_FALSE) or (enable_I1(2)='1'))
             else '0';

  CE0_int  <= CE0_dly  when (CE_TYPE_CE0_BIN = CE_TYPE_SYNC) else CE0_reg(2);
  CE1_int  <= CE1_dly  when (CE_TYPE_CE1_BIN = CE_TYPE_SYNC) else CE1_reg(2);

  q0_ignore <= q0 when (IGNORE0_dly = '1') else '0';
  q1_ignore <= q1 when (IGNORE1_dly = '1') else '0';

--####################################################################
--#####                            CE                          #####
--####################################################################
  prcs_ce0:process(I0_int, GSR_I0_dly, init_done)
  variable FIRST_TIME        : boolean    := TRUE;
  begin
      if (((FIRST_TIME) and (init_done)) or (GSR_I0_dly = '1') 
          or (CE_TYPE_CE0_BIN = CE_TYPE_SYNC) ) then
        CE0_reg    <= "000";
        FIRST_TIME := false;
      elsif (GSR_I0_dly = '0') then
        if (I0_int  = '1')  then 
          CE0_reg <= CE0_reg(1 downto 0) & CE0_dly;
        end if;
      end if;
  end process prcs_ce0;

  prcs_ce1:process(I1_int, GSR_I1_dly, init_done)
  variable FIRST_TIME        : boolean    := TRUE;
  begin
      if (((FIRST_TIME) and (init_done)) or (GSR_I1_dly = '1') 
          or (CE_TYPE_CE1_BIN = CE_TYPE_SYNC) ) then
        CE1_reg    <= "000";
        FIRST_TIME := false;
      elsif (GSR_I1_dly = '0') then
        if (I1_int  = '1')  then 
          CE1_reg <= CE1_reg(1 downto 0) & CE1_dly;
        end if;
      end if;
  end process prcs_ce1;
   
--####################################################################
--#####                            ENABLE                      #####
--####################################################################

  prcs_en0:process(i0_dly, GSR_I0_dly, init_done)
  variable FIRST_TIME        : boolean    := TRUE;
  begin
      if (((FIRST_TIME) and (init_done)) or (GSR_I0_dly = '1') 
          or ((SIM_DEVICE_BIN /= SIM_DEVICE_VERSAL) and
              (SIM_DEVICE_BIN /= SIM_DEVICE_VERSAL_ES1) and
              (SIM_DEVICE_BIN /= SIM_DEVICE_VERSAL_ES2)) ) then
        enable_I0    <= "000";
        FIRST_TIME := false;
      elsif (GSR_I0_dly = '0') then
        if (i0_dly  = '1')  then 
          enable_I0 <= enable_I0(1 downto 0) & '1';
        end if;
      end if;
  end process prcs_en0;

  prcs_en1:process(i1_dly, GSR_I1_dly, init_done)
  variable FIRST_TIME        : boolean    := TRUE;
  begin
      if (((FIRST_TIME) and (init_done)) or (GSR_I1_dly = '1') 
          or ((SIM_DEVICE_BIN /= SIM_DEVICE_VERSAL) and
              (SIM_DEVICE_BIN /= SIM_DEVICE_VERSAL_ES1) and
              (SIM_DEVICE_BIN /= SIM_DEVICE_VERSAL_ES2)) ) then
        enable_I1    <= "000";
        FIRST_TIME := false;
      elsif (GSR_I1_dly = '0') then
        if (i1_dly  = '1')  then 
          enable_I1 <= enable_I1(1 downto 0) & '1';
        end if;
      end if;
  end process prcs_en1;


--####################################################################
--#####                            I1                          #####
--####################################################################
----- *** Input enable for i1
  prcs_en_i1:process(IGNORE1_dly, I1t, S1_dly, GSR_I1_dly, q0, init_done)
  variable FIRST_TIME        : boolean    := TRUE;
  begin
      if (((FIRST_TIME) and (init_done)) or (GSR_I1_dly = '1')) then
         q1_enable <= preslct_i1;
         FIRST_TIME := false;
      elsif (GSR_I1_dly = '0') then
         if ((I1t  = '0') and (IGNORE1_dly = '0')) then 
             q1_enable <= q1_enable;
         elsif((I1t = '1') or (IGNORE1_dly = '1')) then
             q1_enable <= ((NOT q0) AND (S1_dly));
          end if;
             
      end if;
  end process prcs_en_i1;
    
----- *** Output q1
  prcs_out_i1:process(q1_enable, CE1_dly, I1t, IGNORE1_dly, GSR_I1_dly, init_done)
  variable FIRST_TIME        : boolean    := TRUE;
  begin
      if (((FIRST_TIME) and (init_done))or (GSR_I1_dly = '1')) then
         q1 <= preslct_i1;
         FIRST_TIME := false;
      elsif (GSR_I1_dly = '0') then
         if ((I1t  = '1') and (IGNORE1_dly = '0')) then 
             q1 <= q1;
         elsif((I1t = '0') or (IGNORE1_dly = '1')) then
             if ((CE0_dly='1' and q0_enable='1') and (CE1_dly='1' and q1_enable='1')) then
                q1 <=  'X';
             else
                q1 <=  CE1_dly AND q1_enable;
             end if;
         end if;
      end if;
  end process prcs_out_i1;

--####################################################################
--#####                            I0                          #####
--####################################################################
----- *** Input enable for i0
  prcs_en_i0:process(IGNORE0_dly, I0t, S0_dly, GSR_I0_dly, q1, init_done)
  variable FIRST_TIME        : boolean    := TRUE;
  begin
      if (((FIRST_TIME) and (init_done)) or (GSR_I0_dly = '1')) then
         q0_enable <= preslct_i0;
         FIRST_TIME := false;
      elsif (GSR_I0_dly = '0') then
         if ((I0t  = '0') and (IGNORE0_dly = '0')) then 
             q0_enable <= q0_enable;
         elsif((I0t = '1') or (IGNORE0_dly = '1')) then
             q0_enable <= ((NOT q1) AND (S0_dly));
          end if;
             
      end if;
  end process prcs_en_i0;
    
----- *** Output q0
  prcs_out_i0:process(q0_enable, CE0_dly, I0t, IGNORE0_dly, GSR_I0_dly, init_done)
  variable FIRST_TIME        : boolean    := TRUE;
  begin
      if (((FIRST_TIME) and (init_done)) or (GSR_I0_dly = '1')) then
         q0 <= preslct_i0;
         FIRST_TIME := false;
      elsif (GSR_I0_dly = '0') then
         if ((I0t  = '1') and (IGNORE0_dly = '0')) then 
             q0 <= q0;
         elsif((I0t = '0') or (IGNORE0_dly = '1')) then
             if ((CE0_dly='1' and q0_enable='1') and (CE1_dly='1' and q1_enable='1')) then
                q0 <=  'X';
             else
                q0 <=  CE0_dly AND q0_enable;
             end if;
         end if;
      end if;
  end process prcs_out_i0;


--####################################################################
--#####                          OUTPUT                          #####
--####################################################################
  O <= O_out;
  
  prcs_selectout:process(q0_ignore, q1_ignore, I0_int, I1_int)
  begin
    if ((q0 = '1') and (O_out /= I0_int)) then 
      O_out <= I0_int;
    elsif ((q1 = '1') and (O_out /= I1_int)) then
      O_out <= I1_int;
    elsif ((q0 = '0') and (q1 = '0') and (S0_dly = '0') and (S1_dly = '0')) then
      O_out <= INIT_OUT_BIN;
    elsif ((q0 = '1') and (q1 = '1') and (S0_dly = '1') and (S1_dly = '1') and (I0_int /= I1_int)) then
      O_out <= 'X';
    end if;
  end process prcs_selectout;

--####################################################################

--####################################################################
--#####                         OUTPUT                           #####
--####################################################################
     
--   prcs_output:process(O_zd)
--   begin
-- -- CR fix for 221551
-- --      O <= O_zd after SYNC_PATH_DELAY;
--       O <= O_zd;
--   end process prcs_output;
--####################################################################

end BUFGCTRL_V;
