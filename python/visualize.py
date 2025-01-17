import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import numpy as np
from collections import Counter
import argparse


# ----------------------------------------------------------------------------------------
#                             DATA AREA



# parse_line()
# - input time spent in ms
# - return response, frequency1, frequency2
# -----------------------------------------------------------------------
def parse_line(line, time_spent=10):
    parts = line.strip().split(',')
    if len(parts) != 3:
        raise ValueError("La ligne doit contenir exactement trois valeurs séparées par des virgules.")
    response   = int(parts[0])
    frequency1 = float(parts[1]) * (1000 / time_spent)
    frequency2 = float(parts[2]) * (1000 / time_spent)
    return response, frequency1, frequency2



# parse_file()
# - bits_dict        -> return [index]{'0' = count 0, '1' = count 1}
# - frequencies_dict -> return [index]{'freq1' = [resp0, resp1 ...], 'freq2' = [resp0, resp1 ...]}
# -----------------------------------------------------------------------
def parse_file(file_path, nb_ro = 256, time_spent=10):
    current_index    = 0
    frequencies_dict = [{'freq1': [], 'freq2': []}   for _ in range(nb_ro)]
    bits_dict        = [{'0': 0, '1': 0} for _ in range(nb_ro)]

    with open(file_path, 'r') as file:
        lines = file.readlines()
        # Vérifier si le nombre de lignes est un multiple du nombre de RO activées
        if len(lines) % nb_ro != 0:
            raise ValueError("Le fichier doit contenir un nombre de lignes multiple de " + nb_ro)

        # Traiter chaque ligne
        for line in lines:

            response, frequency1, frequency2 = parse_line(line, time_spent)
            frequencies_dict[current_index]['freq1'].append(frequency1)
            frequencies_dict[current_index]['freq2'].append(frequency2)
            if response == 1:
                bits_dict[current_index]['1'] += 1
            else:
                bits_dict[current_index]['0'] += 1

            current_index += 1
            if current_index == nb_ro:
                current_index = 0
    return bits_dict, frequencies_dict



# get_mean_values()
# - return [index]{'freq1' = mean, 'freq2' = mean}
# -----------------------------------------------------------------------
def get_mean_values(frequencies_dict):
    nb_ro = len(frequencies_dict)
    frequencies_mean = [{'freq1': 0, 'freq2': 0}   for _ in range(nb_ro)]

    for i in range(nb_ro):
        if frequencies_dict[i]['freq1']:  # Avoid the division by zero
            frequencies_mean[i]['freq1'] = np.mean(frequencies_dict[i]['freq1'])
        if frequencies_dict[i]['freq2']:
            frequencies_mean[i]['freq2'] = np.mean(frequencies_dict[i]['freq2'])

    return frequencies_mean



# ----------------------------------------------------------------------------------------
#                             PLOTTING AREA



# Plot 2D graph of frequencies heatmap
# -----------------------------------------------------------------------
def plot_2D_heatmap(frequencies_dict):
    nb_cols  = 15
    nb_lines = 50

    Z = np.zeros((nb_lines, nb_cols))
    x = np.arange(nb_cols + 1)
    y = np.arange(nb_lines + 1)

    for col in range(11):
        for line in range(25):
            index = col * 25 + line
            if index >= len(frequencies_dict):
                break
            Z[2*line, col]   = frequencies_dict[index]['freq1'] / 1000000
            Z[2*line+1, col] = frequencies_dict[index]['freq2'] / 1000000

    # Création de la figure et de l'axe
    fig, ax = plt.subplots(figsize=(8, 6))
    # Affichage avec pcolormesh
    mesh = ax.pcolormesh(x, y, Z, shading='flat', cmap='viridis', vmin=Z.min(), vmax=Z.max())
    # Ajout d'une barre de couleur
    plt.colorbar(mesh, ax=ax, label="Frequency Value")

    # Configuration de l'axe
    ax.set_title("Heatmap des Fréquences en MHz")
    ax.set_xlabel("Colonnes - index X RO")
    ax.set_ylabel("Lignes - index Y RO")
    ax.invert_yaxis()



