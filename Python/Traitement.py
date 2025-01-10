import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm
#####################################################################################################################################
db5b8e1 = np.loadtxt ('db5b8e1.csv', delimiter=',')
dbdb4fa = np.loadtxt ('dbdb4fa.csv', delimiter=',')
db5b8d0 = np.loadtxt ('db5b8d0.csv', delimiter=',')
db5b7b5 = np.loadtxt ('db5b7b5.csv', delimiter=',')
db5b54e = np.loadtxt ('db5b54e.csv', delimiter=',')
db5b52a = np.loadtxt ('db5b52a.csv', delimiter=',')
Carte_temoin = np.loadtxt ('Carte_temoin.csv', delimiter=',')



reponses_db5b8e1 = db5b8e1[:,0]
reponses_dbdb4fa = dbdb4fa[:,0]
reponses_db5b8d0 = db5b8d0[:,0]
reponses_db5b7b5 = db5b7b5[:,0]
reponses_db5b54e = db5b54e[:,0]
reponses_db5b52a = db5b52a[:,0]
reponses_Carte_temoin = Carte_temoin[:,0]


puf_db5b8e1= [reponses_db5b8e1[idx: idx + 256] for idx in range(0, len(reponses_db5b8e1), 256)]
puf_dbdb4fa= [reponses_dbdb4fa[idx: idx + 256] for idx in range(0, len(reponses_dbdb4fa), 256)]
puf_db5b8d0= [reponses_db5b8d0[idx: idx + 256] for idx in range(0, len(reponses_db5b8d0), 256)]
puf_db5b7b5= [reponses_db5b7b5[idx: idx + 256] for idx in range(0, len(reponses_db5b7b5), 256)]
puf_db5b54e= [reponses_db5b54e[idx: idx + 256] for idx in range(0, len(reponses_db5b54e), 256)]
puf_db5b52a= [reponses_db5b52a[idx: idx + 256] for idx in range(0, len(reponses_db5b52a), 256)]
puf_Carte_temoin= [reponses_Carte_temoin[idx: idx + 256] for idx in range(0, len(reponses_Carte_temoin), 256)]
#####################################################################################################################################


fig, ax = plt.subplots(figsize=(10, 8))
data_db5b8e1 = np.array(puf_db5b8e1[0]).reshape((16, 16))

heatmap = plt.imshow(data_db5b8e1 , cmap='viridis', interpolation='nearest')
plt.colorbar(heatmap)
plt.xlabel('ROs',fontsize= 22.5)
plt.ylabel('ROs',fontsize= 22.5)
fig.savefig('/home/douadiag/Bureau/HeatMap_db5b8e1.pdf', dpi=300)
# Afficher la heatmap
# plt.show()



fig, ax = plt.subplots(figsize=(10, 8))
data_dbdb4fa = np.array(puf_dbdb4fa[0]).reshape((16, 16))

heatmap = plt.imshow(data_dbdb4fa , cmap='viridis', interpolation='nearest')
plt.colorbar(heatmap)
plt.xlabel('ROs',fontsize= 22.5)
plt.ylabel('ROs',fontsize= 22.5)
fig.savefig('/home/douadiag/Bureau/HeatMap_dbdb4fa.pdf', dpi=300)
# Afficher la heatmap
# plt.show()



fig, ax = plt.subplots(figsize=(10, 8))
data_db5b8d0 = np.array(puf_db5b8d0[0]).reshape((16, 16))

heatmap = plt.imshow(data_db5b8d0 , cmap='viridis', interpolation='nearest')
plt.colorbar(heatmap)
plt.xlabel('ROs',fontsize= 22.5)
plt.ylabel('ROs',fontsize= 22.5)
fig.savefig('/home/douadiag/Bureau/HeatMap_db5b8d0.pdf', dpi=300)
# Afficher la heatmap
# plt.show()



fig, ax = plt.subplots(figsize=(10, 8))
data_db5b7b5 = np.array(puf_db5b7b5[0]).reshape((16, 16))

heatmap = plt.imshow(data_db5b7b5 , cmap='viridis', interpolation='nearest')
plt.colorbar(heatmap)
plt.xlabel('ROs',fontsize= 22.5)
plt.ylabel('ROs',fontsize= 22.5)
fig.savefig('/home/douadiag/Bureau/HeatMap_db5b7b5.pdf', dpi=300)
# Afficher la heatmap
# plt.show()



