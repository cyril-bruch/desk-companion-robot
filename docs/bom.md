# Liste des pièces (BOM) — v1

_Vérifié le 23/10/2026 : prix, stock et dimensions relevés sur chaque page produit._
_Tout est acheté neuf. Les dimensions de la colonne « CAO » sont celles utilisées pour le design 3D._

**Règle : commande exactement ces liens.** Une pièce « équivalente » peut avoir d'autres cotes.

---

## Commande 1 — RobotShop Europe (≈ 40 € + 10 € de port)

| # | Pièce | Produit | Dimensions (CAO) | Prix | Lien |
|---|---|---|---|---|---|
| 1 | Carte | Arduino Nano R4 with Headers (ABX00143) | 45 × 18 mm | 17,96 € | [lien](https://eu.robotshop.com/products/arduino-nano-r4-w-headers) |
| 2 | Driver moteurs | Pololu DRV8835 Dual Motor Driver Carrier (#2135) | 10,2 × 17,8 mm | 7,65 € | [lien](https://eu.robotshop.com/products/controlador-de-motor-dual-drv8835) |
| 3 | Roues | Pololu Wheel 32×7 mm Pair, noir (#1087) | Ø 32 × 7 mm, axe en D 3 mm | 4,90 € | [lien](https://eu.robotshop.com/products/pololu-wheel-32-7mm-black-pair) |
| 4 | Bille folle | Pololu Ball Caster 3/8″ Metal Ball (#951) | hauteur 10,2 mm, entraxe vis 13,5 mm | 3,24 € | [lien](https://eu.robotshop.com/products/pololu-ball-caster-3-8-in-metal-ball) |
| 5 | Anti-chute | Pololu QTR-1A Reflectance Sensor, lot de 2 (#2458) | 7,6 × 12,7 mm | 6,22 € | [lien](https://eu.robotshop.com/products/pololu-qtr-1a-reflectance-sensor-2pk) |

## Commande 2 — Amazon.fr

### Composants du robot (≈ 68 €)
| # | Pièce | Produit | Dimensions (CAO) | Prix | Lien |
|---|---|---|---|---|---|
| 6 | Écran (visage) | OLED 1,3″ blanc I2C SH1106, lot de 2 (Binghe) | PCB 33,7 × 35,5 mm, zone active 29,4 × 14,7 mm | 11,99 € | [lien](https://www.amazon.fr/dp/B0DFCHBQQB) |
| 7 | Moteurs | GA12-N20 réducteur métal, **fils déjà soudés**, lot de 2 | corps 24 × 12 × 10 mm, axe D 3 mm × 10 mm | 11,49 € | [lien](https://www.amazon.fr/dp/B0DPKYCZ97) |
| 8 | Capteur caresse | TTP223 tactile capacitif, lot de 10 (JZK) | 15 × 11 mm | 6,29 € | [lien](https://www.amazon.fr/dp/B09VPK9N7F) |
| 9 | Batterie | LiPo 3,7 V 1000 mAh 803040 avec protection PCM (Sunkoo) | 40 × 30 × 7,8 mm | 14,66 € | [lien](https://www.amazon.fr/dp/B0GJSH4J3S) |
| 10 | Recharge USB-C | TP4056 USB-C double protection, lot de 6 (Aideepen) | ≈ 28 × 17 mm (à mesurer) | 6,99 € | [lien](https://www.amazon.fr/dp/B0BZSB3SBN) |
| 11 | Régulateur 5 V | Boost 5 V 1 A fixe, puce TPS61023 (Annadue) | ≈ 18 × 11 mm (baie interne) | 10,85 € | [lien](https://www.amazon.fr/dp/B0HF5BZTPZ) |
| 12 | Interrupteur | SS12D00G3 à glissière, lot de 10 | corps 8,5 × 3,5 mm | 5,69 € | [lien](https://www.amazon.fr/dp/B097D1Y3K5) |

### Outillage et consommables — réutilisables (≈ 49 €)
| # | Pièce | Produit | Prix | Lien |
|---|---|---|---|---|
| 13 | Fer à souder | Kit 80 W réglable avec écran, 15 en 1 (étain, pompe, gaines, pannes) | 18,59 € | [lien](https://www.amazon.fr/dp/B0GF1ND4WY) |
| 14 | Visserie | Vis M2 tête cylindrique + écrous, 502 pièces | 6,99 € | [lien](https://www.amazon.fr/dp/B0GKW37JWC) |
| 15 | Câbles de test | ELEGOO 120 câbles Dupont (M-F, M-M, F-F) | 8,99 € | [lien](https://www.amazon.fr/dp/B01JD5WCG2) |
| 16 | Fil fin | Fil silicone 26 AWG, 6 couleurs × 10 m | 13,99 € | [lien](https://www.amazon.fr/dp/B0F88ZWGLC) |

---

## Total
| | |
|---|---|
| RobotShop | ≈ 40 € + 10 € de port |
| Amazon — composants | ≈ 68 € |
| Amazon — outillage réutilisable | ≈ 49 € |
| **Total** | **≈ 167 €**, dont ≈ 49 € d'outils qui te serviront pour les prochains projets |

Économies possibles : sauter le fil silicone (−14 €, on utilise des câbles Dupont coupés).

## À savoir
- **Moteurs** : vitesse lente (~60 tr/min sous 5 V → ~10 cm/s). Voulu : un robot lent est plus mignon et a le temps de détecter le bord du bureau.
- **Soudure** : ~30 points faciles (broches des petites cartes, fils d'alimentation). Les moteurs ont déjà leurs fils.
- **Dès réception** : 5 mesures à faire (je te dirai lesquelles), puis ajustement de la CAO avant l'impression finale.
- **Recharge** : port USB-C du TP4056 à l'arrière du robot. LED rouge = en charge, verte = chargé.
- **Batterie LiPo** : première charge sous surveillance.
- **Règle d'alimentation** : interrupteur sur OFF quand la carte est branchée en USB au PC.
