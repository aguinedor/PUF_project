import numpy as np

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
