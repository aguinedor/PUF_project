# Dependencies 
import argparse
import subprocess
import os
# TODO clean this
import filter_functions
from filter_functions import load_csv
from filter_functions import RO_pair_filter
from replace_function import replace_RO
from replace_function import init_RO

# --------------------------------------------------
#               Global variables 
VIVADO_TCL_SCRIPT  = '/tp/xph3app/xph3app605/PUF_PROJECT/Script_puf/Script_vivado/vivado_flow.tcl'
OUTPUT_CSV_FILE    = '/tp/xph3app/xph3app605/PUF_PROJECT/Output_fpga_puf/RO_PUF_GUINEDOR_ADRIEN.csv'
TOP_VHDL_PATH      = '/tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/ro_puf_top.vhd'
OUTPUT_CSV_FILE_2  = '/tp/xph3app/xph3app605/PUF_PROJECT/Output_fpga_puf/RO_PUF_CORRECTED.csv'
SCRIPT_PYTHON_PATH = '/tp/xph3app/xph3app605/PUF_PROJECT/Script_puf/Script_Python'

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
args = parser.parse_args()

# Access the arguments
print("- 0 - Global Informations ------------------------------------------------------------------------------")
print(f"Vivado enabled : {args.vivado}")
print(f"Filter enabled : {args.filter}")
print(f"UART Port      : {args.uart_port}")
print(f"PUF Mode       : {args.puf_mode}")
print(f"Speed          : {args.speed}")



USB_PORT          = args.uart_port
TRAME_TO_SEND_STR = '1'+args.puf_mode+'000'+args.speed
print(f"Result Frame   : {TRAME_TO_SEND_STR}")

print(f"")
print(f" VIVADO_TCL_SCRIPT : {VIVADO_TCL_SCRIPT}")
print(f" OUTPUT_CSV_FILE   : {OUTPUT_CSV_FILE}")
print(f" TOP_VHDL_PATH     : {TOP_VHDL_PATH}")
print(f" OUTPUT_CSV_FILE_2 : {OUTPUT_CSV_FILE_2}")

# remove files
"""
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
"""


# [7]   => PUF_START, , , , ,counter_timer[0],counter_timer[1], counter_timer[2]] -> "001":12000000, "010":1200000, "011":120000, "100": 12000
# [6]   => Mode_select (1: random; 0: pear to pear)
# [5:3] => Not used
# ------------------------------------------------------------------
# [2:0] => [counter_timer[2] counter_timer[1] counter_timer[0]]
# "001":12000000
# "010":1200000
# "011":120000
# "100": 12000


# ------------------------------------------------------------------
# 1 - Run -- Reinitialisation of ro_puf
print("\n- 1 - Launch vivado ------------------------------------------------------------------------------------\n")
#init_RO(TOP_VHDL_PATH, "signal ro_filter ")


# ------------------------------------------------------------------
# 2 - Run -- Vivado script
#if (args.vivado):
    #print("\n- 2 - Launch vivado ------------------------------------------------------------------------------------\n")

    #subprocess.run(['vivado', '-mode', 'batch', '-source', VIVADO_TCL_SCRIPT])


# ------------------------------------------------------------------
# 3 - Run -- Communication_PUF_256.py

print("\n- 3 - Launch Communication_PUF_256.py ------------------------------------------------------------------\n")
#subprocess.run(['python3', SCRIPT_PYTHON_PATH+'/Communication_PUF_256.py', '--frame', TRAME_TO_SEND_STR, '--uart_port', USB_PORT, '--output_csv', OUTPUT_CSV_FILE])


# ------------------------------------------------------------------
# 4 - Run -- Filter_functions (select correct blocks)
print("\n- 4 - Launch Filter_functions.py -----------------------------------------------------------------------\n")

if (args.filter):
    loaded_results_csv = load_csv(OUTPUT_CSV_FILE)
    filtered_pairs     = filter_functions.RO_pair_filter(loaded_results_csv, args.speed)
    print(filtered_pairs)

 	
# ------------------------------------------------------------------
# 5 - Run -- replace_RO (modify code)
print("\n- 5 - Launch replace_RO.py ----------------------------------------------------------------------\n")
if (args.filter):
    replace_RO(TOP_VHDL_PATH, "signal ro_filter ", filtered_pairs)


# ------------------------------------------------------------------
# 6 - Run -- Vivado script
if (args.vivado and args.filter):
    print("\n- 6 - Launch vivado ------------------------------------------------------------------------------------\n")
    subprocess.run(['vivado', '-mode', 'batch', '-source', VIVADO_TCL_SCRIPT])


# ------------------------------------------------------------------
# 7 - Run -- Communication_PUF_256.py
print("\n- 7 - Launch Communication_PUF_256.py ------------------------------------------------------------------\n")

#if (args.filter):
    #subprocess.run(['python3', SCRIPT_PYTHON_PATH+'/Communication_PUF_256.py', '--frame', TRAME_TO_SEND_STR, '--uart_port', USB_PORT, '--output_csv', OUTPUT_CSV_FILE_2])





