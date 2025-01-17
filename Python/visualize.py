import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import numpy as np
from collections import Counter


# -----------------------------------------------------------------------
# Parse lines
def parse_line(line):
    parts = line.strip().split(',')
    if len(parts) != 3:
        raise ValueError("La ligne doit contenir exactement trois valeurs séparées par des virgules.")
    response   = int(parts[0])
    frequency1 = float(parts[1])/float(0.01)
    frequency2 = float(parts[2])/float(0.01)
    return response, frequency1, frequency2

# -----------------------------------------------------------------------
# Parse files
def parse_file(file_path):
    nb_ro            = 256
    current_index    = 0
    frequencies_dict = [{'freq1': [], 'freq2': []}   for _ in range(nb_ro)]
    bits_dict        = [{'freq1': '0', 'freq2': '1'} for _ in range(nb_ro)]

    with open(file_path, 'r') as file:
        lines = file.readlines()
        # Vérifier si le nombre de lignes est un multiple du nombre de RO activées
        if len(lines) % nb_ro != 0:
            raise ValueError("Le fichier doit contenir un nombre de lignes multiple de " + nb_ro)

        # Traiter chaque ligne
        for line in lines:

            response, frequency1, frequency2 = parse_line(line)
            frequencies_dict[current_index]['freq1'].append(frequency1)
            frequencies_dict[current_index]['freq1'].append(frequency2)
            if response == 1:
                bits_dict[current_index]['1'] += 1
            else:
                bits_dict[current_index]['0'] += 1

            current_index += 1
            if current_index == nb_ro:
                current_index = 0
    return bits_dict, frequencies_dict



# -----------------------------------------------------------------------
# Plot 2D graph
def plot_2D_implementation(frequencies_dict):
    nb_cols  = 15
    nb_lines = 50

    Z = np.arange(nb_lines * nb_cols).reshape(nb_lines, nb_cols)
    x = np.arange(nb_cols + 1)
    y = np.arange(nb_lines + 1)

    fig, ax = plt.subplots()
    ax.pcolormesh(x, y, Z, shading='flat', vmin=Z.min(), vmax=Z.max())

    def _annotate(ax, x, y, title):
        # this all gets repeated below:
        X, Y = np.meshgrid(x, y)
        ax.plot(X.flat, Y.flat, 'o', color='m')
        ax.set_xlim(0, 15)
        ax.set_ylim(0, 49)
        ax.set_title(title)

    _annotate(ax, x, y, "shading='flat'")


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


analyse_data("RO_PUF.csv")