fig, ax = plt.subplots(figsize=(10, 8))
data_db5b54e = np.array(puf_db5b54e[0]).reshape((16, 16))

heatmap = plt.imshow(data_db5b54e, cmap='viridis', interpolation='nearest')
plt.colorbar(heatmap)
plt.xlabel('ROs',fontsize= 22.5)
plt.ylabel('ROs',fontsize= 22.5)
fig.savefig('/home/douadiag/Bureau/HeatMap_db5b54e.pdf', dpi=300)
# Afficher la heatmap
# plt.show()




fig, ax = plt.subplots(figsize=(10, 8))
data_db5b52a = np.array(puf_db5b52a[0]).reshape((16, 16))

heatmap = plt.imshow(data_db5b52a, cmap='viridis', interpolation='nearest')
plt.colorbar(heatmap)
plt.xlabel('ROs',fontsize= 22.5)
plt.ylabel('ROs',fontsize= 22.5)
fig.savefig('/home/douadiag/Bureau/HeatMap_db5b52a.pdf', dpi=300)
# Afficher la heatmap
# plt.show()



fig, ax = plt.subplots(figsize=(10, 8))
data_Carte_temoin = np.array(puf_Carte_temoin[0]).reshape((16, 16))

heatmap = plt.imshow(data_Carte_temoin, cmap='viridis', interpolation='nearest')
plt.colorbar(heatmap)
plt.xlabel('ROs',fontsize= 22.5)
plt.ylabel('ROs',fontsize= 22.5)
fig.savefig('/home/douadiag/Bureau/HeatMap_Carte_temoin.pdf', dpi=300)
# Afficher la heatmap
# plt.show()

#####################################################################################################################################
Tout_les_PUF = [puf_db5b8e1[0],puf_dbdb4fa[0],puf_db5b8d0[0],puf_db5b7b5[0],puf_db5b54e[0],puf_db5b52a[0],puf_Carte_temoin[0]]

uniquness = []
for i in range(len(Tout_les_PUF)):
    for j in range(i + 1, len(Tout_les_PUF)):
        a = 0
        for o in range(256) :
            if Tout_les_PUF[i][o] != Tout_les_PUF[j][o]:
                a= a +1
        uniquness.append(a)
    
print("mon uniquness est ", uniquness)
print("mon uniquness moyenne est ", sum(uniquness)/len(uniquness))

uniformity = []
for i in Tout_les_PUF :
    uniformity.append(np.mean(i))

print("mon uniformity est ", uniformity)
print("mon uniformity moyenne est ", sum(uniformity)/len(uniformity))
####################################################################################################################


fig, ax = plt.subplots(figsize=(10, 8))
plt.bar(range(len(uniquness)), uniquness, color='skyblue')
plt.xlabel('ROs',fontsize= 22.5)
plt.ylabel('ROs',fontsize= 22.5)
fig.savefig('/home/douadiag/Bureau/uniquness.pdf', dpi=300)
# Afficher la heatmap
# plt.show()


####################################################################################################################

counter_mux1_db5b8e1 = db5b8e1[:,1]
counter_mux2_db5b8e1 = db5b8e1[:,2]

counter_mux1_dbdb4fa = dbdb4fa[:,1]
counter_mux2_dbdb4fa = dbdb4fa[:,2]

counter_mux1_db5b8d0 = db5b8d0[:,1]
counter_mux2_db5b8d0 = db5b8d0[:,2]

counter_mux1_db5b7b5 = db5b7b5[:,1]
counter_mux2_db5b7b5 = db5b7b5[:,2]



count_db5b8e1_mux1= [counter_mux1_db5b8e1[idx: idx + 256] for idx in range(0, len(counter_mux1_db5b8e1), 256)]
count_db5b8e1_mux2= [counter_mux2_db5b8e1[idx: idx + 256] for idx in range(0, len(counter_mux2_db5b8e1), 256)]


count_dbdb4fa_mux1= [counter_mux1_dbdb4fa[idx: idx + 256] for idx in range(0, len(counter_mux1_dbdb4fa), 256)]
count_dbdb4fa_mux2= [counter_mux2_dbdb4fa[idx: idx + 256] for idx in range(0, len(counter_mux2_dbdb4fa), 256)]


