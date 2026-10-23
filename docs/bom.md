# Liste des pièces (BOM) — v1

_Relevé le 23/10/2026. Prix TTC indicatifs, hors frais de port — à revérifier au panier.
Tout est acheté neuf (rien n'est récupéré du kit voiture)._

Les **dimensions** de chaque pièce sont celles utilisées pour la CAO 3D.
→ **Achète exactement ces références** : une autre pièce « équivalente » peut avoir d'autres cotes.

---

## Commande 1 — RobotShop Europe (pièces de précision)
Une seule commande, 5 articles. Les pièces Pololu ont des dimensions documentées au 1/10 mm.

| # | Pièce | Référence exacte | Dimensions (CAO) | Prix | Lien |
|---|---|---|---|---|---|
| 1 | Carte | **Arduino Nano R4 with Headers** — SKU **ABX00143** | 45 × 18 mm | 17,96 € | [RobotShop](https://eu.robotshop.com/products/arduino-nano-r4-w-headers) · alt. [Arduino Store 14,80 €](https://store.arduino.cc/products/nano-r4-with-headers) |
| 2 | Driver moteurs | **Pololu DRV8835 Dual Motor Driver Carrier** — #2135 | 10,2 × 17,8 mm | 7,65 € | [RobotShop](https://eu.robotshop.com/products/controlador-de-motor-dual-drv8835) |
| 4 | Roues | **Pololu Wheel 32×7 mm Pair – Black** — #1087 | Ø 32 × 7 mm, moyeu axe D 3 mm | 4,90 € | [RobotShop](https://eu.robotshop.com/products/pololu-wheel-32-7mm-black-pair) |
| 5 | Bille folle | **Pololu Ball Caster with 3/8″ Metal Ball** — #951 | hauteur 10,2 mm, entraxe vis 13,5 mm (vis M2) | 3,24 € | [RobotShop](https://eu.robotshop.com/products/pololu-ball-caster-3-8-in-metal-ball) |
| 6 | Capteurs anti-chute | **Pololu QTR-1A Reflectance Sensor (2-Pack)** — #2458 | 7,6 × 12,7 mm, détection optimale à 3 mm | 6,22 € | [RobotShop](https://eu.robotshop.com/products/pololu-qtr-1a-reflectance-sensor-2pk) |
| | | | | **≈ 40 €** + 10 € de port | |

_Le régulateur Pololu U3V16F5 prévu au départ est en rupture (comme tous les régulateurs 5 V Pololu chez RobotShop) → remplacé par un module générique (ligne 11b). Il est rangé dans une baie interne, ses cotes exactes ne contraignent pas la coque._

⚠️ Stock bas chez RobotShop sur la Nano R4 et les QTR-1A (1 unité) : commander vite. Si la Nano est en rupture → Arduino Store.

## Commande 2 — Amazon.fr (pièces standard)
Pas de lien direct : prends une annonce qui affiche **exactement** les caractéristiques en gras.

| # | Pièce | Quoi prendre exactement | Dimensions (CAO) | Prix ~ |
|---|---|---|---|---|
| 7 | 2 moteurs | **Micro motoréducteur N20, 6 V, 150 tr/min, axe en D Ø 3 mm × 10 mm**, réducteur métal, **avec câbles déjà soudés** (lot de 2) | réducteur 12 × 10 × 9 mm + moteur 12 × 10 × 15 mm | 8–10 € |
| 8 | Écran | **OLED 1,3″ 128×64, blanc, I2C 4 broches (GND-VCC-SCL-SDA), contrôleur SH1106** | PCB 35,4 × 33,5 mm, trous 30 × 28 mm | 7–9 € |
| 9 | Capteur tactile | **Module TTP223** (lot de 5–10) | ≈ 24 × 15 mm (poche prévue large) | 4–6 € |
| 10 | Batterie | **LiPo 1S 3,7 V 1000 mAh format 803040** avec circuit de protection (PCM) | 8 × 30 × 40 mm | 8–10 € |
| 11 | Chargeur | **Module TP4056 USB-C avec protection** (version 6 pastilles : B+ B- OUT+ OUT-) | ≈ 28 × 17 mm | 5–7 € (lot) |
| 11b | Régulateur 5 V | **Module boost DC-DC 5 V à sortie FIXE** (pas réglable), entrée 3–4,2 V, ≥ 1 A | ≈ 25 × 15 mm (baie interne) | 5–7 € (lot) |
| 12 | Interrupteur | **Interrupteur à glissière SS12D00G3** (lot) | corps 8,5 × 3,5 mm | 4–6 € |
| 13 | Visserie | **Kit vis + écrous M2** (longueurs 4 à 10 mm) | — | 7–9 € |
| 14 | Câblage | **Fils silicone 26 AWG** + **câbles Dupont F-F et M-F** | — | 8–10 € |
| 15 | Outil | **Kit fer à souder réglable débutant** (fer 60 W à température réglable + support + étain fin 0,8 mm + tresse à dessouder) | — | 20–25 € |
| | | | | **≈ 80 €** (dont ≈ 25 € d'outil réutilisable) |

Option : l'écran existe aussi chez [Audiophonics (6,90 €)](https://www.audiophonics.fr/fr/ecrans-afficheurs-vu-metres/ecran-oled-13-128x64-sh1106-blanc-interface-i2c--p-11573.html),
qui publie ses cotes (35,4 × 33,5 mm, entraxes 30 × 28 mm) — c'est la référence utilisée pour la CAO.

---

## Total
**≈ 40 € (RobotShop) + 10 € de port + ≈ 80 € (Amazon, dont ≈ 25 € de fer à souder).** Beaucoup d'articles Amazon sont vendus par lots → il te restera des pièces de rechange.

## À savoir avant de commander
- **Soudure obligatoire** (~30 points, uniquement des cas faciles) : broches des cartes Pololu, fils batterie / chargeur / interrupteur / régulateur. Moteurs pris avec câbles déjà soudés pour éviter le plus délicat.
- **Dès réception** : mesure 5 cotes à la règle / au pied à coulisse (je te dirai lesquelles). Je corrige la CAO avant l'impression finale.
- **Batterie LiPo** : toujours avec protection ; première charge sous surveillance.
- **Recharge** : par le port USB-C du module TP4056, accessible à l'arrière du robot (LED rouge = en charge, bleue/verte = chargé).
- **Règle d'alimentation** : interrupteur sur OFF quand la carte est branchée en USB au PC.
