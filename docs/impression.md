# Impression 3D — v1 sur FlashForge Dreamer, avec Cura

Imprimante : **FlashForge Dreamer** (2 têtes, plateau chauffant, volume 230 × 150 × 140 mm, buse 0,4 mm, filament 1,75 mm).
Logiciel : **Ultimaker Cura** (celui de ton beau-père) — ou FlashPrint en secours. Matière : **PLA**.

Les fichiers sont dans **`cad/print/`**. Ils sont **déjà tournés dans le bon sens et posés à plat** : il suffit de les ouvrir.

## Les fichiers

| Fichier | Contenu | Couleur conseillée | Durée estimée* |
|---|---|---|---|
| `PLATEAU_1_coque.stl` | la coque | blanc / crème / pastel | ~6 h |
| `PLATEAU_2_chassis_roues_capots.stl` | plancher + 4 roues + 3 capots moteurs + 3 patins arrière (2 normaux + 1 « pour feutre ») | n'importe laquelle | ~4 h 45 |
| `PLATEAU_3_facades_noir.stl` | 2 façades | **noir** | ~25 min |

\* estimation ; Cura donne la durée exacte après le découpage. Total ≈ 95 g de PLA.
Les pièces existent aussi une par une (`1_coque.stl`, `2_chassis.stl`, `3_facade_x2.stl`, `4_roue_x4.stl`, `5_capot_moteur_x3.stl`, `6_patin_arriere_x2.stl`, `6b_patin_pour_feutre_2mm.stl`).
Les roues, capots et patins sont en plusieurs exemplaires : ce sont des rechanges.
Le patin **« pour feutre »** est 2 mm plus bas : il sert si tu colles plus tard une pastille de feutre de 2 mm dessous
(robot plus silencieux, ne raye pas le bureau). Sans feutre, utilise le patin normal.

## Avant tout : une roue de test (15 min)
Imprime **une seule roue** (`4_roue_x4.stl`) avec les réglages ci-dessous. Quand les pièces seront arrivées :
elle doit s'emmancher **en forçant un peu** sur l'axe du moteur, et les joints toriques 25 × 2,5 doivent tenir dans leurs gorges.
Si c'est trop serré, foret de 3 mm à la main ; si c'est trop lâche, dis-le-moi, je corrige le trou.
Si tu n'as l'imprimante qu'une fois, saute ce test : le trou est prévu serré, il se rattrape au foret.

## Pas à pas dans Ultimaker Cura (Cura 5, interface en français)

### 0. Vérifier l'imprimante dans Cura (une seule fois)
1. En haut à gauche, cliquer sur le nom de l'imprimante : choisir **celle que ton beau-père utilise déjà pour sa Dreamer**
   (ne pas en créer une nouvelle : son profil sait déjà parler à la machine).
2. *Préférences → Configurer Cura → Imprimantes → Paramètres de la machine* : vérifier **X 230 mm, Y 150 mm, Z 140 mm**,
   buse **0,4 mm**, filament **1,75 mm**. Sinon le plateau 2 (203 mm de large) apparaîtra grisé = « ne rentre pas ».
3. Regarder **quel type de fichier** il met d'habitude sur la carte SD (`.x3g`, `.g` ou `.gcode`) : on enregistrera pareil.
   - Si c'est `.x3g` : Cura a besoin du module **X3GWriter** (*Marketplace* en haut à droite → chercher « X3G » → Installer →
     redémarrer Cura). Normalement il l'a déjà.
   - **Si son Cura n'a pas de profil Dreamer qui marche déjà**, ne pas bricoler : utiliser FlashPrint (gratuit, fait pour la
     Dreamer), voir la section suivante.

### 1. Charger un plateau
*Fichier → Ouvrir* → `PLATEAU_1_coque.stl` (puis le 2, puis le 3, un par impression). Les pièces sont déjà à plat et bien orientées :
**ne pas les tourner**. Si Cura propose de les redimensionner, refuser (taille 100 %).

### 2. Réglages
En haut à droite, cliquer sur le panneau des réglages → **Personnalisé**, puis taper chaque nom dans la barre de recherche :

| Réglage Cura (recherche) | Valeur |
|---|---|
| Extrudeuse (si 2 têtes) | celle qui a le bon filament (noir pour le plateau 3) |
| Matériau | PLA |
| Hauteur de la couche | **0,2 mm** |
| Hauteur de la couche initiale | **0,27 mm** |
| Nombre de lignes de la paroi | **3** |
| Couches supérieures / Couches inférieures | **4 / 3** |
| Densité du remplissage | **20 %** |
| Motif de remplissage | **Gyroïde** (ou Cubique) |
| Température d'impression | **210 °C** |
| Température du plateau | **50 °C** |
| Vitesse d'impression | **50 mm/s** |
| Vitesse de la paroi externe | **30 mm/s** (plus joli) |
| Vitesse de déplacement | **80 mm/s** |
| Activer le refroidissement de l'impression | **coché** (ventilateur 100 %, 0 % sur la 1re couche : réglage par défaut) |
| Générer les supports | **coché** pour les plateaux 1 et 2 · **décoché** pour le 3 |
| Structure du support | **Arborescent** |
| Placement du support | **Partout** (les étagères du plancher ont besoin de supports posés sur le plancher) |
| Angle de porte-à-faux du support | **45°** |
| Type d'adhérence du plateau | **Bordure** pour les plateaux 1 et 2 · **Jupe** pour le 3 |

### 3. Découper et enregistrer
1. Bouton **Découper** en bas à droite → Cura affiche la durée et le poids.
2. Onglet **Aperçu** (en haut) : faire glisser le curseur des couches pour vérifier que des supports (en bleu clair) sont
   bien **sous le plafond de la coque** et **sous les étagères du plancher**.
3. **Enregistrer sur un disque amovible** (la carte SD), au même format que d'habitude, et la mettre dans l'imprimante.

### 4. Sur la Dreamer
- **Retirer le couvercle du dessus** (pour le PLA, l'enceinte fermée chauffe trop et déforme les pièces).
- Rester devant la **1re couche** (≈ 5 min) : si elle colle bien et que les lignes s'écrasent un peu, tout le reste suit.

## Variante : avec FlashPrint (si Cura ne marche pas avec la Dreamer)
FlashPrint est le logiciel gratuit de FlashForge, fait pour cette machine.
1. *Imprimer → Type de machine* → **Dreamer**. *Charger* le plateau.
2. *Supports → Options* : **Arborescent**, angle **45°**, puis *Support automatique* (plateaux 1 et 2 seulement).
3. *Imprimer* → *Paramètres avancés* : mêmes valeurs que le tableau Cura (couche 0,2 / 1re 0,27, 3 périmètres, 4/3 couches
   pleines, 20 %, 210 °C / 50 °C, 50 mm/s, bordure plateaux 1-2, pas de radeau).
4. Enregistrer le **.x3g** sur la carte SD.

## Après impression
- Retirer les supports (pince + cutter), surtout sous les étagères du plancher et dans le plafond de la coque.
- Vérifier que les 4 colonnes de vis de la coque et les trous des capots ne sont pas bouchés.
- La façade se met **par l'intérieur** de la coque : elle tient par son rebord, un point de colle si besoin.