count_db5b8d0_mux1= [counter_mux1_db5b8d0[idx: idx + 256] for idx in range(0, len(counter_mux1_db5b8d0), 256)]
count_db5b8d0_mux2= [counter_mux2_db5b8d0[idx: idx + 256] for idx in range(0, len(counter_mux2_db5b8d0), 256)]

count_db5b7b5_mux1= [counter_mux1_db5b7b5[idx: idx + 256] for idx in range(0, len(counter_mux1_db5b7b5), 256)]
count_db5b7b5_mux2= [counter_mux2_db5b7b5[idx: idx + 256] for idx in range(0, len(counter_mux2_db5b7b5), 256)]



#print(type(count_db5b8e1_mux1[0]))

# Aplatir la liste de listes

data = np.concatenate((count_db5b8e1_mux1[0], count_db5b8e1_mux2[0]))

# print(data)

# Afficher l'histogramme
plt.hist(data, bins=50, color='blue', alpha=0.7)
plt.title('Histogramme des données concaténées')
plt.xlabel('Valeurs')
plt.ylabel('Fréquence')
plt.grid(True)
# plt.show()



####################################################################################################################

ro= []
for i in range(256) :
    ro.append(i)


data = count_db5b8e1_mux1[0]- count_db5b8e1_mux2[0]

data_filitres_mhz = [valeur / 10000 for valeur in data]


fig, ax = plt.subplots(figsize=(10, 8))
plt.scatter(ro, data_filitres_mhz, color='blue', alpha=0.5, marker='o')
plt.xlabel('Bits', fontsize=22.5)
plt.ylabel('Δ F (Mhz)', fontsize=22.5)
plt.ylim(-30, 30)
plt.yticks(fontsize=17)
plt.xticks(fontsize=17)
plt.grid(True, which='both', linestyle='--', linewidth=0.5, color='gray', alpha=0.7)
plt.tick_params(axis='both', direction='in', which='both')
ax.ticklabel_format(axis='y', style='sci', scilimits=(-3,3))

plt.grid(True)
# plt.show()
fig.savefig('/home/douadiag/Bureau/delta_f_avant_filtrage.pdf', dpi=300)

####################################################################################################################

fig, ax = plt.subplots(figsize=(10, 8))
ax.hist(data_filitres_mhz, bins=50, color='blue', alpha=0.7)
ax.set_xlabel('Δ F (Mhz)', fontsize=22.5)
ax.set_ylabel('Occurrences', fontsize=22.5)
ax.tick_params(axis='both', which='major', labelsize=17)
ax.grid(True, which='both', linestyle='--', linewidth=0.5, color='gray', alpha=0.7)
ax.ticklabel_format(axis='y', style='sci', scilimits=(-3,3))
# plt.show()
fig.savefig('/home/douadiag/Bureau/delta_f_avant_filtrage_hist.pdf', dpi=300)





####################################################################################################################
sous = count_db5b8e1_mux1[0]- count_db5b8e1_mux2[0]
sous1 = sous.tolist()
donee_filitres = []

indexe = []  # Liste pour stocker les index
abs_data = np.abs(sous1)  # Calculer les valeurs absolues de sous
abs_data = abs_data.tolist()
# print(type(abs_data))

# Parcourir les valeurs absolues et ajouter les index à la liste si la valeur absolue est inférieure à 100000
for i in range(len(sous1)):
    if abs_data[i] < 50000:
        indexe.append(i)


# print(indexe)
ro1= []
for i in range(len(indexe)) :
    ro1.append(i)

for i in indexe :
    donee_filitres.append(sous1[i])  

donee_filitres_mhz = [valeur / 10000 for valeur in donee_filitres]


