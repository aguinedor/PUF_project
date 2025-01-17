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
# - bits_dict        -> return [index][bit0, bit1, bit2 ...]
# - frequencies_dict -> return [index]{'freq1' = [resp0, resp1 ...], 'freq2' = [resp0, resp1 ...]}
# -----------------------------------------------------------------------
def parse_file(file_path, nb_ro = 256, time_spent=10):
    current_index    = 0
    frequencies_dict = [{'freq1': [], 'freq2': []}   for _ in range(nb_ro)]
    bits_dict        = [[] for _ in range(nb_ro)]

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
            bits_dict[current_index].append(response)

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
    plt.colorbar(mesh, ax=ax, label="Frequency Value")

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

    for idx in range(nb_ro):
        for ite in range(nb_it):
            if ite == 0:
                continue

            if bits_dict[idx][ite] != bits_dict[idx][ite-1]:
                # Store frequencies gap when bit flip
                gap[idx][ite] = abs(frequencies_dict[idx]['freq1'][ite] - frequencies_dict[idx]['freq2'][ite])
                flip_info.append({ 'index': idx, 'iteration': ite, 'difference': gap[idx][ite], 'response': bits_dict[idx][ite] })

                if gap[idx][ite] > gap[idx][ite-1]:
                    # Actualize new max gap value
                    gap_max[idx] = gap[idx][ite]

    largest_gap = max(gap_max)
    flip_info = sorted(flip_info, key= lambda x: x['index'])

    for entry in flip_info:
        print(entry)
    print("The largest gap for a bit flip is: ", largest_gap)





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
    bits_dict, frequencies_dict = parse_file(args.file, args.ring, args.time)
    frequencies_mean = get_mean_values(frequencies_dict)

    # 1 - Plot text
    bit_flip_analysis(bits_dict, frequencies_dict)

    # 2 -Plot graphs
    plot_2D_heatmap_diff_freq(frequencies_mean)
    plot_2D_heatmap(frequencies_mean)
    plot_gap_distribution(frequencies_dict, 1)
    plot_histogram(bits_dict)
    plot_frequency_distribution(frequencies_dict)
    plt.show()


if __name__ == "__main__":
    main()

