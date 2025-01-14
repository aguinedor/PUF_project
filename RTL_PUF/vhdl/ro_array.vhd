library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
--library UNISIM;
--use UNISIM.VComponents.all;
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-----------------------------------------------------------------------------------------
entity Ros_selection is
  Port (
  challenge : in std_logic_vector(7 downto 0) ;
  Output    : out std_logic ;
  Enable    : in std_logic_vector(255 downto 0) --change to 256 bits vector
  );
end Ros_selection;
-----------------------------------------------------------------------------------------
architecture Behavioral of Ros_selection is

-----------------------------------------------------------------------------------------
 component ring_oscillator
    Port ( Enable : in std_logic;
           RO_OUT : out std_logic);
    end component;
 -----------------------------------------------------------------------------------------

signal Sortie_RO : std_logic_vector(255 downto 0) ;

begin
-----------------------------------------------------------------------------------------
Inverseur: for i in 0 to 255 generate
    ringoscillator : ring_oscillator
        port map (
              Enable => Enable(i), -- 1-bit output: LUT
              RO_OUT => Sortie_RO(i) -- 1-bit input: LUT
                );
end generate Inverseur;
-----------------------------------------------------------------------------------------
process(challenge, Sortie_RO)
begin
    -- Définir une valeur par défaut pour Output
    Output <= '0';

    for i in 0 to 255 loop
        if challenge = std_logic_vector(to_unsigned(i, 8)) then
            Output <= Sortie_RO(i);
            exit; -- Quitter la boucle dès qu'une correspondance est trouvée
        end if;
    end loop;
end process;


end Behavioral;