fig, ax = plt.subplots(figsize=(10, 8))
plt.scatter(ro1, donee_filitres_mhz, color='blue', alpha=0.5, marker='o')
plt.xlabel('Bits', fontsize=22.5)
plt.ylabel('Δ F (Mhz)', fontsize=22.5)
plt.ylim(-30, 30)
plt.yticks(fontsize=17)
plt.xticks(fontsize=17)
plt.grid(True, which='both', linestyle='--', linewidth=0.5, color='gray', alpha=0.7)
plt.tick_params(axis='both', direction='in', which='both')
ax.ticklabel_format(axis='y', style='sci', scilimits=(-3,3))
plt.grid(True)
# plt.show()
fig.savefig('/home/douadiag/Bureau/delta_f_apres_filtrage.pdf', dpi=300)
#####################################################################################################################################################################
fig, ax = plt.subplots(figsize=(10, 8))
ax.hist(donee_filitres_mhz, bins=50, color='blue', alpha=0.7)
ax.set_xlabel('Δ F (Mhz)', fontsize=22.5)
ax.set_ylabel('Occurrences', fontsize=22.5)
ax.tick_params(axis='both', which='major', labelsize=17)
ax.grid(True, which='both', linestyle='--', linewidth=0.5, color='gray', alpha=0.7)
ax.ticklabel_format(axis='y', style='sci', scilimits=(-3,3))
# plt.show()
fig.savefig('/home/douadiag/Bureau/delta_f_aprés_filtrage_hist.pdf', dpi=300)


######################################################################################################################################################################################################
######################################################################################################################################################################################################
######################################################################################################################################################################################################
puf_db5b8e1_filtre= []
puf_dbdb4fa_filtre= []
puf_db5b8d0_filtre= []
puf_db5b7b5_filtre= []
puf_db5b54e_filtre= []
puf_db5b52a_filtre= []
puf_Carte_temoin_filtre= []

for i in indexe :
    puf_db5b8e1_filtre.append(puf_db5b8e1[0][i])
    puf_dbdb4fa_filtre.append(puf_dbdb4fa[0][i])
    puf_db5b8d0_filtre.append(puf_db5b8d0[0][i])
    puf_db5b7b5_filtre.append(puf_db5b7b5[0][i])
    puf_db5b54e_filtre.append(puf_db5b54e[0][i])
    puf_db5b52a_filtre.append(puf_db5b52a[0][i])
    puf_Carte_temoin_filtre.append(puf_Carte_temoin[0][i])



#####################################################################################################################################



#####################################################################################################################################
Tout_les_PUF_filtre = [puf_db5b8e1_filtre,puf_dbdb4fa_filtre,puf_db5b8d0_filtre,puf_db5b7b5_filtre,puf_db5b54e_filtre,puf_db5b52a_filtre,puf_Carte_temoin_filtre]

uniquness_filtre = []
for i in range(len(Tout_les_PUF_filtre)):
    for j in range(i + 1, len(Tout_les_PUF_filtre)):
        a = 0
        for o in range(len(puf_db5b8e1_filtre)) :
            if Tout_les_PUF_filtre[i][o] != Tout_les_PUF_filtre[j][o]:
                a= a +1
        uniquness_filtre.append(a)
    
print("mon uniquness est ", uniquness_filtre)
print("mon uniquness moyenne est ", sum(uniquness_filtre)/len(uniquness_filtre))

uniformity_filtre = []
for i in Tout_les_PUF_filtre :
    uniformity_filtre.append(np.mean(i))

print("mon uniformity est ", uniformity_filtre)
print("mon uniformity moyenne est ", sum(uniformity_filtre)/len(uniformity_filtre))

####################################################################################################################


array1 = np.array(puf_db5b8e1_filtre, dtype=int)
array2 = np.array(puf_dbdb4fa_filtre, dtype=int)

# Effectuer XOR entre les deux tableaux numpy
resultat_xor = np.bitwise_xor(array1, array2)

# print(np.mean(resultat_xor))



####################################################################################################################

uniquness_pourcentage = []
for j in uniquness_filtre:
    uniquness_pourcentage.append(j / len(puf_db5b8e1_filtre))

# Tracé de l'histogramme
fig, ax = plt.subplots(figsize=(10, 8))
plt.hist(uniquness_pourcentage, bins=10, density=True, color='red', alpha=0.7)  # Utilisation de density=True pour obtenir une densité

# Ajout de la courbe de densité gaussienne
mu, std = norm.fit(uniquness_pourcentage)
xmin, xmax = plt.xlim()
x = np.linspace(xmin, xmax, 100)
p = norm.pdf(x, mu, std)
plt.plot(x, p, 'k', linewidth=2)  # 'k' pour une ligne noire, vous pouvez ajuster la couleur si nécessaire

# Ajout de titres et d'étiquettes
plt.xlabel('Hamming Distance', fontsize=22.5)
plt.ylabel('Occurrences', fontsize=22.5)

