import subprocess
import argparse

parser = argparse.ArgumentParser(description="Global PUF : run the whole script for PUF implementation")

parser.add_argument('--uart_port' , type=str , default='/dev/ttyUSB0'       , help='Select the uart port - default: /dev/ttyUSB0')
parser.add_argument('--trame'     , type=str , default='10000011'           , help='Select the frame     - default: 10000011')
parser.add_argument('--output_csv', type=str , default='RO_PUF_multiple.csv', help='Select the output    - default: RO_PUF_multiple.csv')
parser.add_argument('--bits_resp' , type=str , default='256'                , help='Select the frame     - default: 256')
parser.add_argument('--iteration' , type=str , default='100'                , help='Select the frame     - default: 100')

args = parser.parse_args()

TRAME_TO_SEND_STR = args.trame
USB_PORT          = args.uart_port
OUTPUT_CSV_FILE   = args.output_csv
BITS_RESP         = args.bits_resp
ITERATION         = int(args.iteration)

for i in range(ITERATION):
    print(f"\n\n\n\n\n\n ----------------------       KEY NUMBER {i}       ---------------------- \n\n\n\n\n\n")
    subprocess.run(['python3', 'Communication_PUF.py', '--frame', TRAME_TO_SEND_STR, '--bits_resp', BITS_RESP, '--uart_port', USB_PORT, '--output_csv', OUTPUT_CSV_FILE])
