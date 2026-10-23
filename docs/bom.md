# Liste des pièces (BOM) — v1

_Prix indicatifs relevés le 23/10/2026 — à vérifier au moment de commander._

## À commander
| # | Pièce | Qté | Quoi chercher exactement | Prix ~ | Où |
|---|---|---|---|---|---|
| 1 | **Arduino Nano R4** — version **avec headers** | 1 | « Arduino Nano R4 with headers » (carte officielle, pas un clone) | 15–18 € | Arduino Store, Farnell, Kubii, Amazon |
| 2 | **Écran OLED 1,3" 128×64 blanc I2C, SH1106** | 1 | 4 broches GND-VCC-SCL-SDA | 6,90 € | [Audiophonics](https://www.audiophonics.fr/fr/ecrans-afficheurs-vu-metres/ecran-oled-13-128x64-sh1106-blanc-interface-i2c--p-11573.html) ou AZ-Delivery (Amazon) |
| 3 | **2 micromoteurs N20 6 V ~100–150 tr/min + roues** | 1 lot | « moteur N20 6V 150 rpm roue 34mm » (lot de 2 avec roues) | 6–10 € | Amazon, AliExpress |
| 4 | **Driver moteur DRV8833** (module mini) | 1 | « DRV8833 module » (lot de 2-5, c'est pareil) | 3–5 € | Amazon (AZ-Delivery), AliExpress |
| 5 | **Capteur tactile TTP223** | 1 | « TTP223 module tactile » (lot de 5-10) | 2–3 € | Amazon, AliExpress |
| 6 | **Batterie LiPo 1S 3,7 V 600–1000 mAh** avec protection et connecteur JST-PH | 1 | taille max ~50 × 35 × 10 mm | 6–8 € | Amazon |
| 7 | **Chargeur TP4056 USB-C avec protection** (version 6 broches, puce DW01) | 1 | « TP4056 USB-C protection » | 2–3 € | Amazon, AliExpress |
| 8 | **Convertisseur boost MT3608** (3,7 V → 5 V) | 1 | « MT3608 step up » | 2–3 € | Amazon, AliExpress |
| 9 | **Mini interrupteur à glissière** SS12D00 | 1 | lot de 10 | 1–2 € | Amazon, AliExpress |
| 10 | **Bille folle mini 3/8"** (ball caster) | 1 | « Pololu ball caster 3/8 » ou générique | 2–4 € | Kubii, Amazon — _peut être imprimée à la place_ |
| 11 | Visserie M2 (vis 6–8 mm + écrous) | 1 kit | « kit vis M2 » | 3–5 € | Amazon |

**Total estimé : ~35–45 €** (moins si tu commandes sur AliExpress, mais livraison 2–3 semaines).

## Déjà possédé (kit voiture)
| Pièce | Rôle |
|---|---|
| 2× capteurs IR TCRT5000 | Anti-chute (détection du bord du bureau) |
| Fils Dupont, breadboard | Tests sur table avant assemblage |
| Écran I2C actuel | Tests du driver OLED en attendant la livraison |

## Points d'attention
- **Nano R4 : prendre la version avec headers**, sinon il faut souder les broches.
- **Batterie** : toujours une LiPo **avec protection**, et ne jamais la charger sans surveillance la 1re fois.
- **Moteurs N20** : vérifier que les roues fournies s'emboîtent sur l'axe en D de 3 mm.
- Pour tester vite, Amazon (livraison 1–2 jours) est conseillé : on a le temps mais pas de marge pour un 2e envoi.
