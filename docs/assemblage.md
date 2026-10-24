# Assemblage et câblage — v1

Ce document décrit **où va chaque pièce**, **comment tout se branche** et **dans quel ordre monter**.
Les positions correspondent au modèle 3D (`cad/src/robot.py`) — clique sur une pièce dans l'aperçu 3D pour la voir.
Vérifié par calcul : aucune pièce achetée ne touche une pièce imprimée ni une autre pièce achetée.

---

## 1. Disposition intérieure (de bas en haut)

| Niveau | Hauteur | Ce qu'il y a |
|---|---|---|
| **Sous le plancher** | 0–5 mm | bille folle (arrière), fenêtres des capteurs anti-chute (avant) |
| **Plancher** | 7 mm | moteurs + capots (milieu) · chargeur USB-C (arrière gauche, port à 0,9 mm de la paroi) · driver moteurs (arrière droit) · interrupteur (arrière droit, contre la paroi) |
| **Étagères avant** | 19–21 mm | **dessous** : 2 capteurs anti-chute, œil vers le sol (~1 cm du bureau) · **dessus** : régulateur MT3608 (à cheval sur les deux étagères) |
| **Étagère batterie** | 19,5 mm | batterie 1000 mAh (arrière) |
| **Plateau Nano** | 35 mm | Arduino Nano R4, **USB-C à 0,6 mm de la paroi, juste derrière l'ouverture arrière** · module buzzer sur l'avant du plateau |
| **Coque, face avant** | 37–72 mm | façade noire + écran OLED glissé dans ses guides |
| **Coque, dessus** | ~78 mm | capteur de caresse collé dans sa cage sous le creux |

Arrière du robot (vu de dos, de gauche à droite) : **port de charge USB-C** (bas) · **port de programmation Nano** (milieu) · **interrupteur** (bas).

Espaces les plus serrés : MT3608 ↔ écran 4,2 mm · buzzer ↔ Nano 4,4 mm · batterie ↔ Nano 7,5 mm.

---

## 2. Alimentation

```
Batterie 3,7 V ──► TP4056 (B+ / B-)                 ◄── câble USB-C (recharge)
                   TP4056 OUT+ ──► interrupteur ──► MT3608 IN+ ──► 7,5 V ──┬──► Nano VIN
                        │                                                 └──► DRV8833 VCC (moteurs)
                        └──────────────► Nano A0 (mesure de la batterie, bonus)
                   TP4056 OUT- ──────────────────► MT3608 IN- ──► GND commun à tout
Nano 5V (sortie) ──► écran OLED, capteur de caresse, 2 capteurs anti-chute
Nano D3 ──► module buzzer (I/O) ; VCC = 5V, GND
```

- **Pourquoi 7,5 V sur VIN** : la doc officielle de la Nano R4 prévoit VIN (6–21 V) ou l'USB-C, pas la broche 5V.
  ⚠️ **Régler le MT3608 à 7,5 V au voltmètre AVANT de le brancher** (petite vis du potentiomètre).
- **Moteurs 6 V sous 7,5 V** : dans Simulink, on **limite le PWM à 80 %** (≈ 6 V moyens) avec une saturation.
- **USB et batterie en même temps** : la Nano R4 choisit automatiquement entre VIN et l'USB-C (doc officielle),
  tu peux programmer le robot allumé.
- **Mesure batterie (bonus, 1 fil)** : la tension batterie (3,0–4,2 V) reste sous 5 V, elle peut aller directement
  sur A0. Simulink pourra afficher des yeux « fatigués » quand la batterie est faible.

### Bilan de consommation (estimation)
| Charge | Courant |
|---|---|
| Nano + écran + 2 capteurs anti-chute + caresse + buzzer (sur le 5V de la Nano) | ≈ 120 mA |
| 2 moteurs en roulant (PWM limité) | ≈ 250 mA sous 7,5 V |
| **Côté batterie** (rendement MT3608 ≈ 85 %) | **≈ 0,8 A en roulant**, ≈ 0,25 A à l'arrêt yeux allumés |

La batterie (1 A en continu) et le TP4056 protégé (coupure ≈ 3 A) tiennent. Autonomie estimée : ~1 h 15 en roulant
sans arrêt, ~3–4 h en usage normal (il roule un peu, regarde, dort). Seul cas limite : les deux moteurs **bloqués**
(≈ 1,2 A sous 7,5 V) → dans Simulink, démarrage progressif (rampe) et arrêt si un moteur reste bloqué.

---

## 3. Câblage (broches de la Nano R4)

| Composant | Broche composant | → | Nano R4 | Remarque |
|---|---|---|---|---|
| Écran OLED | VDD / GND / SCK / SDA | → | 5V / GND / **A5** / **A4** | I2C 5 V. ⚠️ ordre des broches : VDD en premier |
| Driver DRV8833 | IN1 / IN2 | → | **D5** / **D6** | moteur gauche (2 PWM) |
| | IN3 / IN4 | → | **D9** / **D10** | moteur droit (2 PWM) |
| | VCC / GND | → | 7,5 V / GND | alimentation moteurs |
| | EEP (ou SLP/STBY) s'il existe | → | 5V | sinon le driver reste en veille |
| | OUT1-OUT2 / OUT3-OUT4 | → | moteur G / moteur D | un moteur tourne à l'envers → inverser ses 2 fils |
| Capteur anti-chute G | DO / VCC / GND | → | **D7** / 5V / GND | régler le potentiomètre posé sur le bureau |
| Capteur anti-chute D | DO / VCC / GND | → | **D8** / 5V / GND | |
| Capteur de caresse | SIG / VCC / GND | → | **D2** / 5V / GND | |
| **Module buzzer** | I/O / VCC / GND | → | **D3** / 5V / GND | transistor intégré ; s'active au niveau bas (géré dans Simulink) |
| MT3608 | OUT+ / OUT- | → | **VIN** / GND | 7,5 V |
| Batterie (après interrupteur) | TP4056 OUT+ | → | **A0** | bonus : niveau de batterie |

