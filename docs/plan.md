# Plan & cahier des charges — Robot Maman

_Mis à jour : 23/10/2026_

## Décisions prises
| Sujet | Décision |
|---|---|
| Approche | Design sur mesure (pièces 3D par Claude, impression par Cyril) |
| Deadline | Anniversaire dans plus d'un mois → on a le temps d'itérer |
| Budget composants | 20–40 € |
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
Deux capteurs IR pointés vers le bas à l'avant pour **ne jamais tomber du bureau**.
Batterie rechargeable en USB-C, interrupteur on/off.

### Machine à états (Stateflow) envisagée
```
SLEEP  --(toucher)-->  AWAKE  --(timer)-->  WANDER
  ^                      ^                    |
  |                      +--(toucher)-- HAPPY |  (yeux heureux, petite danse)
  +----------(inactivité longue)--------------+
WANDER : avance, tourne au hasard ; bord détecté -> recule + tourne
```

## Liste des pièces (BOM) — résumé (version détaillée à commander : `docs/bom.md`)
| # | Pièce | Rôle | Prix ~ | Statut |
|---|---|---|---|---|
| 1 | Arduino Nano R4 | Cerveau | 15–20 € | à acheter |
| 2 | Écran OLED I2C 1,3" 128×64 blanc (SH1106) | Visage / yeux | 5–8 € | à acheter (l'écran déjà possédé sert aux tests) |
| 3 | 2× micromoteurs N20 + roues | Déplacement | 6–9 € | à acheter |
| 4 | Driver moteur DRV8833 (mini) | Remplace le L298N (trop gros) | 2–3 € | à acheter |
| 5 | Capteur tactile TTP223 | Caresse sur la tête | 1 € | à acheter |
| 6 | 2× capteurs IR TCRT5000 | Anti-chute (bord du bureau) | 0 € | réutilisés du kit voiture |
| 7 | Batterie LiPo 1S 3,7 V ~800 mAh | Alimentation | 5–7 € | à acheter |
| 8 | Chargeur TP4056 USB-C (avec protection) | Recharge | 1–2 € | à acheter |
| 9 | Convertisseur boost MT3608 → 5 V | 3,7 V → 5 V | 1–2 € | à acheter |
| 10 | Mini interrupteur à glissière | On/Off | 1 € | à acheter |
| 11 | Bille folle mini (caster) | 3e point d'appui | 1–2 € | à acheter ou imprimée |
| 12 | Visserie M2 / M2.5, fils Dupont fins | Assemblage | ~2 € | à vérifier |
| | **Total estimé** | | **~35–45 €** | |

> Pistes d'économie si besoin : bille folle imprimée en 3D, packs AliExpress (plus long à livrer).

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