# Limite de l'axe x
plt.xlim((0, 0.7))

# Sauvegarde de la figure
fig.savefig('/home/douadiag/Bureau/Hamming_Disctance.pdf', dpi=300)

# Affichage du graphique
# plt.show()


####################################################################################################################
####################################################################################################################

#####################################################################################################################################
les_PUF_avant = [puf_db5b8e1[0],puf_dbdb4fa[0],puf_db5b8d0[0],puf_db5b7b5[0],puf_db5b54e[0],puf_db5b52a[0],puf_Carte_temoin[0]]

aliasing_avant = []

for j in range(len(puf_db5b8e1[0])) :
    for i in les_PUF_avant  :
     aliasing_avant.append(i[j])
  

a2= [aliasing_avant[idx: idx + 7] for idx in range(0, len(aliasing_avant), 7)]
#print(len(a2))

bit_aliasing_avant = []
for i in range(256) :
   bit_aliasing_avant.append(np.mean(a2[i]))
#print(bit_aliasing_avant)

fig, ax = plt.subplots(figsize=(10, 8))
ax.hist(bit_aliasing_avant, bins=20, color='blue', alpha=0.7)
ax.set_xlabel('Probability', fontsize=22.5)
ax.set_ylabel('Occurrences', fontsize=22.5)
ax.tick_params(axis='both', which='major', labelsize=17)
ax.grid(True, which='both', linestyle='--', linewidth=0.5, color='gray', alpha=0.7)
ax.ticklabel_format(axis='y', style='sci', scilimits=(-3,3))
plt.xlim(-1,2)
# plt.show()
fig.savefig('/home/douadiag/Bureau/bit_aliasing__avant_filtrage_hist.pdf', dpi=300)





les_PUF_apres = [puf_db5b8e1_filtre,puf_dbdb4fa_filtre,puf_db5b8d0_filtre,puf_db5b7b5_filtre,puf_db5b54e_filtre,puf_db5b52a_filtre,puf_Carte_temoin_filtre]
aliasing_apres = []
for j in range(len(puf_db5b8e1_filtre)) :
    for i in les_PUF_apres   :
     aliasing_apres.append(i[j])
  
#print(len(aliasing_apres))
a3= [aliasing_apres[idx: idx + 7] for idx in range(0, len(aliasing_apres), 7)]
#print(len(a2))
bit_aliasing_apres = []
for i in range(len(indexe)) :
   bit_aliasing_apres.append(np.mean(a3[i]))
#print(bit_aliasing_apres)


fig, ax = plt.subplots(figsize=(10, 8))
ax.hist(bit_aliasing_apres, bins=20, color='blue', alpha=0.7)
ax.set_xlabel('Probability', fontsize=22.5)
ax.set_ylabel('Occurrences', fontsize=22.5)
ax.tick_params(axis='both', which='major', labelsize=17)
ax.grid(True, which='both', linestyle='--', linewidth=0.5, color='gray', alpha=0.7)
ax.ticklabel_format(axis='y', style='sci', scilimits=(-3,3))
plt.xlim(-1,2)
# plt.show()
fig.savefig('/home/douadiag/Bureau/bit_aliasing_aprés_filtrage_hist.pdf', dpi=300)

####################################################################################################################################
#print( count_db5b8e1_mux1[0])

liste_counter_mux1_db5b8e1 = [int(nombre) for nombre in count_db5b8e1_mux1[0]]
liste_counter_mux2_db5b8e1 = [int(nombre) for nombre in count_db5b8e1_mux2[0]]

#print(len(liste_counter_mux1_db5b8e1))
frequences = []
for i in range(len(liste_counter_mux1_db5b8e1)) :
    frequences.append(liste_counter_mux1_db5b8e1[i])
    frequences.append(liste_counter_mux2_db5b8e1[i])

####################################################################################################################################
"""
db5b8e1 = np.loadtxt ('db5b8e1.csv', delimiter=',')
dbdb4fa = np.loadtxt ('dbdb4fa.csv', delimiter=',')
db5b8d0 = np.loadtxt ('db5b8d0.csv', delimiter=',')
db5b7b5 = np.loadtxt ('db5b7b5.csv', delimiter=',')
db5b54e = np.loadtxt ('db5b54e.csv', delimiter=',')
db5b52a = np.loadtxt ('db5b52a.csv', delimiter=',')



result = []

    # Parcourir les deux listes simultanément
for i in range(len(puf_db5b8e1[0])):
    if puf_db5b54e[0][i] != puf_db5b52a[0][i]:
        result.append(1)
    else:
        result.append(0)
"""

