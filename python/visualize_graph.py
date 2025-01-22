import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
import numpy as np
from collections import Counter
import argparse

import PUF_project.python.data_ro_parser as data_ro_parser


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

    min_value = frequencies_dict[0]['freq1'] / 1000000
    max_value = 0
    '''
    for col in range(15):
        for line in range(50):
            Z[line, col] = np.nan
    '''
    for col in range(11):
        for line in range(25):
            index = col * 25 + line
            if index >= len(frequencies_dict):
                break
            fr1 = frequencies_dict[index]['freq1'] / 1000000
            fr2 = frequencies_dict[index]['freq2'] / 1000000

            Z[2*line, col]   = fr1
            if fr1 < min_value:
                min_value = fr1
            if fr1 > max_value:
                max_value = fr1
            Z[2*line+1, col] = fr2
            if fr2 < min_value:
                min_value = fr2
            if fr2 > max_value:
                max_value = fr2


    # Création de la figure et de l'axe
    fig, ax = plt.subplots(figsize=(8, 6))
    # Affichage avec pcolormesh
    mesh = ax.pcolormesh(x, y, Z, shading='flat', cmap='viridis', vmin=min_value, vmax=max_value)
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


# Gap Distribution
# - precision -> arrondit à un chiffre après la virgule, precision=1 arrondit à l’unité
# - round     -> indique la division en fréquence à réaliser default 1Mhz
# -----------------------------------------------------------------------
def plot_gap_distribution(frequencies_dict, precision, div_freq= 1000000):

    nb_ro = len(frequencies_dict)
    nb_it = len(frequencies_dict[0]['freq1'])
    #Dictionnaire pour compter les occurrences de gap entre 2 fréquences
    gap_counter = Counter()

    for i in range(nb_ro):
        for j in range(nb_it):

            gap = frequencies_dict[i]['freq1'][j]/div_freq - frequencies_dict[i]['freq2'][j]/div_freq
            rounded_gap = round(gap, precision)
            gap_counter[rounded_gap] += 1

    #Conversion du compteur en liste triée
    sorted_gaps = sorted(gap_counter.items())  # [(gap, occurrences), ...]

    #Séparation des fréquences et des occurrences
    gaps = [item[0] for item in sorted_gaps]
    occurrences = [item[1] for item in sorted_gaps]

    # Créer la figure
    plt.figure(figsize=(12, 6))
    plt.bar(gaps, occurrences, width=1, color='orange', alpha=0.7, label="Occurence des gaps")

    # Ajouter les labels et le titre
    plt.xlabel('Différences de fréquences entre les 2 compteurs (en MHz)')
    plt.ylabel('Nombre d\'occurrences')
    plt.title('Distribution des différences de fréquences (arrondies à {} MHz)'.format(precision))
    plt.legend()
    plt.grid(True)


# Histrogram
# - visualization of bits 0 or 1
# -----------------------------------------------------------------------
def plot_histogram(bits_dict, white='yes'):
    nb_cols  = len(bits_dict)
    nb_lines = len(bits_dict[0])

    Z = np.zeros((nb_lines, nb_cols))
    x = np.arange(nb_cols + 1)
    y = np.arange(nb_lines + 1)

    for col in range(nb_cols):

        if sum(bits_dict[col]) == nb_lines or sum(bits_dict[col]) == 0:
            display = 0
        else:
            display = 1

        for line in range(nb_lines):
            if white == 'no':
                Z[line, col] = bits_dict[col][line]
                continue
            if white == 'yes':
                if display:
                    Z[line, col] = bits_dict[col][line]
                else:
                    Z[line, col] = 0.5
                continue

    # Création de la figure et de l'axe
    fig, ax = plt.subplots(figsize=(12, 9))
    # Affichage avec pcolormesh
    mesh = ax.pcolormesh(x, y, Z, shading='flat', cmap='viridis', vmin=Z.min(), vmax=Z.max())
    # Ajout d'une barre de couleur
    plt.colorbar(mesh, ax=ax, label="bit value")

    # Configuration de l'axe
    ax.set_title("Heatmap of response with iteration")
    ax.set_xlabel("Colonnes - index X response")
    ax.set_ylabel("Lignes - index Y iteration")


# Frequency distribution
# -----------------------------------------------------------------------
def plot_frequency_distribution(frequencies_dict):
    nb_ro = len(frequencies_dict)
    nb_it = len(frequencies_dict[0]['freq1'])
    freq_counter = Counter()

    for idx in range(nb_ro):
        for ite in range(nb_it):

            freq1_Mhz = frequencies_dict[idx]['freq1'][ite] / 1000000
            freq2_MHz = frequencies_dict[idx]['freq2'][ite] / 1000000

            freq1 = round(freq1_Mhz, 1)
            freq2 = round(freq2_MHz, 1)

            freq_counter[freq1] += 1
            freq_counter[freq2] += 1

    #Conversion du compteur en liste triée
    sorted_frequencies = sorted(freq_counter.items())  # [(fréquence, occurrences), ...]

    #Séparation des fréquences et des occurrences
    frequencies = [item[0] for item in sorted_frequencies]
    occurrences = [item[1] for item in sorted_frequencies]

    # Créer la figure
    plt.figure(figsize=(12, 6))
    plt.bar(frequencies, occurrences, color='blue', alpha=0.7, label="Occurence des fréquences")

    # Ajouter les labels et le titre
    plt.xlabel('Fréquences (en MHz)')
    plt.ylabel('Nombre d\'occurrences')
    plt.title('Distribution des fréquences (arrondies à 1 MHz)')
    plt.legend()
    plt.grid(True)


