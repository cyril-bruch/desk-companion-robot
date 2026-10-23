# Liste des pièces (BOM) — v1

_Relevé le 23/10/2026. Prix TTC indicatifs, hors frais de port — à revérifier au panier.
Tout est acheté neuf (rien n'est récupéré du kit voiture)._

Les **dimensions** de chaque pièce sont celles utilisées pour la CAO 3D.
→ **Achète exactement ces références** : une autre pièce « équivalente » peut avoir d'autres cotes.

---

## Commande 1 — RobotShop Europe (pièces de précision)
Une seule commande, 6 articles. Les pièces Pololu ont des dimensions documentées au 1/10 mm.

| # | Pièce | Référence exacte | Dimensions (CAO) | Prix | Lien |
|---|---|---|---|---|---|
| 1 | Carte | **Arduino Nano R4 with Headers** — SKU **ABX00143** | 45 × 18 mm | 17,96 € | [RobotShop](https://eu.robotshop.com/products/arduino-nano-r4-w-headers) · alt. [Arduino Store 14,80 €](https://store.arduino.cc/products/nano-r4-with-headers) |
| 2 | Driver moteurs | **Pololu DRV8835 Dual Motor Driver Carrier** — #2135 | 10,2 × 17,8 mm | 7,65 € | [RobotShop](https://eu.robotshop.com/products/controlador-de-motor-dual-drv8835) |
| 3 | Régulateur 5 V | **Pololu 5V Step-Up Regulator U3V16F5** — #4941 | 13,1 × 8,1 × 3 mm | 5,70 € | [RobotShop](https://eu.robotshop.com/products/pololu-5v-step-up-voltage-regulator-u3v16f5) |
| 4 | Roues | **Pololu Wheel 32×7 mm Pair – Black** — #1087 | Ø 32 × 7 mm, moyeu axe D 3 mm | 4,90 € | [RobotShop](https://eu.robotshop.com/products/pololu-wheel-32-7mm-black-pair) |
| 5 | Bille folle | **Pololu Ball Caster with 3/8″ Metal Ball** — #951 | hauteur 10,2 mm, entraxe vis 13,5 mm (vis M2) | 3,24 € | [RobotShop](https://eu.robotshop.com/products/pololu-ball-caster-3-8-in-metal-ball) |
| 6 | Capteurs anti-chute | **Pololu QTR-1A Reflectance Sensor (2-Pack)** — #2458 | 7,6 × 12,7 mm, détection optimale à 3 mm | 6,22 € | [RobotShop](https://eu.robotshop.com/products/pololu-qtr-1a-reflectance-sensor-2pk) |
| | | | | **≈ 45,70 €** | |

⚠️ Stock bas chez RobotShop sur la Nano R4 et les QTR-1A (1 unité) : commander vite. Si la Nano est en rupture → Arduino Store.

## Commande 2 — Amazon.fr (pièces standard)
Pas de lien direct : prends une annonce qui affiche **exactement** les caractéristiques en gras.

| # | Pièce | Quoi prendre exactement | Dimensions (CAO) | Prix ~ |
|---|---|---|---|---|
| 7 | 2 moteurs | **Micro motoréducteur N20, 6 V, 150 tr/min, axe en D Ø 3 mm × 10 mm**, réducteur métal (lot de 2) | réducteur 12 × 10 × 9 mm + moteur 12 × 10 × 15 mm | 8–10 € |
| 8 | Écran | **OLED 1,3″ 128×64, blanc, I2C 4 broches (GND-VCC-SCL-SDA), contrôleur SH1106** | PCB 35,4 × 33,5 mm, trous 30 × 28 mm | 7–9 € |
| 9 | Capteur tactile | **Module TTP223** (lot de 5–10) | ≈ 24 × 15 mm (poche prévue large) | 4–6 € |
| 10 | Batterie | **LiPo 1S 3,7 V 1000 mAh format 803040** avec circuit de protection (PCM) | 8 × 30 × 40 mm | 8–10 € |
| 11 | Chargeur | **Module TP4056 USB-C avec protection** (version 6 pastilles : B+ B- OUT+ OUT-) | ≈ 28 × 17 mm | 5–7 € (lot) |
| 12 | Interrupteur | **Interrupteur à glissière SS12D00G3** (lot) | corps 8,5 × 3,5 mm | 4–6 € |
| 13 | Visserie | **Kit vis + écrous M2** (longueurs 4 à 10 mm) | — | 7–9 € |
| 14 | Câblage | **Fils silicone 26 AWG** + **câbles Dupont F-F et M-F** | — | 8–10 € |
| | | | | **≈ 55 €** |

Option : l'écran existe aussi chez [Audiophonics (6,90 €)](https://www.audiophonics.fr/fr/ecrans-afficheurs-vu-metres/ecran-oled-13-128x64-sh1106-blanc-interface-i2c--p-11573.html),
qui publie ses cotes (35,4 × 33,5 mm, entraxes 30 × 28 mm) — c'est la référence utilisée pour la CAO.

---

## Total
**≈ 100 € + frais de port.** Beaucoup d'articles Amazon sont vendus par lots → il te restera des pièces de rechange.

## À savoir avant de commander
- **Soudure obligatoire** : les cartes Pololu sont livrées avec les broches non soudées, et les moteurs N20 ont des pattes à souder. Il faut un fer à souder.
- **Dès réception** : mesure 5 cotes à la règle / au pied à coulisse (je te dirai lesquelles). Je corrige la CAO avant l'impression finale.
- **Batterie LiPo** : toujours avec protection ; première charge sous surveillance.
- **Règle d'alimentation** : interrupteur sur OFF quand la carte est branchée en USB au PC.
