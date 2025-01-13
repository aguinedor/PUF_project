import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import numpy as np


def parse_line(line):
    parts = line.strip().split(',')
    if len(parts) != 3:
        raise ValueError("La ligne doit contenir exactement trois valeurs séparées par des virgules.")
    response = int(parts[0])
    fréquence1 = float(parts[1])
    fréquence2 = float(parts[2])
    return response, fréquence1, fréquence2


import numpy as np
import matplotlib.pyplot as plt

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
    plt.figure(figsize=(12, 6))

    # Dessiner les barres
    for idx in indices:
        if zeros[idx] > 0 and ones[idx] > 0:
            # Si les deux valeurs sont non nulles, dessiner deux barres séparées
            plt.bar(idx, zeros[idx], bar_width, label='0' if idx == 0 else "", color=zero_color)
            plt.bar(idx, ones[idx] , bar_width, label='1' if idx == 0 else "", color=one_color, bottom=zeros[idx])
        elif zeros[idx] > 0:
            plt.bar(idx, zeros[idx], bar_width, color='grey')
        elif ones[idx] > 0:
            plt.bar(idx, ones[idx] , bar_width, color='black')

    # Ajouter des légendes et des titres
    plt.xlabel('Index des bits')
    plt.ylabel('Nombre d\'occurrences')
    plt.title(f'Histogramme des occurrences de 0 {zero_color} et 1 {one_color} pour chaque bit')
    plt.legend()

    # Afficher le graphique
    plt.show()


def analyse_data(file_path):

    bit_counts    = [{'0': 0, '1': 0} for _ in range(256)]
    current_index = 0

    print("Start processing the file...")

    # Lire le fichier en mode ligne par ligne
    with open(file_path, 'r') as file:
        lines = file.readlines()

        # Vérifier si le nombre de lignes est un multiple de 256
        if len(lines) % 256 != 0:
            raise ValueError("Le fichier doit contenir un nombre de lignes multiple de 256.")

        # Traiter chaque ligne
        for line in lines:
            #print(f"line : {line}  index : {current_index}")
            # Analyser la ligne avec parse_line

            response, _, _ = parse_line(line)

            # Incrémenter le compteur correspondant (0 ou 1)
            if response == 0:
                bit_counts[current_index]['0'] += 1
            elif response == 1:
                bit_counts[current_index]['1'] += 1

            current_index += 1
            if current_index == 256:
                current_index = 0

    print("Processing completed.")
    plot_histogram(bit_counts)

analyse_data("RO_PUF.txt")