# Dependencies
import argparse
import subprocess
import os

import PUF_project.python.data_ro_parser as data_ro_parser
import PUF_project.python.filter_functions as filter_functions


# --------------------------------------------------
#               Global variables
OUTPUT_DATA_PATH   = '/tp/xph3app/xph3app605/PUF_PROJECT/Output_fpga_puf'
SCRIPT_PYTHON_PATH = '/tp/xph3app/xph3app605/PUF_PROJECT/Script_puf/Script_Python'
TOP_VHDL_PATH      = '/tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/ro_puf_top.vhd'
VIVADO_TCL_SCRIPT  = '/tp/xph3app/xph3app605/PUF_PROJECT/Script_puf/Script_vivado/vivado_flow.tcl'

OUTPUT_CSV_FILE    = 'RO_PUF_BEFORE.csv'
OUTPUT_CSV_FILE_2  = 'RO_PUF_AFTER.csv'



# Create the parser
parser = argparse.ArgumentParser(description="Global PUF : run the whole script for PUF implementation")

# Add arguments
parser.add_argument('--vivado'   , action='store_true', help='Enable vivado implementation on card - default: false')
parser.add_argument('--filter'   , action='store_true', help='Enable filter implementation on card - default: false')
parser.add_argument('--uart_port', type=str , default='/dev/ttyUSB0', help='Select the uart port - default: /dev/ttyUSB0')
parser.add_argument('--puf_mode' , type=str , default='1'  , choices=['0','1'], help='Select the PUF mode (random: 1, pair: 0) - default: 1')
parser.add_argument('--speed'    , type=str , default='011', choices=['001', '010', '011', '100'],
                    help='Select the PUF speed acquisition: '
                         '\n  "001": 12000000 clk tick (1000 ms)'
                         '\n  "010": 1200000 clk tick  (100  ms)'
                         '\n  "011": 120000 clk tick   (10   ms)'
                         '\n  "100": 12000 clk tick    (1    ms)'
                         '\n  default: 011')

# Parse the arguments
args              = parser.parse_args()
USB_PORT          = args.uart_port
TRAME_TO_SEND_STR = '1'+args.puf_mode+'000'+args.speed


# Access the arguments
print("- 0 - Global Informations ------------------------------------------------------------------------------")
print(f"Vivado enabled : {args.vivado}")
print(f"Filter enabled : {args.filter}")
print(f"UART Port      : {args.uart_port}")
print(f"PUF Mode       : {args.puf_mode}")
print(f"Speed          : {args.speed}")
print(f"Result Frame   : {TRAME_TO_SEND_STR}")


# remove files
try:
    os.remove(OUTPUT_CSV_FILE)
    print(f"File {OUTPUT_CSV_FILE} deleted successfully.")
except FileNotFoundError:
    print(f"File {OUTPUT_CSV_FILE} not found.")

try:
    os.remove(OUTPUT_CSV_FILE_2)
    print(f"File {OUTPUT_CSV_FILE_2} deleted successfully.")
except FileNotFoundError:
    print(f"File {OUTPUT_CSV_FILE_2} not found.")



# ------------------------------------------------------------------
# 1 - Run -- Reinitialisation of ro_puf
print("\n- 1 - Launch init RO ------------------------------------------------------------------------------------\n")
filter_functions.init_RO(TOP_VHDL_PATH, "signal ro_filter ")


# ------------------------------------------------------------------
# 2 - Run -- Vivado script
if (args.vivado and not args.filter):
    print("\n- 2 - Launch vivado ------------------------------------------------------------------------------------\n")
    subprocess.run(['vivado', '-mode', 'batch', '-source', VIVADO_TCL_SCRIPT])


# ------------------------------------------------------------------
# 3 - Run -- Communication_PUF.py
print("\n- 3 - Launch Communication_PUF.py ------------------------------------------------------------------\n")
subprocess.run(['python3', SCRIPT_PYTHON_PATH+'/Communication_PUF.py', '--frame', TRAME_TO_SEND_STR, '--bits_resp', "256", '--uart_port', USB_PORT, '--output_csv', OUTPUT_DATA_PATH+OUTPUT_CSV_FILE])


# ------------------------------------------------------------------
# 4 - Run -- Filter_functions (select correct blocks)
if (args.filter):
    print("\n- 4 - Launch filter.py -----------------------------------------------------------------------\n")

    # parse timing
    match args.speed:
        case "001":
            timing_wait = 1000
        case "010":
            timing_wait = 100
        case "011":
            timing_wait = 10
        case "100":
            timing_wait = 1

    # load results in a file
    bits_dict, frequencies_dict = data_ro_parser.parse_file(OUTPUT_DATA_PATH+OUTPUT_CSV_FILE, 256, timing_wait)
    frequencies_dict_mean       = data_ro_parser.get_mean_values(frequencies_dict)

    # Extract a bit flip dict with index
    bit_flip_index, largest_gap = filter_functions.get_gap_bit_flip(bits_dict, frequencies_dict)

    # Generate a string with constraints
    gap_bit_flip   = largest_gap
    gap_aliasing   = None
    filtered_pairs = filter_functions.RO_pair_filter(frequencies_dict_mean, bit_flip_index, gap_bit_flip, gap_aliasing)

    # Replace the string in the top_VHDL
    number_of_ones = filter_functions.replace_RO_line(TOP_VHDL_PATH, "signal ro_filter ", filtered_pairs)

    print(f"Size of new response expected : {number_of_ones}")
    print(filtered_pairs)


# ------------------------------------------------------------------
# 6 - Run -- Vivado script
if (args.vivado and args.filter):
    print("\n- 6 - Launch vivado ------------------------------------------------------------------------------------\n")
    subprocess.run(['vivado', '-mode', 'batch', '-source', VIVADO_TCL_SCRIPT])


# ------------------------------------------------------------------
# 7 - Run -- Communication_PUF.py
if (args.vivado and args.filter):
    print("\n- 7 - Launch Communication_PUF.py ------------------------------------------------------------------\n")
    subprocess.run(['python3', SCRIPT_PYTHON_PATH+'/Communication_PUF.py', '--frame', TRAME_TO_SEND_STR, '--bits_resp', str(number_of_ones), '--uart_port', USB_PORT, '--output_csv', OUTPUT_DATA_PATH+OUTPUT_CSV_FILE_2])


# ------------------------------------------------------------------
# 8 - Plot data at end
if (args.filter):
    print(f"pairs used is now : {filtered_pairs}")
    print(f"END of program - size of response expected : {number_of_ones}")
    print(f"Gap_bit_flip used : {gap_bit_flip}")
    print(f"Use it as args for script <run_multiple_response>")

