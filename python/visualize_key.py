# Je possède un module qui fournit un fichier csv composé de multiple de 256 lignes qui correspondent à un bit dans une clé (taille 256). 
# On peut alors avoir plusieurs clés par fichier. L'idée est de visualiser un histogramme qui compte le nombre de résultats = 0 ou de résultats = 1 pour chacuns des index. 
# Propose moi un script python basé sur matplotlib qui permet d'afficher cet histogramme.
import csv
import subprocess
from replace_function import init_RO


TRAME_TO_SEND_STR = '10000011'
USB_PORT = '/dev/ttyUSB0'
OUTPUT_CSV_FILE = '/tp/xph3app/xph3app605/PUF_PROJECT/Output_fpga_puf/RO_PUF_GUINEDOR_ADRIEN_FILTERING.csv'
TOP_VHDL_PATH   = '/tp/xph3app/xph3app605/PUF_PROJECT/sources/Code_vhdl_puf/ro_puf_top.vhd'
VIVADO_TCL_SCRIPT  = '/tp/xph3app/xph3app605/PUF_PROJECT/Script_puf/Script_vivado/vivado_flow.tcl'

#init_RO(TOP_VHDL_PATH, "signal ro_filter ")
#subprocess.run(['vivado', '-mode', 'batch', '-source', VIVADO_TCL_SCRIPT])
for i in range(100):
    print(f"\n\n\n\n\n\n ----------------------       KEY NUMBER {i}       ---------------------- \n\n\n\n\n\n")
    subprocess.run(['python3', 'Communication_PUF_256.py', '--frame', TRAME_TO_SEND_STR, '--uart_port', USB_PORT, '--output_csv', OUTPUT_CSV_FILE])
