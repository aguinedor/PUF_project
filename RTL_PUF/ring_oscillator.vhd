library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
library UNISIM;
use UNISIM.VComponents.all;

-----------------------------------------------------------------------------------------------------
entity ROs is
generic(
 RO_size : integer := 102 );
 
Port (
        --En : in STD_LOGIC;
        Enable : in std_logic;
        RO_OUT : out std_logic
);
end ROs;
------------------------------------------------------------------------------------------------------
architecture Behavioral of ROs is
signal Inverters:std_logic_vector(6 downto 0):= (others => '0');
Signal Nand_out:std_logic;
attribute KEEP: string ;
attribute KEEP of Inverters: signal  is  " true " ; 
attribute KEEP of Nand_out: signal  is  " true " ;
-------------------------------------------------------------------------------------------------------
begin
Nand_out <= Enable nand Inverters(5);--(not Enable)

-------------------------------------------------------------------------------------------------------
Inverter1 : LUT1
generic map (
 INIT => "01" -- Logic function
)
port map (
 O => Inverters(0), -- 1-bit output: LUT
 I0 => Nand_out -- 1-bit input: LUT
);

Inverseur: for i in 1 to 6 generate
  
    Inverter1 : LUT1
        generic map (
            INIT => "01" -- Logic function
            )
        port map (
            O => Inverters(i), -- 1-bit output: LUT
            I0 => Inverters(i-1) -- 1-bit input: LUT
            );

--------------------------------------------------
end generate Inverseur;
-------------------------------------------------------
RO_OUT <= Inverters(6) ;

end Behavioral;
