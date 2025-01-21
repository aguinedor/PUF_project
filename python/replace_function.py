def init_RO(file_path, text_to_change):
    try:
            #open file in readmode to load each line in elements of a list
            with open(file_path, 'r') as f: 
                lines = f.readlines()

            modified_lines = [] #to save all lines (unchanged ones and the changed line in write order)
            substitution = ("signal ro_filter                : std_logic_vector(256 downto 0) := (others => '1');\n") #text of substitution: initialisation of a signal taking into account the filter_output

            for line in lines: #browse all lines of file
                if text_to_change in line: #if yes we found the line to change
                    line = substitution
                modified_lines.append(line) #save each line one by one (unchanged and change ones)
        
            #rewrite all file with the changed line
            with open(file_path, 'w') as f:
                f.writelines(modified_lines)
        
            print("Substitution done, now all ROs are enabled\n")
    
    except FileNotFoundError: #if it's not possible to load file
        print("Error: file", file_path, "is not found \n")
        exit()
    except Exception as e: #if error has occured
        print("Error: ", e, "error occured \n")
        exit()
    return

def replace_RO(file_path, text_to_change, filter_output):
    #to check if filtering has an effect, if not we don't need to change RO activtions
    if filter_output.count("0") == 0:
        print("Nothing to change, all ROs are enabled \n")
        exit()

    #according to filter we need to activate some ROs and desactivate others
    else:
        try:
            #open file in readmode to load each line in elements of a list
            with open(file_path, 'r') as f: 
                lines = f.readlines()

            modified_lines = [] #to save all lines (unchanged ones and the changed line in write order)
            substitution = ("signal ro_filter                : std_logic_vector(255 downto 0) := " + "\"" + str(filter_output) + "\"" + ";\n") #text of substitution: initialisation of a signal taking into account the filter_output

            for line in lines: #browse all lines of file
                if text_to_change in line: #if yes we found the line to change
                    line = substitution
                modified_lines.append(line) #save each line one by one (unchanged and change ones)
        
            #rewrite all file with the changed line
            with open(file_path, 'w') as f:
                f.writelines(modified_lines)
        
            print("Substitution done, now some ROs are enabled and other no \n")
    
        except FileNotFoundError: #if it's not possible to load file
            print("Error: file", file_path, "is not found \n")
            exit()
        except Exception as e: #if error has occured
            print("Error: ", e, "error occured \n")

    return
