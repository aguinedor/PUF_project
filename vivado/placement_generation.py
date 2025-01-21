# Configuration initiale
def generate_placement_constraints(num_ro, num_inv, start_x, start_y, end_x, end_y):  
    constraints = []
    bel         = ["D6LUT", "C6LUT", "B6LUT", "A6LUT"] # Ordre des BELs
    
    delta_Y = start_y - end_y
    num_ro_per_columns = (delta_Y + 1) // 2
    delta_Y_pair = ((delta_Y + 1) // 2) * 2
    

    for ro_index in range(num_ro):
        #current_y = start_y - inv_index * 2  # Décalage en Y par bloc Inverseur
        
        X_base = start_x + (ro_index // num_ro_per_columns) * 2
        if X_base >= end_x:
            raise ValueError(f"curent X_index {X_base} is higher than end_X {end_x}")
            return 
            
        Y_base = start_y - ((ro_index * 2) % delta_Y_pair) 
        print(f"-------------------- {ro_index} -------------------")
        
        
        slice_inv_uut1   = [X_base    , Y_base] # cast to int !
        slice_other_uut1 = [X_base + 1, Y_base]
        slice_inv_uut2   = [X_base    , Y_base - 1]
        slice_other_uut2 = [X_base + 1, Y_base - 1]
        
        print(f"Modulo : {ro_index % delta_Y_pair}")
        print(f"X_base {X_base}")
        print(f"Y_base {Y_base}")
        print(f"-----------------------------------------------")
        print(f"slice_inv_uut1   : {slice_inv_uut1}")
        print(f"slice_other_uut1 : {slice_other_uut1}")
        print(f"slice_inv_uut2   : {slice_inv_uut2}")
        print(f"slice_other_uut2 : {slice_other_uut2}")
        
        # --------------------- UUT1 ---------------------
        # Fill top left corner
        for inv_index in range(4):
            cell_name = f"uut1/Inverseur[{ro_index}].ringoscillator/Inverseur[{inv_index + 1}].Inverter1"
            constraints.append(f"set_property BEL {bel[inv_index]} [get_cells {{{cell_name}}}]")
            constraints.append(f"set_property LOC SLICE_X{slice_inv_uut1[0]}Y{slice_inv_uut1[1]} [get_cells {{{cell_name}}}]")
            
        # Fill top right corner
        for inv_index in range(2):
            cell_name = f"uut1/Inverseur[{ro_index}].ringoscillator/Inverseur[{inv_index + 1 + 4}].Inverter1"
            constraints.append(f"set_property BEL {bel[inv_index]} [get_cells {{{cell_name}}}]")
            constraints.append(f"set_property LOC SLICE_X{slice_other_uut1[0]}Y{slice_other_uut1[1]} [get_cells {{{cell_name}}}]")
        
        # inverter alone + Nand
        constraints.append(f"set_property BEL B6LUT [get_cells {{uut1/Inverseur[{ro_index}].ringoscillator/Inverter1}}]")
        constraints.append(f"set_property LOC SLICE_X{slice_other_uut1[0]}Y{slice_other_uut1[1]} [get_cells {{uut1/Inverseur[{ro_index}].ringoscillator/Inverter1}}]")
        
        if(ro_index == 0):
            cell_name = f"Nand_out_inferred_i_1"
        else:
            cell_name = f"Nand_out_inferred_i_1__{ro_index-1}"
        constraints.append(f"set_property LOC SLICE_X{slice_other_uut1[0]}Y{slice_other_uut1[1]} [get_cells {{uut1/Inverseur[{ro_index}].ringoscillator/{cell_name}}}]")        
        
        # --------------------- UUT2 ---------------------
        # Fill bottom left corner
        for inv_index in range(4):
            cell_name = f"uut2/Inverseur[{ro_index}].ringoscillator/Inverseur[{inv_index + 1}].Inverter1"
            constraints.append(f"set_property BEL {bel[inv_index]} [get_cells {{{cell_name}}}]")
            constraints.append(f"set_property LOC SLICE_X{slice_inv_uut2[0]}Y{slice_inv_uut2[1]} [get_cells {{{cell_name}}}]")
            
        # Fill bottom right corner
        for inv_index in range(2):
            cell_name = f"uut2/Inverseur[{ro_index}].ringoscillator/Inverseur[{inv_index + 1 + 4}].Inverter1"
            constraints.append(f"set_property BEL {bel[inv_index]} [get_cells {{{cell_name}}}]")
            constraints.append(f"set_property LOC SLICE_X{slice_other_uut2[0]}Y{slice_other_uut2[1]} [get_cells {{{cell_name}}}]")
        
        # inverter alone + Nand
        constraints.append(f"set_property BEL B6LUT [get_cells {{uut2/Inverseur[{ro_index}].ringoscillator/Inverter1}}]")
        constraints.append(f"set_property LOC SLICE_X{slice_other_uut2[0]}Y{slice_other_uut2[1]} [get_cells {{uut2/Inverseur[{ro_index}].ringoscillator/Inverter1}}]")
        
        constraints.append(f"set_property BEL A6LUT [get_cells {{uut2/Inverseur[{ro_index}].ringoscillator/Nand_out_inferred_i_1__{ro_index + 255}}}]")
        constraints.append(f"set_property LOC SLICE_X{slice_other_uut2[0]}Y{slice_other_uut2[1]} [get_cells {{uut2/Inverseur[{ro_index}].ringoscillator/Nand_out_inferred_i_1__{ro_index + 255}}}]")
        
    return "\n".join(constraints)




def generate_routage_constraints(num_ro, num_inv): 
    constraints = []
    
    for ro_index in range(num_ro):
        
        constraints.append(f"\n")
        # --------------------- UUT1 ---------------------
        for inv_index in range(num_inv):
            constraints.append(f"set_property LOCK_PINS {{I0:A6}} [get_cells {{uut1/Inverseur[{ro_index}].ringoscillator/Inverseur[{inv_index + 1}].Inverter1}}]")
        
        if(ro_index == 0):
            cell_name = f"Nand_out_inferred_i_1"
        else :
            cell_name = f"Nand_out_inferred_i_1__{ro_index - 1}"
        constraints.append(f"set_property LOCK_PINS {{I0:A5 I1:A6}} [get_cells {{uut1/Inverseur[{ro_index}].ringoscillator/{cell_name}}}]")
        
        constraints.append(f"set_property LOCK_PINS {{I0:A6}} [get_cells {{uut1/Inverseur[ro_index].ringoscillator/Inverter1}}]")
        
        constraints.append(f"")
        # --------------------- UUT2 ---------------------
        for inv_index in range(num_inv):
            constraints.append(f"set_property LOCK_PINS {{I0:A6}} [get_cells {{uut2/Inverseur[{ro_index}].ringoscillator/Inverseur[{inv_index + 1}].Inverter1}}]")
            
        constraints.append(f"set_property LOCK_PINS {{I0:A5 I1:A6}} [get_cells {{uut2/Inverseur[{ro_index}].ringoscillator/Nand_out_inferred_i_1__{ro_index + 255}}}]")

        constraints.append(f"set_property LOCK_PINS {{I0:A6}} [get_cells {{uut2/Inverseur[ro_index].ringoscillator/Inverter1}}]")
    
    return "\n".join(constraints)


# Génération du script
num_ro              = 256  	# Nombre de blocs Inverseur
num_inv             = 6     # Nombre de LUTs par bloc Inverseur
num_LUT_per_slice   = 4	    # Nombre de LUTs par slice 

# For each ro we have 6 inverters + 1 + Nand gate
start_x = 36  	# Coordonnée X initiale
end_x   = 65    # Coordonnée X finale
start_y = 99  	# Coordonnée Y initiale
end_y   = 50     # Coordonnée Y finale

#start_x = 36  	# Coordonnée X initiale
#end_x   = 65    # Coordonnée X finale
#start_y = 49  	# Coordonnée Y initiale
#end_y   = 0     # Coordonnée Y finale

script_content = generate_placement_constraints(num_ro, num_inv, start_x, start_y, end_x, end_y)

script_content_routing = generate_routage_constraints(num_ro, num_inv)

# Sauvegarde dans un fichier
output_file = "fpga_constraints.tcl"
with open(output_file, "w") as file:
    file.write(script_content)
    
# Sauvegarde dans un fichier
output_file = "fpga_routing_constraints.tcl"
with open(output_file, "w") as file:
    file.write(script_content_routing)

print(f"Script généré et sauvegardé dans {output_file}.")


