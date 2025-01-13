library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

----------------------------------------------------------------------------------
entity ring_oscillator is
    port (
        Enable : in std_logic;
        RO_OUT : out std_logic
    );
end ring_oscillator;
----------------------------------------------------------------------------------
architecture Behavioral of ring_oscillator is
    signal Inverters: std_logic_vector(6 downto 0) := (others => '0');
    signal Nand_out: std_logic;

    attribute KEEP: string;
    attribute KEEP of Inverters: signal is "true";
    attribute KEEP of Nand_out: signal is "true";
----------------------------------------------------------------------------------
begin
    Nand_out <= Enable nand Inverters(5);

    -- Implement the first inverter using a process
    process(Nand_out)
    begin
        if Nand_out = '1' then
            Inverters(0) <= '0';
        else
            Inverters(0) <= '1';
        end if;
    end process;

    -- Generate the chain of inverters
    Inverseur: for i in 1 to 6 generate
        process(Inverters) -- Use the entire signal in the sensitivity list
        begin
            if Inverters(i-1) = '1' then
                Inverters(i) <= '0';
            else
                Inverters(i) <= '1';
            end if;
        end process;
    end generate Inverseur;

    -- Output the last signal in the chain
    RO_OUT <= Inverters(6);

end Behavioral;