# Plot 2D graph of frequencies differences
# -----------------------------------------------------------------------
def plot_2D_heatmap_diff_freq(frequencies_dict):
    nb_cols  = 15
    nb_lines = 25

    Z = np.zeros((nb_lines, nb_cols))
    x = np.arange(nb_cols + 1)
    y = np.arange(nb_lines + 1)

    for col in range(11):
        for line in range(25):
            index = col * 25 + line
            if index >= len(frequencies_dict):
                break
            div = frequencies_dict[index]['freq1'] - frequencies_dict[index]['freq2']
            Z[line, col] = div // 1000000

    # Création de la figure et de l'axe
    fig, ax = plt.subplots(figsize=(8, 6))
    # Affichage avec pcolormesh
    mesh = ax.pcolormesh(x, y, Z, shading='flat', cmap='viridis', vmin=Z.min(), vmax=Z.max())
    # Ajout d'une barre de couleur
    plt.colorbar(mesh, ax=ax, label="Frequency Value")

    # Configuration de l'axe
    ax.set_title("Heatmap des différences de Fréquences en MHz")
    ax.set_xlabel("Colonnes - index X RO")
    ax.set_ylabel("Lignes - index Y RO")
    ax.invert_yaxis()






# -----------------------------------------------------------------------
# HISTOGRAM
def plot_histogram(bit_counts):
    # Extraire les valeurs pour les histogrammes
    zeros = [bit_count['0'] for bit_count in bit_counts]
    ones  = [bit_count['1'] for bit_count in bit_counts]
    # Indices
    indices = np.arange(len(bit_counts))

    # Largeur des barres
    bar_width = 1  # Réduire la largeur des barres pour mieux visualiser les différences de couleurs
    # Définir les couleurs
    zero_color = 'green'
    one_color = 'red'
    # Créer la figure
    plt.figure(3, figsize=(12, 6))

    # Dessiner les barres
    for idx in indices:
        if zeros[idx] > 0 and ones[idx] > 0:
            # Si les deux valeurs sont non nulles, dessiner deux barres séparées
            plt.bar(idx, zeros[idx], bar_width, label='0' if idx == 0 else "", color=zero_color)
            plt.bar(idx, ones[idx] , bar_width, label='1' if idx == 0 else "", color=one_color, bottom=zeros[idx])
        elif zeros[idx] > 0:
            plt.bar(idx, zeros[idx], bar_width, color='white')
        elif ones[idx] > 0:
            plt.bar(idx, ones[idx] , bar_width, color='white')

    # Ajouter des légendes et des titres
    plt.xlabel('Index des bits')
    plt.ylabel('Nombre d\'occurrences')
    plt.title(f'Histogramme des occurrences de 0 {zero_color} et 1 {one_color} pour chaque bit flip')
    plt.legend()

# -----------------------------------------------------------------------
# FREQUENCY DISTRIBUTION
def plot_frequency_distribution(file_path, precision):

    #Dictionnaire pour compter les occurrences de fréquences
    freq_counter = Counter()

    #Lecture des données du fichier
    with open(file_path, 'r') as file:
        for line in file:
            #Parser la ligne pour en extraire les données
            _, freq1, freq2 = parse_line(line)

            #Conversion des fréquences de Hz à MHz
            freq1_in_MHz = freq1/1000000
            freq2_in_MHz = freq2/1000000

            #Arrondir les fréquences à la précision donnée
            #precision=0.1 arrondit à un chiffre après la virgule, precision=1 arrondit à l’unité
            rounded_freq1 = round(freq1_in_MHz, precision)
            rounded_freq2 = round(freq2_in_MHz, precision)

            #Ajouter les fréquences arrondies au compteur
            freq_counter[rounded_freq1] += 1
            freq_counter[rounded_freq2] += 1

    #Conversion du compteur en liste triée
    sorted_frequencies = sorted(freq_counter.items())  # [(fréquence, occurrences), ...]

    #Séparation des fréquences et des occurrences
    frequencies = [item[0] for item in sorted_frequencies]
    occurrences = [item[1] for item in sorted_frequencies]

    # Créer la figure
    plt.figure(2, figsize=(12, 6))
    plt.bar(frequencies, occurrences, color='blue', alpha=0.7, label="Occurence des fréquences")

    # Ajouter les labels et le titre
    plt.xlabel('Fréquences (en MHz)')
    plt.ylabel('Nombre d\'occurrences')
    plt.title('Distribution des fréquences (arrondies à {} MHz)'.format(precision))
    plt.legend()
    plt.grid(True)