**Il reste assez de broches** : utilisées D2, D3, D5–D10, A0, A4, A5 → libres pour la suite : **D4, D11, D12, D13, A1, A2, A3**.
Broches PWM de la Nano R4 (doc officielle) : D3, D5, D6, D9, D10, D11.

### Le buzzer « mignon »
- **Passif** = Simulink choisit la fréquence de chaque son. On fait des **petits « pouip »** : sons courts (30–120 ms),
  glissandos montants (content), descendants (endormi), petites suites aléatoires façon R2-D2.
- Il est **à l'intérieur de la coque** : le son est étouffé, donc plus doux.
- Le volume se règle aussi par logiciel : en évitant la fréquence de résonance (~4 kHz), le son est plus feutré.
- Côté Simulink : il n'y a pas de bloc « tone » tout fait. On fera un petit bloc personnalisé (même technique que
  pour l'écran, donc une seule chose à apprendre pour les deux).

---

## 4. Vis et trous : rien à percer

Tous les trous sont **dans les fichiers 3D** :

| Où | Trous | Vis |
|---|---|---|
| Coque ↔ plancher | 4 trous Ø 2,2 mm avec logement de tête sous le plancher → 4 colonnes dans la coque (avant-trou Ø 1,7 mm) | 4 × M2 × 8 à 10 mm |
| Capots moteurs ↔ berceaux | 2 trous par berceau (avant-trous Ø 1,6 mm), 4 par moteur | 8 × M2 × 6 mm |
| Bille folle ↔ chapeau arrière | croix de fentes de 2,4 mm : s'adapte à l'écartement des trous de la bille | 2 × M2 + écrous (ou double face) |

Les vis M2 se vissent directement dans le plastique (l'avant-trou est un peu plus petit que la vis, elles « taraudent »
le PLA). Si un trou est imprimé trop fin, passer un foret de 1,5 mm à la main. Toutes les petites cartes se collent au
double face : pas de vis.

---

## 5. Programmer pendant et après le montage

**Le port USB-C de la Nano est toujours accessible** : la carte est poussée contre la paroi arrière, son port est
juste derrière une ouverture de 13 × 8 mm. Tu branches le câble de ton PC **depuis l'extérieur, robot fermé**, à
n'importe quelle étape. Pas besoin de tout coder avant de monter.

**Stratégie conseillée** : tester chaque composant seul sur table (étape 0 ci-dessous), monter, puis développer le
comportement complet (Stateflow) robot monté, en flashant par l'arrière autant de fois que tu veux.

## 6. Ordre de montage

**Avant tout : tester chaque composant seul sur table** (câbles Dupont), un par un dans Simulink :
moteurs → capteurs anti-chute → capteur de caresse → buzzer → écran. On ne monte dans le robot que ce qui marche.

1. **Souder** : 2 fils sur chaque moteur ; fils sur le TP4056 (B+, B-, OUT+, OUT-), le MT3608 et
   l'interrupteur ; broches sur le DRV8833 si elles sont livrées à part. Gaines thermo sur les soudures d'alimentation.
2. **Régler le MT3608 à 7,5 V** (batterie branchée en entrée, voltmètre en sortie), avant de le relier à quoi que ce soit.
3. **Roues** : 2 joints toriques par roue, puis emmancher sur l'axe des moteurs.
4. **Plancher, niveau bas** (coque retirée) :
   - poser les moteurs dans leurs berceaux, fils vers le centre, visser les **capots moteurs** ;
   - visser la **bille folle** sous le chapeau arrière ;
   - coller le **chargeur** (glissé par la gauche, USB-C face à l'ouverture arrière), le **driver** (arrière droit)
     et l'**interrupteur** entre ses deux cales ;
   - coller les **2 capteurs anti-chute** sous les étagères avant, œil au-dessus des fenêtres du plancher,
     puis le **MT3608** sur le dessus des étagères.
5. **Batterie** : brancher sur B+/B- du TP4056, puis la poser dans son cadre sur l'étagère (elle passe en l'inclinant :
   13,7 mm de passage pour 11 mm nécessaires).
6. **Nano** : la glisser entre ses rails jusqu'à la paroi arrière (USB-C dans l'ouverture), la coller ; coller le **module buzzer** devant. Faire tout le câblage du tableau,
   fils passés par les trous du plancher et des étagères.
7. **Test complet coque ouverte** : charge (LED rouge/verte), interrupteur, 7,5 V sur VIN, deploy Simulink, chaque capteur, buzzer.
8. **Coque** : clipser/coller la **façade** par l'intérieur, glisser l'**écran** par le haut dans ses guides,
   coller le **capteur de caresse** dans sa cage (face sensible contre la coque).
9. **Fermeture** : brancher l'écran et le capteur de caresse, descendre la coque sur le plancher, **4 vis M2** par-dessous.

---

## 7. Points encore ouverts
- Cotes non publiées (chargeur, driver, MT3608, module buzzer) : emplacements larges, à vérifier à réception.
- Hauteur exacte de la bille folle (15 mm annoncés) : si le robot penche, caler avec des rondelles M2.
- Longueurs exactes des vis du kit M2–M5 non vérifiées : il faut des M2 de 6 et 8–10 mm.
- Sens de rotation des moteurs : se règle au câblage ou en inversant le signe dans Simulink.
