# Assemblage et câblage — v1

Ce document décrit **où va chaque pièce**, **comment tout se branche** et **dans quel ordre monter**.
Les positions correspondent au modèle 3D (`cad/src/robot.py`) — clique sur une pièce dans l'aperçu 3D pour la voir.

---

## 0. Vérification complète du 24/10 (avant impression, pièces Amazon)

### Électrique
| Point vérifié | Valeur | Limite / référence | OK |
|---|---|---|---|
| Alimentation Nano par VIN | 7,5 V (MT3608) | VIN 6–21 V (datasheet Nano R4) | ✅ |
| Broche 5V de la Nano | **sortie** quand alimentée par VIN | power tree de la datasheet ; l'alimenter par cette broche casse l'USB (forum Arduino) | ✅ on ne l'alimente jamais par là |
| USB PC + batterie en même temps | sélection automatique | « power OR » de la datasheet | ✅ |
| Driver DRV8833, alimentation moteurs | 7,5 V | 2,7–10,8 V | ✅ |
| Moteurs 6 V sous 7,5 V | PWM limité à 80 % ≈ 6 V moyens | — | ✅ (saturation dans Simulink) |
| Entrées logiques DRV8833 | 5 V | max 7 V | ✅ |
| Écran OLED, capteurs, buzzer | 5 V (sortie 5V de la Nano), ≈ 150 mA | — | ✅ |
| Broches de la Nano | ≤ 8 mA par broche | 8 mA (datasheet) | ✅ le buzzer passe par le transistor de son module |
| Courant batterie | ≈ 0,8 A en roulant, ≈ 0,25 A à l'arrêt | batterie **5C = 5 A** max (moteurs bloqués ≈ 2 A) ; TP4056 protégé ≈ 3 A | ✅ |
| Interrupteur | ≈ 0,8 A (pics 3 A) | **MTS-102 : 6 A** (l'ancien SS12D00 : 0,5 A ❌ remplacé) | ✅ |
| Recharge | 1 A (TP4056) | batterie 0,5–1 C | ✅ |
| Mesure batterie sur A0 | 3,0–4,2 V | < 5 V | ✅ |
| Broches utilisées / libres | 10 utilisées, 7 libres | — | ✅ |

### Mécanique (calculé sur le modèle 3D)
| Point vérifié | Résultat | OK |
|---|---|---|
| Collisions pièces imprimées ↔ pièces achetées ↔ entre elles | aucune (la seule « collision » est le capot qui serre le moteur de 0,2 mm, voulu) | ✅ |
| Zones des connecteurs Dupont (Nano, écran, caresse, buzzer) | libres | ✅ |
| Cosses des moteurs (à l'arrière de chaque moteur) | 14 mm entre les deux moteurs (moteurs Amazon de 24 mm) | ✅ |
| Colonnes de vis de la coque | reliées à la paroi (avant : flottantes ❌ corrigé) | ✅ |
| Pneus : joint torique 25 × 2,5 sur gorge Ø26 (largeur 2,8) | étirement 4 % (idéal 2–5 %), dépasse d'≈ 1 mm du flasque, roue ≈ Ø 30,9 | ✅ |
| Axe en D du moteur dans la roue | Ø 3,2 / méplat à 1,1 mm pour un axe Ø 3 / 2,5 → serré, 7,5 mm d'engagement | ✅ |
| Patin arrière imprimé vs roues | bas du patin et bas des pneus tous les deux à 0 mm : robot à plat | ✅ |
| Capteurs anti-chute | œil à ~10 mm du sol (plage 1–25 mm) | ✅ |
| Ports USB-C (Nano et charge) | à 0,6–0,9 mm derrière leurs ouvertures | ✅ |
| Passage pour glisser la batterie | 13,7 mm pour 11,5 mm nécessaires (cadre prévu pour 42 × 30 × 8,5 mm) | ✅ |
| Tout tient sur la Dreamer (230 × 150 × 140 mm) | plus grande pièce 92 × 92 × 79 mm | ✅ |
| Fichiers d'impression | 1 seul volume fermé par pièce (« étanche ») | ✅ |

---

## 1. Disposition intérieure (de bas en haut)

| Niveau | Hauteur | Ce qu'il y a |
|---|---|---|
| **Sous le plancher** | 0–5 mm | patin arrière imprimé (2 vis M2), fenêtres des capteurs anti-chute (avant) |
| **Plancher** | 7 mm | moteurs + capots (milieu) · chargeur USB-C (arrière gauche) · driver moteurs (arrière droit) |
| **Étagères avant** | 19–21 mm | **dessous** : 2 capteurs anti-chute, œil vers le sol · **dessus** : régulateur MT3608 |
| **Étagère batterie** | 19,5 mm | batterie 1000 mAh (arrière) |
| **Plateau Nano** | 35 mm | Arduino Nano R4 **à l'envers (broches vers le haut)**, USB-C juste derrière l'ouverture arrière · module buzzer (38 × 13 mm) à l'avant du plateau |
| **Paroi arrière, en haut à droite** | 47 mm | interrupteur à levier MTS-102 (écrou M6) |
| **Coque, face avant** | 37–72 mm | façade noire + écran OLED glissé dans ses guides |
| **Coque, dessus** | ~78 mm | capteur de caresse collé dans sa cage sous le creux |

Arrière du robot : **port de charge USB-C** (bas gauche) · **port de programmation Nano** (milieu) · **interrupteur** (haut droite).

---

## 2. Alimentation

```
Batterie 3,7 V ──► TP4056 B+ / B-                    ◄── câble USB-C (recharge)
                   TP4056 OUT+ ──► interrupteur MTS-102 ──► MT3608 IN+ ──► 7,5 V ──┬──► Nano VIN
                        │                                                         └──► DRV8833 VCC
                        └──────────────► Nano A0 (niveau de batterie)
                   TP4056 OUT- ══════════ GND COMMUN (MT3608 IN-/OUT-, Nano GND, tous les modules)
Nano 5V (sortie) ──► écran OLED, capteur de caresse, 2 capteurs anti-chute, module buzzer
```

- ⚠️ **Toutes les masses sur OUT- du TP4056, jamais sur B-** (sinon la protection de la batterie est court-circuitée).
- ⚠️ **Régler le MT3608 à 7,5 V au voltmètre AVANT de le brancher** à quoi que ce soit (petite vis du potentiomètre bleu).
- Les moteurs (6 V) sont alimentés en 7,5 V : PWM limité à 80 % dans Simulink, avec démarrage progressif.
- Autonomie estimée : ~1 h 15 en roulant sans arrêt, ~3–4 h en usage normal.

---

## 3. Câblage (broches de la Nano R4)

| Composant | Broche composant | → | Nano R4 | Comment le brancher |
|---|---|---|---|---|
| Écran OLED | VCC / GND / SCL / SDA | → | 5V / GND / **A5** / **A4** | Dupont. ⚠️ lire l'ordre imprimé sur la carte |
| Driver DRV8833 | IN1 / IN2 | → | **D5** / **D6** | moteur gauche — **fils soudés** sur le driver |
| | IN3 / IN4 | → | **D9** / **D10** | moteur droit |
| | VCC / GND | → | 7,5 V / GND | |
| | OUT1-OUT2 / OUT3-OUT4 | → | moteur G / moteur D | un moteur tourne à l'envers → inverser ses 2 fils |
| Capteur anti-chute G | DO / VCC / GND | → | **D7** / 5V / GND | **fils soudés** (broches raccourcies) |
| Capteur anti-chute D | DO / VCC / GND | → | **D8** / 5V / GND | idem |
| Capteur de caresse | SIG / VCC / GND | → | **D2** / 5V / GND | Dupont |
| Module buzzer | I/O / VCC / GND | → | **D3** / 5V / GND | Dupont. Actif au niveau bas : **au repos, D3 = HIGH** |
| MT3608 | OUT+ / OUT- | → | **VIN** / GND | fils soudés |
| Batterie (après interrupteur) | OUT+ du TP4056 | → | **A0** | fil soudé côté TP4056 |

Utilisées : D2, D3, D5–D10, A0, A4, A5. **Libres pour la suite : D4, D11, D12, D13, A1, A2, A3.**

**Pourquoi des fils soudés à certains endroits** : le driver est sous l'étagère batterie et les capteurs anti-chute sont
accrochés sous leurs étagères, broches vers le bas : il n'y a pas la hauteur pour un connecteur Dupont (14 mm).
Souder les fils directement (broches raccourcies à 3 mm) prend 2 minutes par carte.

**Pourquoi la Nano est à l'envers** : la version « with headers » a ses broches dessous. Posée à l'envers sur 4 petits
plots (qui ne touchent que les bouts sans broches), les broches pointent vers le haut et les Dupont se branchent par
au-dessus. Le port USB-C se retrouve juste en face de l'ouverture arrière.

### Le buzzer « mignon »
Sons courts (30–120 ms), notes qui montent (content), qui descendent (endormi), petites suites façon R2-D2. Il est
dans la coque, donc étouffé. Côté Simulink : un petit bloc personnalisé, même technique que pour l'écran.

---

## 4. Vis et trous : rien à percer

| Où | Trous dans les pièces | Vis |
|---|---|---|
| Coque ↔ plancher | 4 trous Ø 2,2 avec logement de tête sous le plancher → 4 colonnes dans la coque (avant-trou Ø 1,7) | 4 × M2 × 8 à 10 |
| Capots ↔ berceaux moteurs | 2 avant-trous Ø 1,6 par berceau | 8 × M2 × 6 |
| Patin arrière ↔ plancher | 2 trous Ø 2,4 | 2 × M2 × 6 + écrous |
| Interrupteur ↔ coque | trou Ø 6,5 | écrou fourni avec l'interrupteur |

Les vis M2 se vissent directement dans le plastique. Si un trou sort trop fin, foret de 1,5 mm à la main.

---

## 5. Programmer pendant et après le montage

Le port USB-C de la Nano est juste derrière l'ouverture arrière : tu branches le câble **depuis l'extérieur, robot
fermé**, à n'importe quelle étape. Stratégie conseillée : tester chaque composant seul sur table, monter, puis
développer le comportement complet robot monté en flashant par l'arrière.

---

## 6. Ordre de montage

**Avant tout : tester chaque composant seul sur table**, un par un dans Simulink :
moteurs → capteurs anti-chute → capteur de caresse → buzzer → écran.

1. **Souder** : 2 fils par moteur ; fils sur TP4056 (B+, B-, OUT+, OUT-), MT3608, interrupteur ; fils directement sur
   le DRV8833 et sur les 2 capteurs anti-chute. Gaines thermo sur toutes les soudures d'alimentation.
2. **Régler le MT3608 à 7,5 V** au voltmètre.
3. **Roues** : 2 joints toriques par roue, puis emmancher sur l'axe des moteurs.
4. **Plancher** (coque retirée) :
   - moteurs dans leurs berceaux, cosses vers le centre, **capots** vissés ;
   - **patin arrière** vissé sous le plancher (2 × M2 × 6 + écrous) : le normal, ou le « pour feutre » avec une pastille
     de feutre de 2 mm collée dessous (silencieux) ;
   - **chargeur** collé (glissé par la gauche, USB-C contre l'ouverture), **driver** collé (arrière droit) ;
   - **capteurs anti-chute** collés sous les étagères avant (œil au-dessus des fenêtres), **MT3608** collé dessus.
5. **Batterie** : souder sur B+/B-, la poser dans son cadre (elle passe en l'inclinant).
6. **Nano** : à l'envers sur ses 4 plots, poussée jusqu'à la paroi arrière, collée ; **module buzzer** collé devant.
7. **Interrupteur** : dans le trou en haut à droite de la coque, écrou serré (fils assez longs pour ouvrir la coque).
8. **Câblage** selon le tableau, puis **test complet coque ouverte** : charge (LED rouge/verte), 7,5 V sur VIN,
   deploy Simulink, chaque capteur, buzzer.
9. **Coque** : façade collée par l'intérieur, écran glissé par le haut dans ses guides, capteur de caresse collé dans sa cage.
10. **Fermeture** : brancher écran et caresse, descendre la coque, **4 vis M2** par-dessous.

---

## 7. Points encore ouverts (à vérifier à réception, sans impact sur l'impression)
- Cotes non publiées (chargeur, driver, MT3608, module buzzer) : emplacements larges + double face.
- Capteurs TCRT5000 (lot Amazon, 32 × 14 mm) : œil côté extérieur, sensibilité réglée au potentiomètre (voir `bom.md`).
