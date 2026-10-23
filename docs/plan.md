# Plan & cahier des charges — Robot Maman

_Mis à jour : 23/10/2026_

## Décisions prises
| Sujet | Décision |
|---|---|
| Approche | Design sur mesure (pièces 3D par Claude, impression par Cyril) |
| Deadline | Anniversaire dans plus d'un mois → on a le temps d'itérer |
| Budget composants | 20–40 € visé au départ → ≈ 55 € outils compris (version AliExpress, liens vérifiés) |
| Comportements v1 | Yeux animés sur écran · réagit au toucher · se déplace sur le bureau |
| Carte | **Arduino Nano R4** (voir justification) |

### Pourquoi la Nano R4
- Format Nano (petit robot compact).
- Officiellement supportée par le Simulink Support Package for Arduino.
- Logique **5 V** comme l'Uno → mêmes capteurs/modules que ton kit, pas de conversion de niveaux.
- **32 KB de RAM** : l'écran OLED a besoin d'un buffer de 1 KB ; la Nano classique (2 KB de RAM)
  serait à la limite avec Simulink en plus.
- Carte officielle → pas de problème de driver USB comme avec certains clones / l'ESP32-S3.

## Concept du robot (v1)
Petit corps arrondi (~8 × 8 × 7 cm), l'écran OLED fait office de visage avec deux yeux.
Deux petites roues motorisées + une bille folle. Un capteur tactile caché sous le dessus de la tête.
Deux capteurs IR (TCRT5000) pointés vers le bas à l'avant pour **ne jamais tomber du bureau**.
Batterie rechargeable en USB-C, interrupteur on/off.

### Machine à états (Stateflow) envisagée
```
SLEEP  --(toucher)-->  AWAKE  --(timer)-->  WANDER
  ^                      ^                    |
  |                      +--(toucher)-- HAPPY |  (yeux heureux, petite danse)
  +----------(inactivité longue)--------------+
WANDER : avance, tourne au hasard ; bord détecté -> recule + tourne
```

## Liste des pièces
Voir **`docs/bom.md`** (liens AliExpress + Amazon vérifiés, dimensions). Tout neuf, ≈ 55 € outils compris.

## Le point technique le plus dur (côté Simulink)
Il n'existe pas de bloc Simulink « OLED » prêt à l'emploi. Il faudra créer un **bloc driver
personnalisé** (MATLAB System object + `coder.ceval` appelant une bibliothèque Arduino type U8g2).
C'est une super compétence à mettre sur le CV ; on le fera ensemble, étape par étape.

## Phases
1. **Valider la BOM et commander** ← on en est là
2. **Design 3D v1** (pendant la livraison) → impression test d'encombrement
3. **Tests composants un par un** dans Simulink : moteurs, IR, toucher, puis bloc OLED
4. **Stateflow des comportements** (SLEEP / AWAKE / WANDER / HAPPY)
5. **Assemblage, finitions, emballage** 🎁

## Infos encore nécessaires
- Modèle de l'imprimante 3D (taille du plateau) et couleurs de filament dispo.
- ~~Écran~~ → choisi : OLED 1,3" SH1106 blanc.

## Mémoire de la carte (Nano R4 : 256 KB flash / 32 KB RAM)
Estimation : ~60–90 KB de flash et ~6–8 KB de RAM au total (cœur Arduino + code Simulink/Stateflow
+ U8g2 + buffer écran 1 KB) → large marge. À vérifier dès le 1er deploy dans le log de build
(« Sketch uses … bytes »). Règle : yeux dessinés par code (formes), pas en images.
