# Guide d'impression 3D — v1

Tout est dans `cad/stl/`. Matière : **PLA**. Tout tient sur n'importe quel plateau (plus grande pièce : 86 × 92 × 87 mm).

## Ce qu'il faut imprimer
| Fichier | Quantité | Couleur conseillée | Orientation sur le plateau | Supports |
|---|---|---|---|---|
| `shell.stl` (coque) | 1 | blanc / crème / pastel | ouverture du bas **contre le plateau** | **oui**, arborescents (« tree »), uniquement pour le plafond intérieur |
| `chassis.stl` (plancher) | 1 | n'importe laquelle (caché) | plancher **contre le plateau** | **oui**, arborescents (étagères intérieures) |
| `faceplate.stl` (façade) | **2** (1 de rechange) | **noir** | face avant **contre le plateau** | non |
| `wheel.stl` (roue) | **4** (2 de rechange) | n'importe laquelle | à plat | non |

Prévois **2 plateaux** si besoin : (1) coque seule ; (2) châssis + façades + roues.

## Réglages
- Hauteur de couche **0,2 mm**
- **3 parois** (périmètres), remplissage **15–20 %**
- Bordure (*brim*) de 5 mm pour la coque si l'imprimante a tendance à décoller les coins
- Durée estimée : ~5 h pour la coque, ~4 h pour le reste ; ~85 g de PLA au total

## Après impression
- Retirer les supports à l'intérieur de la coque (pince + cutter).
- **Roues** : enfiler 2 joints toriques OD30 × 2,4 mm par roue dans les gorges, puis emmancher la roue sur l'axe du moteur (serré exprès ; si c'est trop dur, passer un foret de 3 mm dans le trou).
- Les petites cartes (chargeur, driver, régulateur, capteurs anti-chute, capteur de caresse) se collent à l'**adhésif double face** dans leurs emplacements : ils sont volontairement plus larges que les cartes.
- La façade se clipse/colle dans l'ouverture du visage par l'intérieur ; l'écran glisse ensuite par le haut dans ses guides.
- La coque se visse sur le plancher avec **4 vis M2** par-dessous.