print("dfdfd ", len(frequences))

from matplotlib.colors import ListedColormap
deltaf_ropuf = [frequences[idx: idx + 24] for idx in range(0, len(frequences), 48)]
print(deltaf_ropuf[0])
# Remplir les sous-listes plus courtes avec des valeurs manquantes
max_length = max(len(sublist) for sublist in deltaf_ropuf)
filled_deltaf_ropuf = [sublist + [2000000] * (max_length - len(sublist)) for sublist in deltaf_ropuf]



filled_deltaf_ropuf = np.array(filled_deltaf_ropuf).T

deltaf_ropuf = [frequences[idx: idx + 48] for idx in range(0, len(frequences), 48)]
print(deltaf_ropuf[0])
max_length = max(len(sublist) for sublist in deltaf_ropuf)
filled_deltaf_ropuf = [sublist + [2000000] * (max_length - len(sublist)) for sublist in deltaf_ropuf]
filled_deltaf_ropuf = np.array(filled_deltaf_ropuf).T
fig, ax = plt.subplots(figsize=(10, 8))

# Supposons que filled_deltaf_ropuf est votre matrice de données à afficher

plt.imshow(filled_deltaf_ropuf, cmap='plasma', aspect='auto', interpolation='nearest')
plt.colorbar()
# Définition des étiquettes des axes
plt.yticks(np.arange(48), np.arange(1, 49))  # 12 carrés sur l'axe Y représentant chaque valeur de la sous-liste
plt.xticks(np.arange(11), np.arange(1, 12))  # 22 sous-listes au total sur l'axe X

plt.xlabel('X-coordinates', fontsize=22.5)
plt.ylabel('Y-coordinates', fontsize=22.5)

# Sauvegarde de la figure au format PDF
plt.savefig('/home/douadiag/Bureau/bit_aliasing_avant_coordonées.pdf', dpi=300)

plt.show()


####################################################################################################################################
"""
datadb5b8d0 = count_db5b8d0_mux1[0]- count_db5b8d0_mux2[0]

data_filitres_mhzdb5b8d0 = [valeur / 10000 for valeur in datadb5b8d0]

deltaf_ropufdb5b8d0 = [data_filitres_mhzdb5b8d0[idx: idx + 24] for idx in range(0, len(data_filitres_mhzdb5b8d0), 24)]


# Remplir les sous-listes plus courtes avec des valeurs manquantes
max_lengthdb5b8d0 = max(len(sublist) for sublist in deltaf_ropufdb5b8d0)
filled_deltaf_ropufdb5b8d0 = [sublist + [0] * (max_lengthdb5b8d0 - len(sublist)) for sublist in deltaf_ropufdb5b8d0]

# Transposer pour avoir le bon arrangement des données
filled_deltaf_ropufdb5b8d0 = np.array(filled_deltaf_ropufdb5b8d0).T
fig, ax = plt.subplots(figsize=(10, 8))
# Création de la heatmap
plt.imshow(filled_deltaf_ropufdb5b8d0, cmap='viridis', aspect='auto', interpolation='nearest')

# Définition des étiquettes des axes
plt.yticks(np.arange(24), np.arange(1, 25))  # 12 carrés sur l'axe Y représentant chaque valeur de la sous-liste
plt.xticks(np.arange(11), np.arange(1, 12))  # 22 sous-listes au total sur l'axe X

plt.colorbar(label='Δ F (Mhz)')
plt.xlabel('X-coordinates', fontsize=22.5)
plt.ylabel('Y-coordinates', fontsize=22.5)
fig.savefig('/home/douadiag/Bureau/freq_cartesdb5b8d0uuuuu.pdf', dpi=300)
plt.show()


####################################################################################################################################
####################################################################################################################################

deltaf_ropuf = [data_filitres_mhz[idx: idx + 24] for idx in range(0, len(data_filitres_mhz), 24)]


# Remplir les sous-listes plus courtes avec des valeurs manquantes
max_length = max(len(sublist) for sublist in deltaf_ropuf)
filled_deltaf_ropuf = [sublist + [0] * (max_length - len(sublist)) for sublist in deltaf_ropuf]

# Transposer pour avoir le bon arrangement des données
filled_deltaf_ropuf = np.array(filled_deltaf_ropuf).T
fig, ax = plt.subplots(figsize=(10, 8))
# Création de la heatmap

plt.imshow(filled_deltaf_ropuf, cmap='viridis', aspect='auto', interpolation='nearest')

# Définition des étiquettes des axes
plt.yticks(np.arange(24), np.arange(1, 25))  # 12 carrés sur l'axe Y représentant chaque valeur de la sous-liste
plt.xticks(np.arange(11), np.arange(1, 12))  # 22 sous-listes au total sur l'axe X

plt.colorbar(label='Δ F (Mhz)')
plt.xlabel('X-coordinates', fontsize=22.5)
plt.ylabel('Y-coordinates', fontsize=22.5)
fig.savefig('/home/douadiag/Bureau/freq_cartes.pdf', dpi=300)
plt.show()

"""






