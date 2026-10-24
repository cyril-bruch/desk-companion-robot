# Liste des pièces (BOM) — v1 « Amazon »

_Vérifié le 24/10/2026 sur Amazon.fr : prix, stock et dimensions relevés sur chaque fiche produit._
**Une seule commande Amazon, pas de douane, livraison 1 à 3 jours.**

> Pourquoi plus AliExpress : depuis le 1er juillet 2026, l'UE prélève 3 € de droits par catégorie d'article et par colis
> venant de Chine. Avec ~16 petits colis, les frais d'import montaient à 85 €.

---

## 1. Composants (indispensables)

| # | Pièce | Produit | Dimensions (CAO) | Prix | Lien |
|---|---|---|---|---|---|
| 1 | Carte | Arduino Nano R4 **with Headers** (ABX00143), officielle | 45 × 18 mm | 16,50 € | [lien](https://www.amazon.fr/dp/B0FH5Q9YND) |
| 2 | Écran (yeux) | OLED 1,3″ blanc I2C SH1106, lot de 2 (Binghe) | PCB 35,5 × 33,7 mm | 11,99 € | [lien](https://www.amazon.fr/dp/B0DFCHBQQB) |
| 3 | 2 moteurs | GA12-N20 réducteur métal, **fils déjà soudés**, lot de 2 | corps 24 × 12 × 10 mm, axe D 3 × 10 mm | 11,49 € | [lien](https://www.amazon.fr/dp/B0DPKYCZ97) |
| 4 | Pneus | Joints toriques **25 × 2,5 mm** NBR, lot de 10 (4 utilisés) | Ø int. 25, section 2,5 | 7,24 € | [lien](https://www.amazon.fr/dp/B0CTFS36XB) |
| 5 | Driver moteurs | DRV8833, lot de 6 (JZK) | 18,5 × 16 mm | 7,79 € | [lien](https://www.amazon.fr/dp/B0GSVX832J) |
| 6 | Capteur caresse | TTP223, lot de 10 (JZK) | 15 × 11 mm | 6,29 € | [lien](https://www.amazon.fr/dp/B09VPK9N7F) |
| 7 | Batterie | LiPo 3,7 V 1000 mAh 803040 **5C** avec protection PCM (Liter Energy), sans connecteur | 42 × 30 × 8 mm | 12,54 € | [lien](https://www.amazon.fr/dp/B0DQ4CQZ9M) |
| 8 | Recharge USB-C | TP4056 USB-C double protection, lot de 6 (Aideepen) | ≈ 28 × 17 mm | 6,99 € | [lien](https://www.amazon.fr/dp/B0BZSB3SBN) |
| 9 | Régulateur 7,5 V | MT3608, lot de 5 | 37 × 17 × 7 mm | 10,95 € | [lien](https://www.amazon.fr/dp/B07G4KWV6S) |
| 10 | Buzzer | Module buzzer **passif** déclenchement niveau bas, lot de 5 | 38 × 13 × 10 mm | 7,99 € | [lien](https://www.amazon.fr/dp/B096ZWCG7F) |
| 11 | Interrupteur | MTS-102 à levier 6 A, lot de 10 | M6, corps 13 × 8 × 10 mm | 6,99 € | [lien](https://www.amazon.fr/dp/B00VJA8LMO) |
| 12 | Capteurs anti-chute | Module TCRT5000 infrarouge avec potentiomètre, lot de 5 (2 utilisés) | 32 × 14 mm (35 × 16 max accepté) | 11,99 € | [lien](https://www.amazon.fr/dp/B0B2PHWQH2) |
| — | 3e point d'appui | **patin imprimé en 3D** (remplace la bille folle) ; option : pastille de feutre 2 mm collée sous le patin « pour feutre » (plus silencieux) | Ø 16 × 5 mm | 0 € | — |
| | | | | **130,75 €** | |

## 2. Outils et consommables (à emprunter si possible)

| # | Pièce | Produit | Prix | Lien |
|---|---|---|---|---|
| 13 | Fer à souder | Kit 80 W réglable, écran LCD, 15 en 1 (étain, pompe, pannes, support, dénudeur, gaines) | 18,59 € | [lien](https://www.amazon.fr/dp/B0GF1ND4WY) |
| 14 | Vis | Vis M2 tête cylindrique **M2 × 4/6/8/10/12/16/20 + écrous + rondelles**, 1260 pièces | 9,59 € | [lien](https://www.amazon.fr/dp/B0H6B315JC) |
| 15 | Fixation des cartes | Pastilles adhésives mousse double face 9 × 12 × 2 mm, 330 pièces | 7,29 € | [lien](https://www.amazon.fr/dp/B0GCMLRDWD) |
| 16 | Câbles (seulement si le kit voiture en a moins de 10 femelle-femelle) | ELEGOO 120 câbles Dupont 20 cm | 8,99 € | [lien](https://www.amazon.fr/dp/B01JD5WCG2) |

## Total
| Cas | Total |
|---|---|
| Composants seuls (outils empruntés, câbles du kit) | **131 €** |
| Composants + vis + pastilles (fer emprunté) | **148 €** |
| Tout acheté (fer compris) | **166 €** (175 € avec les câbles) |

### Pour baisser encore
- **Fer à souder** : un fablab d'école ou un ami → −18,59 €.
- **Élastiques à la place des joints toriques** : −7,24 € (moins durable, mais ça roule).

---

## Les capteurs anti-chute TCRT5000
Chaque module a **deux petites « LED » côte à côte** (une qui émet l'infrarouge, une qui reçoit) : c'est normal.
- Au montage, l'**œil** (les deux « LED ») va du **côté extérieur**, au-dessus de la fenêtre du plancher.
- Le petit potentiomètre bleu règle la sensibilité : à régler au tournevis, robot posé sur le bureau puis au-dessus du vide.
- Les capteurs du kit voiture ne sont pas ce modèle : on prend le lot Amazon.

## À savoir
- **Écran** : vérifier l'ordre des broches imprimé sur la carte (VCC/GND peuvent être inversés selon les modèles).
- **Batterie** : choisie en **5C** (5 A max) car les moteurs bloqués tirent jusqu'à ~2 A ; une batterie « 1C » (1 A) aurait coupé. Le TP4056 « double protection » protège la batterie (surcharge, décharge profonde, court-circuit). Première charge sous surveillance.
- **Recharge** : port USB-C du TP4056 à l'arrière (LED rouge = en charge, verte = chargé).
