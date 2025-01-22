# get_gap_bit_flip()
# - bits_dict        [index][bit0, bit1, bit2 ...]
# - frequencies_dict [index]{'freq1' = [resp0, resp1 ...], 'freq2' = [resp0, resp1 ...]}
#
# -----------------------------------------------------------------------
def get_gap_bit_flip(bits_dict, frequencies_dict):
    nb_ro = len(frequencies_dict)
    nb_it = len(frequencies_dict[0]['freq1'])

    # Store gaps for each index and iteration
    gap            = [[0.0 for _ in range(nb_it)] for _ in range(nb_ro)]
    # Store max_value of gap for each index
    gap_max        = [0.0 for _ in range(nb_ro)]

    flip_info      = []
    bit_flip_index = []

    for idx in range(nb_ro):
        for ite in range(nb_it):
            if ite == 0:
                continue

            if bits_dict[idx][ite] != bits_dict[idx][ite-1]:
                diff_freq = frequencies_dict[idx]['freq1'][ite] - frequencies_dict[idx]['freq2'][ite]
                # Store frequencies gap when bit flip
                gap[idx][ite] = abs(diff_freq)
                flip_info.append({ 'index': idx, 'iteration': ite, 'difference': gap[idx][ite], 'response': bits_dict[idx][ite] })

                if idx not in bit_flip_index:
                    bit_flip_index.append(idx)
                # Actualize new max gap value
                if gap[idx][ite] > gap[idx][ite-1]:
                    gap_max[idx] = gap[idx][ite]

    largest_gap = max(gap_max)
    flip_info = sorted(flip_info, key= lambda x: x['index'])
    print("The largest gap for a bit flip is: ", largest_gap)

    return bit_flip_index, largest_gap



# RO_pair_filter()
# - frequencies_mean [index]{'freq1' = mean, 'freq2' = mean}
# - bit_flip_index   [index] if they exists
#
# 1 - gap_bit_flip = <value>                            -> Remove bit_flip_gap (no aliasing)
# 2 - gap_bit_flip = None  AND  gap_aliasing = <value>  -> Remove bit_flip and gap aliasing
# 3 - gap_bit_flip = None  AND  gap_aliasing = None     -> Remove bit_flip (no aliasing)
# -----------------------------------------------------------------------
def RO_pair_filter(frequencies_mean, bit_flip_index, gap_bit_flip = None, gap_aliasing = None):
    nb_ro = len(frequencies_mean)

    filtered_pairs = ''

    for idx in range(nb_ro):
        diff_freq = frequencies_mean[idx]['freq1'] - frequencies_mean[idx]['freq2']

        # 1 - first mode
        if gap_bit_flip != None:
            if abs(diff_freq) < gap_bit_flip:
                filtered_pairs = '0' + filtered_pairs
            else:
                filtered_pairs = '1' + filtered_pairs
            continue

        # 2 - second mode
        if gap_bit_flip == None and gap_aliasing != None:
            if idx in bit_flip_index or abs(diff_freq) > gap_aliasing:
                filtered_pairs = '0' + filtered_pairs
            else:
                filtered_pairs = '1' + filtered_pairs
            continue

        # 3 - third mode
        if gap_bit_flip == None and gap_aliasing == None:
            if idx in bit_flip_index:
                filtered_pairs = '0' + filtered_pairs
            else :
                filtered_pairs = '1' + filtered_pairs
            continue

    return filtered_pairs



# reset_RO_to_ones()
# - file_path       =  top_vhdl_path
# - text_to_change  =  line to select
# This function reset the given line in order to set only ones for example :
# - signal ro_filter : std_logic_vector(256 downto 0) := (others => '1')
# -----------------------------------------------------------------------
def reset_RO_to_ones(file_path, text_to_change):
    try:
        with open(file_path, 'r') as f:     # open file in readmode to load each line in elements of a list
            lines = f.readlines()

        modified_lines = []                 # to save all lines (unchanged ones and the changed line in write order)
        substitution = ("signal ro_filter                : std_logic_vector(256 downto 0) := (others => '1');\n") #text of substitution: initialisation of a signal taking into account the filter_output

        for line in lines:                  # browse all lines of file
            if text_to_change in line:      # if yes we found the line to change
                line = substitution
            modified_lines.append(line)     # save each line one by one (unchanged and change ones)

        with open(file_path, 'w') as f:     # rewrite all file with the changed line
            f.writelines(modified_lines)
            print("Substitution done, now all ROs are enabled\n")

    except FileNotFoundError:               # if it's not possible to load file
        print("Error: file", file_path, "is not found \n")
        exit()

    except Exception as e:                  # if error has occured
        print("Error: ", e, "error occured \n")
        exit()
    return



# replace_RO()
# - file_path       =  top_vhdl_path
# - text_to_change  =  line to select
# - filter_output   =  string of 256 values to filter
# This function replace
# -----------------------------------------------------------------------
def replace_RO_line(file_path, text_to_change, filter_output):
    # To check if filtering has an effect, if not we don't need to change RO activtions
    if filter_output.count("0") == 0:
        print("Nothing to change, all ROs are enabled \n")
        exit()
    else:
        try:
            with open(file_path, 'r') as f:
                lines = f.readlines()

            modified_lines = []
            substitution = ("signal ro_filter                : std_logic_vector(255 downto 0) := " + "\"" + str(filter_output) + "\"" + ";\n") #text of substitution: initialisation of a signal taking into account the filter_output

            for line in lines:                  # browse all lines of file
                if text_to_change in line:      # if yes we found the line to change
                    line = substitution
                modified_lines.append(line)     # save each line one by one (unchanged and change ones)

            with open(file_path, 'w') as f:     # rewrite all file with the changed line
                f.writelines(modified_lines)

        except FileNotFoundError:               # if it's not possible to load file
            print("Error: file", file_path, "is not found \n")
            exit()

        except Exception as e:                  # if error has occured
            print("Error: ", e, "error occured \n")

    return filter_output.count("1")