indicess = [ ]
for j in range(len(data_filitres_mhz)) :
    if abs(data_filitres_mhz[j]) > 5 : indicess.append(j)

print("ererzerezrzerezrzeez",indicess)
print(len(indicess))




print("bit aliasin",np.mean(bit_aliasing_avant))
print("bit aliasin",np.mean(bit_aliasing_apres))



#################################################################################""
#################################################################################""

temp_tension = np.loadtxt ('temp_tension.csv', delimiter=',')

fig, ax = plt.subplots(figsize=(10, 8))
plt.plot(temp_tension[:,0], temp_tension[:,2], color='blue')
plt.xlabel('Time (s)', fontsize=22.5)
plt.ylabel('Supply Voltage (V)', fontsize=22.5)
plt.ylim(0.95, 1.05)
ax.axvspan(temp_tension[:,0][0], temp_tension[:,0][30], facecolor='lightblue', alpha=0.5, label='RO-PUF OFF')
# Ajouter une zone colorée pour la deuxième partie
ax.axvspan(temp_tension[:,0][25], temp_tension[:,0][860], facecolor='lightcoral', alpha=0.5, label='RO-PUF ON')
ax.axvspan(temp_tension[:,0][860], temp_tension[:,0][1426], facecolor='lightblue', alpha=0.5, label='RO-PUF OFF')
ax.legend(loc='upper right', fontsize=17)

plt.yticks(fontsize=17)
plt.xticks(fontsize=17)
plt.grid(True, which='both', linestyle='--', linewidth=0.5, color='gray', alpha=0.7)
plt.tick_params(axis='both', direction='in', which='both')
ax.ticklabel_format(axis='y', style='sci', scilimits=(-3,3))
plt.grid(True)
plt.show()
fig.savefig('/home/douadiag/Bureau/supply_voltage.pdf', dpi=300)








fig, ax = plt.subplots(figsize=(10, 8))
plt.plot(temp_tension[:,0], temp_tension[:,1], color='blue')
plt.xlabel('Time (s)', fontsize=22.5)
plt.ylabel('Temperature (°C)', fontsize=22.5)
plt.ylim(40, 50)
ax.axvspan(temp_tension[:,0][0], temp_tension[:,0][30], facecolor='lightblue', alpha=0.5, label='RO-PUF OFF')
# Ajouter une zone colorée pour la deuxième partie
ax.axvspan(temp_tension[:,0][25], temp_tension[:,0][860], facecolor='lightcoral', alpha=0.5, label='RO-PUF ON')
ax.axvspan(temp_tension[:,0][860], temp_tension[:,0][1426], facecolor='lightblue', alpha=0.5, label='RO-PUF OFF')
ax.legend(loc='upper right', fontsize=17)

plt.yticks(fontsize=17)
plt.xticks(fontsize=17)
plt.grid(True, which='both', linestyle='--', linewidth=0.5, color='gray', alpha=0.7)
plt.tick_params(axis='both', direction='in', which='both')
ax.ticklabel_format(axis='y', style='sci', scilimits=(-3,3))
plt.grid(True)
plt.show()
fig.savefig('/home/douadiag/Bureau/temperature.pdf', dpi=300)