# Plot heatmap of bits and flits
# -----------------------------------------------------------------------
def plot_heatmap_bit_flips(frequencies_dict, bit_flip_index, filtering):
    nb_cols  = 15
    nb_lines = 25

    Z = np.zeros((nb_lines, nb_cols))
    x = np.arange(nb_cols + 1)
    y = np.arange(nb_lines + 1)

    filtering_reversed = filtering[::-1]
    print(filtering_reversed)

    for col in range(11):
        for line in range(25):
            index = col * 25 + line
            if index >= len(frequencies_dict):
                break
            if index in bit_flip_index:
                Z[line, col] = 10
                print("bit flip")
                continue
            if filtering_reversed[index] == '0':
                Z[line, col] = 50
                continue
            Z[line, col] = 100

    # Création de la figure et de l'axe
    fig, ax = plt.subplots(figsize=(8, 6))
    # Affichage avec pcolormesh
    mesh = ax.pcolormesh(x, y, Z, shading='flat', vmin=Z.min(), vmax=Z.max())
    # Ajout d'une barre de couleur
    plt.colorbar(mesh, ax=ax, label="")

    # Configuration de l'axe
    ax.set_title("Heatmap des Bitflip et filtering")
    ax.set_xlabel("Colonnes - index X RO")
    ax.set_ylabel("Lignes - index Y RO")
    ax.invert_yaxis()




# ----------------------------------------------------------------------------------------
#                             TEXT PRINTING AREA


# Bit flip detector
# - take bits & frequencies as input
# -----------------------------------------------------------------------
def bit_flip_analysis(bits_dict, frequencies_dict):

    nb_ro = len(frequencies_dict)
    nb_it = len(frequencies_dict[0]['freq1'])

    print(f"ro {nb_ro}  it {nb_it}")

    #tableau multidimensionnel pour stocker les gaps de chaque index et chaque iteration
    gap            = [[0.0 for _ in range(nb_it)] for _ in range(nb_ro)]
    #tableau pour stocker la valeur max de gap pour un index
    gap_max        = [0.0 for _ in range(nb_ro)]
    #liste de dictionnaires pour stocker les différentes infos lors d'un flip (son index, son gap et sa réponse)
    flip_info      = []
    bit_flip_index = []

    for idx in range(nb_ro):
        for ite in range(nb_it):
            if ite == 0:
                continue

            if bits_dict[idx][ite] != bits_dict[idx][ite-1]:
                # Store frequencies gap when bit flip
                gap[idx][ite] = abs(frequencies_dict[idx]['freq1'][ite] - frequencies_dict[idx]['freq2'][ite])
                flip_info.append({ 'index': idx, 'iteration': ite, 'difference': gap[idx][ite], 'response': bits_dict[idx][ite] })
                if idx not in bit_flip_index:
                    bit_flip_index.append(idx)

                if gap[idx][ite] > gap[idx][ite-1]:
                    # Actualize new max gap value
                    gap_max[idx] = gap[idx][ite]

    largest_gap = max(gap_max)
    flip_info = sorted(flip_info, key= lambda x: x['index'])
    print("The largest gap for a bit flip is: ", largest_gap)

    return bit_flip_index


def filter_bits(frequencies_dict, bit_flip_index, max_gap = 3000000):
    nb_ro = len(frequencies_dict)
    my_enable = ''

    for idx in range(nb_ro):
        if idx in bit_flip_index:
            my_enable = '0' + my_enable
            continue
        diff_freq = frequencies_dict[idx]['freq1'] - frequencies_dict[idx]['freq2']
        if abs(diff_freq) > max_gap:
            my_enable = '0' + my_enable
            continue
        my_enable = '1' + my_enable

    return my_enable



# ----------------------------------------------------------------------------------------
#                                    MAIN AREA


def main():
    # Parse arguments
    parser = argparse.ArgumentParser(description="Script to run different plots")
    parser.add_argument("-f", "--file", type=str, help="give the file path", required=True)
    parser.add_argument("-t", "--time", type=int, help="give the time in milliseconds (ms) spent in counters (default = 10ms)", required=False, default=10)
    parser.add_argument("-r", "--ring", type=int, help="give the file path (default = 256)", required=False, default=256)
    args = parser.parse_args()

    # Parse file
    bits_dict, frequencies_dict = data_ro_parser.parse_file(args.file, args.ring, args.time)

    frequencies_mean    = data_ro_parser.get_mean_values(frequencies_dict)

    # 1 - Plot text
    bit_flip_index = bit_flip_analysis(bits_dict, frequencies_dict)
    string_bits    = filter_bits(frequencies_mean, bit_flip_index)

    # 2 -Plot graphs
    plot_2D_heatmap_diff_freq(frequencies_mean)
    plot_gap_distribution(frequencies_dict, 1)
    plot_2D_heatmap(frequencies_mean)
    plot_histogram(bits_dict)
    plot_heatmap_bit_flips(frequencies_mean, bit_flip_index, string_bits)

    #plot_frequency_distribution(frequencies_dict)
    plt.show()


if __name__ == "__main__":
    main()

