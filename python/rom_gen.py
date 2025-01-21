# -*- coding: utf-8 -*-
import random
# Recréer les paires aléatoires et générer le fichier VHDL correctement

# Génération des 256 paires aléatoires
group1_pool = list(range(256))
group2_pool = list(range(256))
random.shuffle(group1_pool)
random.shuffle(group2_pool)
pairs = [(group1_pool[i], group2_pool[i]) for i in range(256)]

# Conversion en format VHDL
rom_data = [f"{g1:08b}{g2:08b}" for g1, g2 in pairs]

# Définition du fichier de sortie
file_name = "/tp/xph3app/xph3app605/PUF_PROJECT/sources/vhdl_us/random_rom.vhd"
header = """\
-- File generated automatically
-- Description : ROM including 256 random pairs
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity random_rom is
    Port (
        address : in  std_logic_vector(7 downto 0); -- Adresse sur 8 bits
        data_out : out std_logic_vector(15 downto 0) -- Données de sortie : 16 bits (2 x 8 bits)
    );
end random_rom;
architecture Behavioral of random_rom is
    type rom_type is array (0 to 255) of std_logic_vector(15 downto 0);
    constant ROM : rom_type := (
"""

footer = """\
    );
begin
    process(address)
    begin
        data_out <= ROM(to_integer(unsigned(address)));
    end process;
end Behavioral;
"""

# Construction du fichier
with open(file_name, 'w') as vhdl_file:
    # Ecrire l'entête
    vhdl_file.write(header)
    
    # Écrire les paires
    for i, pair in enumerate(rom_data):
        line = f"    {i} => \"{pair}\""
        if i < len(rom_data) - 1:
            line += ","
        line += "\n"
        vhdl_file.write(line)
    
    # Ajouter la fin
    vhdl_file.write(footer)
