# Impression 3D — v1 sur FlashForge Dreamer

Imprimante : **FlashForge Dreamer** (2 têtes, plateau chauffant, volume 230 × 150 × 140 mm, buse 0,4 mm, filament 1,75 mm).
Logiciel : **FlashPrint** (le logiciel gratuit de FlashForge). Matière : **PLA**.

Les fichiers sont dans **`cad/print/`**. Ils sont **déjà tournés dans le bon sens et posés à plat** : il suffit de les ouvrir.

## Les fichiers

| Fichier | Contenu | Couleur conseillée | Durée estimée* |
|---|---|---|---|
| `PLATEAU_1_coque.stl` | la coque | blanc / crème / pastel | ~6 h |
| `PLATEAU_2_chassis_roues_capots.stl` | plancher + 4 roues + 3 capots moteurs | n'importe laquelle | ~4 h 30 |
| `PLATEAU_3_facades_noir.stl` | 2 façades | **noir** | ~25 min |

\* estimation ; FlashPrint donne la durée exacte après le découpage. Total ≈ 95 g de PLA.
Les pièces existent aussi une par une (`1_coque.stl`, `2_chassis.stl`, `3_facade_x2.stl`, `4_roue_x4.stl`, `5_capot_moteur_x3.stl`).
Les roues et capots sont en double / triple : ce sont des rechanges.

## Avant tout : une roue de test (15 min)
Imprime **une seule roue** (`4_roue_x4.stl`) avec les réglages ci-dessous. Quand les pièces seront arrivées :
elle doit s'emmancher **en forçant un peu** sur l'axe du moteur, et le joint torique doit tenir dans sa gorge.
Si c'est trop serré, foret de 3 mm à la main ; si c'est trop lâche, dis-le-moi, je corrige le trou.
Si tu n'as l'imprimante qu'une fois, saute ce test : le trou est prévu serré, il se rattrape au foret.

## Pas à pas dans FlashPrint
1. **Imprimante** : menu *Imprimer → Type de machine* → **Dreamer**.
2. **Charger** le fichier (*Charger*), puis *Placer sur plateau* (le fichier est déjà au bon endroit).
3. **Supports** (plateaux 1 et 2) : *Supports → Options* : type **Arborescent (Treelike)**, angle **45°**,
   puis *Support automatique*. Pour la coque, les supports partent tous du plateau (intérieur du plafond et des guides de l'écran).
   Plateau 3 : pas de supports.
4. **Imprimer** → cocher *Paramètres avancés*, puis régler :

| Réglage FlashPrint | Valeur |
|---|---|
| Extrudeur | droit (ou gauche s'il a le noir pour les façades) |
| Matériau | PLA |
| Hauteur de couche | **0,2 mm** (1re couche 0,27 mm) |
| Coques / périmètres | **3** |
| Couches pleines dessus / dessous | **4 / 3** |
| Remplissage | **20 %**, motif hexagone (nid d'abeille) |
| Vitesse d'impression | **50 mm/s** (périmètres 40 mm/s) |
| Vitesse de déplacement | 80 mm/s |
| Température extrudeur | **210 °C** |
| Température plateau | **50 °C** |
| Ventilateur | activé (sauf 1re couche) |
| Radeau (raft) | **non** |
| Bordure (brim) | **oui** pour les plateaux 1 et 2, non pour le 3 |

5. *OK* → FlashPrint découpe et affiche la durée → enregistrer le fichier **.x3g** sur la carte SD → l'imprimante.
6. **Enceinte** : pour le PLA, **retirer le couvercle du dessus** de la Dreamer (sinon il fait trop chaud et le PLA se déforme).

## Après impression
- Retirer les supports (pince + cutter), surtout sous les étagères du plancher et dans le plafond de la coque.
- Vérifier que les 4 colonnes de vis de la coque et les trous des capots ne sont pas bouchés.
- La façade se met **par l'intérieur** de la coque : elle tient par son rebord, un point de colle si besoin.
