# Liste des pièces (BOM) — v1 « AliExpress »

_Vérifié le 23/10/2026 : chaque lien, prix et dimension a été relevé sur la page produit._
_Le prix affiché par AliExpress est celui de l'option la moins chère : **choisis bien l'option indiquée**._

**Total ≈ 60 € outils compris** (≈ 44 € AliExpress + 16,50 € Amazon), contre ≈ 167 € pour la version Amazon/RobotShop
(toujours disponible dans l'historique Git). Livraison AliExpress : 1 à 3 semaines.

---

## 1. Amazon — la carte (officielle, pour que Simulink marche à coup sûr)

| Pièce | Produit | Dimensions (CAO) | Prix | Lien |
|---|---|---|---|---|
| Carte | Arduino Nano R4 **with Headers** (ABX00143), officielle | 45 × 18 mm | 16,50 € | [Amazon](https://www.amazon.fr/dp/B0FH5Q9YND) |

## 2. AliExpress — composants du robot

| # | Pièce | Option à choisir | Dimensions (CAO) | Qté | Prix | Lien |
|---|---|---|---|---|---|---|
| 1 | Écran OLED 1,3″ SH1106 I2C | **BLANC** | 35,5 × 33,5 × 4,3 mm — broches **VDD-GND-SCK-SDA** | 1 | 2,76 € | [lien](https://fr.aliexpress.com/item/1005006862867338.html) |
| 2 | Moteur N20 réducteur métal | **6V** + **100 tr/min** | Ø 12 × 26 mm (corps), axe D 3 × 10 mm, long. totale 36 mm | **2** | 2 × 1,94 € | [lien](https://fr.aliexpress.com/item/33022320164.html) |
| 3 | Joints toriques (pneus des roues imprimées) | **OD30mm CS2.4mm** (lot de 50) | Ø ext. 30 mm, section 2,4 mm | 1 lot | 1,35 € | [lien](https://fr.aliexpress.com/item/1005008292519935.html) |
| 4 | Bille folle (roue universelle) | — | hauteur 15 mm, bille Ø 12 mm | 1 | 1,40 € | [lien](https://fr.aliexpress.com/item/1005007057637397.html) |
| 5 | Driver moteurs DRV8833 | **5pcs** | ≈ 18 × 16 mm (non publié, baie interne large) | 1 lot | 3,49 € | [lien](https://fr.aliexpress.com/item/1005007347094702.html) |
| 6 | Capteur anti-chute TCRT5000 (module) | — | 32 × 14 mm, détection 1–25 mm | **2** | 2 × 0,41 € | [lien](https://fr.aliexpress.com/item/1005008593986708.html) |
| 7 | Capteur caresse TTP223 | **TTP223** | 15 × 11 mm | 1 | 0,37 € | [lien](https://fr.aliexpress.com/item/1005008530579725.html) |
| 8 | Batterie LiPo 803040 1000 mAh, protégée | **1 PCS** | 8 × 30 × 40 mm | 1 | 4,59 € | [lien](https://fr.aliexpress.com/item/1005008820788359.html) |
| 9 | Chargeur TP4056 avec protection | **18650 Type-c** + **2pc** | ≈ 28 × 17 mm (non publié, à mesurer) | 1 lot | 2,38 € | [lien](https://fr.aliexpress.com/item/1005010585482772.html) |
| 10 | Régulateur 5 V fixe TPS61023 | — | petit module (baie interne) | 1 | 3,39 € | [lien](https://fr.aliexpress.com/item/1005009465120439.html) |
| 11 | Interrupteur à glissière SS12D00G3 | — | corps 8,5 × 3,5 mm | 1 lot | 0,63 € | [lien](https://fr.aliexpress.com/item/33013437240.html) |

## 3. AliExpress — outillage et consommables (réutilisables)

| # | Pièce | Option à choisir | Prix | Lien |
|---|---|---|---|---|
| 12 | Kit fer à souder 80 W réglable, écran LCD — **avec fil à souder**, tresse, pompe, pinces, support | **220V EU PLUG** + **936R SET5** (⚠️ SET1 = fer seul, sans étain) | 12,19 € | [lien](https://fr.aliexpress.com/item/1005007010264876.html) |
| 13 | Kit vis + écrous M2 à M5 | 320 pièces | 3,59 € | [lien](https://fr.aliexpress.com/item/1005010552853863.html) |
| 14 | Câbles Dupont 40 broches | **20 cm**, Femelle-Femelle + Mâle-Femelle | ≈ 2 € | [lien](https://fr.aliexpress.com/item/1005004631908016.html) |
| 15 | Adhésif double face extra-fort (fixe les petites cartes dans leurs baies) | — | 2,09 € | [lien](https://fr.aliexpress.com/item/1005007168731397.html) |

---

## Ce qui change par rapport au design v0
- **Roues imprimées en 3D** avec un joint torique comme pneu (pas de roues N20 fiables sur AliExpress) → le design colle exactement.
- **Moteurs** de 26 mm au lieu de 24, **bille folle** de 15 mm au lieu de 10,2, **capteurs anti-chute** plus grands (32 × 14) → j'adapte la CAO (v1).
- Moteurs sans fils : 2 soudures par moteur.

## À savoir
- **Dimensions « non publiées »** (DRV8833, TP4056) : le vendeur ne les donne pas. Ces cartes vont dans des baies internes larges ; tu les mesureras à réception et j'ajusterai.
- **Écran** : l'ordre des broches est VDD-GND-SCK-SDA (VDD en premier), attention au câblage.
- **Recharge** : port USB-C du TP4056 à l'arrière. LED rouge = en charge, bleue/verte = chargé.
- **Batterie LiPo** : première charge sous surveillance.
- **Règle d'alimentation** : interrupteur sur OFF quand la carte est branchée en USB au PC.
