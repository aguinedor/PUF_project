# Dependencies
import argparse
import serial
import time
import csv
from tqdm import tqdm  # Barre de progression

# -----------------------------------------------------------------
#                       Global parameters
# -----------------------------------------------------------------
UART_TIMEOUT_SEC       = 5
BAUD_SPEED             = 9600
NB_BITS_IN_KEY         = 256
BYTES_TO_READ          = 8
SIZE_TRANSMISSION      = 64
BAUD_TIME_TRANSMISSION = NB_BITS_IN_KEY * SIZE_TRANSMISSION / BAUD_SPEED
MAX_TIME               = BAUD_TIME_TRANSMISSION



# -----------------------------------------------------------------
#                       Parser section
# -----------------------------------------------------------------
parser = argparse.ArgumentParser(description="Communication PUF 256 : Send the frame to the fpga")
# Add args
parser.add_argument('--frame'     , type=str, default='10000001'    , help='Select the 8bits frame to send' , required=True)
parser.add_argument('--uart_port' , type=str, default='/dev/ttyUSB0', help='Select the uart port to connect', required=True)
parser.add_argument('--output_csv', type=str, default='/tp/xph3app/xph3app605/PUF_PROJECT/Output_fpga_puf/RO_PUF.csv', help='Select the counter output csv file ', required=False)
parser.add_argument('--response_csv', type=str, default='/tp/xph3app/xph3app605/PUF_PROJECT/Output_fpga_puf/RO_PUF_RESPONSE.csv', help='Select the response output csv file', required=False)
# Parse args
args = parser.parse_args()
# Access the arguments
print("----------------------- ArgParse section -----------------------")
print(f"frame to send: {args.frame}")
print(f"UART Port: {args.uart_port}")
print(f"output csv: {args.output_csv}")



# -----------------------------------------------------------------
#                      UART Setup section
# -----------------------------------------------------------------
# Configuration du port série
ser = serial.Serial(args.uart_port, 9600, timeout=UART_TIMEOUT_SEC)
# Attendre que le port série soit prêt
ser.reset_input_buffer()



# -----------------------------------------------------------------
#                     FRAME Setup section
# -----------------------------------------------------------------
data_to_send_list = [args.frame] 
print(data_to_send_list)
# [7]   => PUF_START, , , , ,counter_timer[0],counter_timer[1], counter_timer[2]] -> "001":12000000, "010":1200000, "011":120000, "100": 12000
# [6]   => Mode_select (1: random; 0: pear to pear)
# [5:3] => Not used
# ------------------------------------------------------------------
# [2:0] => [counter_timer[2] counter_timer[1] counter_timer[0]]
# "001":12000000
# "010":1200000
# "011":120000
# "100": 12000
# Fonction pour envoyer des données sur le port série
def send_data(bits_str):
    data_bytes = bytes([int(bits_str, 2)])
    ser.write(data_bytes)
    print(f"Data sent: {data_bytes.hex()}")
# Envoyer les données initiales
send_data(data_to_send_list[0])



# -----------------------------------------------------------------
#                  PROGRESSION BAR Setup section
# -----------------------------------------------------------------
# Durée maximale en secondes (900 secondes = 15 minutes)
print(data_to_send_list[0][-3:])
if data_to_send_list[0][-3:]   == "001":
    MAX_TIME += NB_BITS_IN_KEY * 1
elif data_to_send_list[0][-3:] == "010":
    MAX_TIME += NB_BITS_IN_KEY * 0.1
elif data_to_send_list[0][-3:] == "011":
    MAX_TIME += NB_BITS_IN_KEY * 0.01
elif data_to_send_list[0][-3:] == "100":
    MAX_TIME += NB_BITS_IN_KEY * 0.001

# Barre de progression sur 900 secondes (15 minutes)
progress_bar = tqdm(total=MAX_TIME, bar_format="{l_bar}{bar}| {n_fmt}/{total_fmt} sec", colour="magenta")

# Temps de début
start_time = time.time()

# -----------------------------------------------------------------
#                          While Loop
# -----------------------------------------------------------------
CPT_BIT = 0
response_value = ""
# Lire les données de l'UART en continu pendant 900 secondes (15 minutes)
while True:
    try:
        elapsed_time = time.time() - start_time
        # Mettre à jour la barre de progression en fonction du temps écoulé
        progress_bar.n = min(int(elapsed_time), MAX_TIME)
        progress_bar.refresh()

        # Vérifier si 900 secondes (15 minutes) se sont écoulées
        if elapsed_time > MAX_TIME + 1:
            print(f"\nTemps écoulé : {MAX_TIME} secondes")
            break
      
        # Lire un bloc de données de l'UART
        data = ser.read(BYTES_TO_READ)

	# If no data was read (e.g., timeout occurred for 5 secondes ), skip the iteration
        if len(data) == 0:
            break  # Skip this loop iteration

        CPT_BIT = CPT_BIT + 1
        # Si la longueur des données lues est inférieure à BYTES_TO_READ, remplir avec des zéros
        if len(data) < BYTES_TO_READ:
            data += bytes(BYTES_TO_READ - len(data))
        
        # Afficher les données lues sous forme binaire sur 64 bits
        binary_data = format(int.from_bytes(data, byteorder='big'), '064b')
        
        # Extraire la réponse du PUF (bit de poids fort)
        puf_response = binary_data[0]
        
        # Extraire la différence du compteur (bits de 6 à 0)
        counter_difference2 = int(binary_data[1:33], 2)  # Conversion binaire en décimal
        counter_difference1 = int(binary_data[33:] , 2)  # Conversion binaire en décimal
        print(binary_data)
        print("[{}]PUF Response : {} and Counter Difference : MUX1 - {} and MUX2 - {}".format(CPT_BIT, puf_response, counter_difference1, counter_difference2))

        # Écrire les données dans un fichier CSV
        with open(args.output_csv, 'a', newline='') as file:
            writer = csv.writer(file)
            writer.writerow([puf_response, counter_difference1, counter_difference2])

        response_value = response_value + puf_response
            
        if CPT_BIT > 255:
            break
		
    except KeyboardInterrupt:
        # Quitter la boucle en cas d'interruption du clavier (CTRL+C)
        break

#if data_to_send_list[0][1]:
with open(args.response_csv, 'a', newline='') as file2:
    writer = csv.writer(file2)
    writer.writerow([response_value])
#else:
    #with open(args.response_csv, 'a', newline='') as file3:
        #writer = csv.writer(file3)
        #writer.writerow([response_value])
            
# Fermer le port série à la fin
ser.close()

# Fermer la barre de progression
progress_bar.close()