# -----------------------------------------------------------------------
# GAP DISTRIBUTION
def plot_gap_distribution(file_path, precision):

    #Dictionnaire pour compter les occurrences de gap entre 2 fréquences
    gap_counter = Counter()

    #Lecture des données du fichier
    with open(file_path, 'r') as file:
        for line in file:
            #Parser la ligne pour en extraire les données
            _, freq1, freq2 = parse_line(line)

            #Conversion des fréquences de Hz à MHz
            gap = freq1/1000000 - freq2/1000000

            #Arrondir les gaps à la précision donnée
            #precision=0.1 arrondit à un chiffre après la virgule, precision=1 arrondit à l’unité
            rounded_gap = round(gap, precision)

            #Ajouter les gaps arrondis au compteur
            gap_counter[rounded_gap] += 1

    #Conversion du compteur en liste triée
    sorted_gaps = sorted(gap_counter.items())  # [(gap, occurrences), ...]

    #Séparation des fréquences et des occurrences
    gaps = [item[0] for item in sorted_gaps]
    occurrences = [item[1] for item in sorted_gaps]

    # Créer la figure
    plt.figure(1, figsize=(12, 6))
    plt.bar(gaps, occurrences, color='orange', alpha=0.7, label="Occurence des gaps")

    # Ajouter les labels et le titre
    plt.xlabel('Différences de fréquences entre les 2 compteurs (en MHz)')
    plt.ylabel('Nombre d\'occurrences')
    plt.title('Distribution des différences de fréquences (arrondies à {} MHz)'.format(precision))
    plt.legend()
    plt.grid(True)



# -----------------------------------------------------------------------
# Main program to parse data
def analyse_data(file_path):

    print("Start processing the file...")

    # Lire le fichier en mode ligne par ligne
    with open(file_path, 'r') as file:
        lines = file.readlines()

        nb_ro = 256

        bit_counts    = [{'0': 0, '1': 0} for _ in range(nb_ro)]
        current_index = 0
        bits_flip     = [] #tableau pour les bits flips
        bits_normal   = []
        processed_lines = set()
        largest_gap = 0

        # Vérifier si le nombre de lignes est un multiple du nombre de RO activées
        if len(lines) % nb_ro != 0:
            raise ValueError("Le fichier doit contenir un nombre de lignes multiple de " + nb_ro)

        # Traiter chaque ligne
        for line in lines:
            response, frequency1, frequency2 = parse_line(line)

            # Incrémenter le compteur correspondant (0 ou 1)
            if response == 0:
                bit_counts[current_index]['0'] += 1
            elif response == 1:
                bit_counts[current_index]['1'] += 1

            difference = frequency1 - frequency2
            if bit_counts[current_index]['0'] > 0 and bit_counts[current_index]['1'] > 0: #and current_index not in processed_lines:
                bits_flip.append({
                    'index': current_index,
                    'difference': difference,
                    'response': response
                })
                #processed_lines.add(current_index)
                if difference > largest_gap:
                    largest_gap = difference
            else:
                bits_normal.append({
                    'index': current_index,
                    'difference': difference,
                    'response': response
                })
            current_index += 1
            if current_index == nb_ro:
                current_index = 0


        bits_flip   = sorted(bits_flip, key= lambda x: x['index'])
        bits_normal = sorted(bits_normal, key= lambda x: x['index'])

    print("Processing completed.")
    #print(bits_flip)
    for entry in bits_flip:
        print(entry)

    #for entry in bits_normal:
        #print(entry)
    print("The largest gap for a bit flip is:", largest_gap)
    plot_gap_distribution(file_path, 1)
    plot_frequency_distribution(file_path, 1)
    plot_histogram(bit_counts)
    # Afficher le graphique
    plt.show()




def main():
    # Parse arguments
    parser = argparse.ArgumentParser(description="Script to run different plots")
    parser.add_argument("-f", "--file", type=str, help="give the file path", required=True)
    parser.add_argument("-t", "--time", type=int, help="give the time in milliseconds (ms) spent in counters (default = 10ms)", required=False, default=10)
    parser.add_argument("-r", "--ring", type=int, help="give the file path (default = 256)", required=False, default=256)
    args = parser.parse_args()

    # Parse file
    bits_dict, frequencies_dict = parse_file(args.file, args.ring, args.time)

    # grab means
    frequencies_mean = get_mean_values(frequencies_dict)

    # Plot graphs
    plot_2D_heatmap_diff_freq(frequencies_mean)
    plot_2D_heatmap(frequencies_mean)

    plt.show()


if __name__ == "__main__":
    main()

