# Impression 3D — v1 sur FlashForge Dreamer, avec FlashPrint 5

**Le principe** : tu prépares les fichiers sur **ton PC** avec **FlashPrint 5** (le logiciel officiel et gratuit de
FlashForge), puis tu envoies à ton beau-père **3 fichiers `.gx` prêts à imprimer**. Lui n'a qu'à les mettre sur la carte SD.

Imprimante : **FlashForge Dreamer** (2 têtes, plateau chauffant, volume 230 × 150 × 140 mm, buse 0,4 mm, filament 1,75 mm).
Matière : **PLA**, une bobine **blanche** et une bobine **rose** (une sur chaque tête).

---

## 1. Les 3 plateaux et leurs couleurs

Chaque plateau s'imprime **d'une seule couleur** : pas besoin d'impression bicolore.

| Fichier (dossier `cad/print/`) | Contenu | Couleur | Durée* |
|---|---|---|---|
| `PLATEAU_1_coque.stl` | la coque | **blanc** | ~6 h |
| `PLATEAU_2_chassis_roues_capots.stl` | plancher + 4 roues + 3 capots moteurs + 3 patins | **rose** | ~4 h 45 |
| `PLATEAU_3_facades.stl` | 2 façades (le cadre autour de l'écran) | **rose** | ~25 min |

Résultat : un robot **blanc avec un visage rose et des roues roses**. L'écran reste noir derrière la façade, on ne voit que les yeux.
\* estimation ; FlashPrint donne la durée exacte.

On imprime **seulement les 3 fichiers `PLATEAU_…`**. Les autres fichiers (`1_coque`, `4_roue_x4`…) sont les mêmes pièces
une par une, pour réimprimer une pièce ratée. Les roues, capots et patins sont en plusieurs exemplaires : ce sont des rechanges.
Le patin « pour feutre » est 2 mm plus bas : il ne sert que si tu colles un jour un patin de feutre de 2 mm dessous.

---

## 2. Installer FlashPrint 5 (une seule fois, sur ton PC)
1. Site officiel **flashforge.com** → *Support* → *Download* (centre de téléchargement) → **FlashPrint 5**, dernière version,
   pour ton système (Windows / Mac). Installer.
2. Au premier lancement, choisir la langue **Français**, puis la machine **Dreamer** (pas « Dreamer NX » : la NX n'a qu'une tête).
   Plus tard : menu *Imprimer → Type de machine* pour changer.
3. Ton PC n'a pas besoin d'être relié à l'imprimante : on enregistre juste des fichiers.

> Les noms des menus peuvent varier un peu d'une version à l'autre de FlashPrint. Si tu ne trouves pas un réglage,
> envoie une capture d'écran.

---

## 3. Préparer un plateau (à refaire pour chacun des 3)

### a) Charger
*Fichier → Charger un fichier* (ou glisser le `.stl` dans la fenêtre) → `PLATEAU_1_coque.stl`.
Les pièces sont **déjà orientées et posées à plat : ne pas les tourner**. Si FlashPrint propose de redimensionner ou de
centrer, accepter de **centrer**, refuser de **redimensionner**.

### b) Choisir la tête (la couleur)
Clic droit sur le modèle → **Utiliser l'extrudeur gauche / droit** : celui où est la bonne couleur.
**Regarde sur la Dreamer quelle bobine est sur quelle tête** (vue de face : gauche / droite) et note-le :

| | Tête gauche | Tête droite |
|---|---|---|
| Couleur (à remplir) | ………… | ………… |

### c) Supports (plateaux 1 et 2 seulement)
1. Bouton **Supports** (barre d'outils à gauche) → **Paramètres** (ou *Options*) :
   - Type : **Arborescent** (treelike)
   - Angle critique (porte-à-faux) : **45°**
   - Extrudeur des supports : **le même que la pièce**
2. **Supports automatiques** → valider l'avertissement.
3. Vérifier en tournant la vue : des supports doivent apparaître **sous le plafond de la coque** (plateau 1) et
   **sous les étagères du plancher** (plateau 2). Les supports qui naissent sur le plancher lui-même, c'est normal.
4. Plateau 3 (façades) : **aucun support**.

### d) Réglages d'impression
Bouton **Imprimer** → cocher **Mode expert** (ou *Plus d'options*). Régler :

| Onglet | Réglage | Valeur |
|---|---|---|
| Général | Extrudeur droit / gauche | celui de la bonne couleur ; **l'autre : « aucun » / désactivé** |
| Général | Matériau | **PLA** |
| Général | Supports | **activés** pour les plateaux 1 et 2, désactivés pour le 3 |
| Général | Radeau (raft) | **non** |
| Général | Bordure (brim) | **oui** pour les plateaux 1 et 2, **non** pour le 3 |
| Général | Mur / mur d'essuyage (wall) | **non** (inutile en une seule couleur) |
| Couche | Hauteur de couche | **0,20 mm** |
| Couche | Hauteur de la première couche | **0,27 mm** |
| Coque | Nombre de périmètres (coques) | **3** |
| Coque | Couches pleines dessus / dessous | **4 / 3** |
| Remplissage | Densité | **20 %** |
| Remplissage | Motif | **Hexagone** (nid d'abeille) |
| Vitesse | Vitesse d'impression | **50 mm/s** |
| Vitesse | Vitesse de déplacement | **80 mm/s** |
| Température | Extrudeur | **215 °C** |
| Température | Plateau | **50 °C** |
| Autres | Refroidissement / ventilateur | **activé** (sauf 1re couche) |

Si FlashPrint propose d'**enregistrer ces réglages** comme profil, le faire (nom : « Robot PLA ») : les 2 plateaux suivants
seront plus rapides à préparer. Pense juste à changer **supports / bordure / tête** selon le tableau.

### e) Découper et enregistrer
1. **OK** → FlashPrint découpe, affiche la **durée** et le **poids** et montre l'aperçu couche par couche :
   faire glisser le curseur pour vérifier que les supports sont bien là.
2. Enregistrer le fichier **`.gx`** avec un nom clair :
   - `1_coque_BLANC.gx`
   - `2_plancher_roues_ROSE.gx`
   - `3_facades_ROSE.gx`

---

## 4. Ce que tu envoies à ton beau-père
Les **3 fichiers `.gx`** + ce petit mot :

> Un fichier = une impression, dans l'ordre que tu veux. La couleur est dans le nom du fichier.
> Avant chaque impression : retirer le **couvercle du dessus** (le PLA n'aime pas l'enceinte fermée), plateau propre.
> Regarder la **première couche** (5 min) : si elle colle bien, c'est parti. Brim et supports à enlever à la pince/cutter.

---

## 5. Après impression
- Retirer les supports (pince + cutter), surtout **sous les étagères du plancher** et **dans le plafond de la coque**.
- **Roues** : nettoyer les **deux gorges** (le cutter suffit) pour que les joints toriques s'y logent bien.
- Vérifier que les 4 colonnes de vis de la coque et les trous des capots ne sont pas bouchés (foret de 1,5 mm à la main sinon).
- La façade se met **par l'intérieur** de la coque : elle tient par son rebord, un point de colle si besoin.

## Roue de test (déjà faite le 24/10 ✅)
La roue imprimée passe les deux tests (taille et trou de l'axe) : pas de correction à faire.
