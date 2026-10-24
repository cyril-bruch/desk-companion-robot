# Assemblage et câblage — v1

Ce document décrit **où va chaque pièce**, **comment tout se branche** et **dans quel ordre monter**.
Les positions correspondent au modèle 3D (`cad/src/robot.py`) — clique sur une pièce dans l'aperçu 3D pour la voir.

---

## 1. Disposition intérieure (de bas en haut)

| Niveau | Hauteur | Ce qu'il y a |
|---|---|---|
| **Sous le plancher** | 0–5 mm | bille folle (arrière), fenêtres des capteurs anti-chute (avant) |
| **Plancher** | 7 mm | moteurs + capots (milieu) · chargeur USB-C (arrière gauche) · driver moteurs (arrière droit) · régulateur (avant centre) · interrupteur (arrière droit, contre la paroi) |
| **Étagères avant** | 19 mm | 2 capteurs anti-chute collés **dessous**, œil tourné vers le sol (~1 cm du bureau) |
| **Étagère batterie** | 19,5 mm | batterie 1000 mAh (arrière) |
| **Plateau Nano** | 35 mm | Arduino Nano R4, USB-C contre la paroi arrière |
| **Coque, face avant** | 37–72 mm | façade noire + écran OLED glissé dans ses guides |
| **Coque, dessus** | ~78 mm | capteur de caresse collé dans sa cage sous le creux |

Arrière du robot, de gauche à droite (vu de dos) : **port de charge USB-C** (bas) · **port de programmation Nano** (milieu) · **interrupteur** (bas).

---

## 2. Alimentation

```
Batterie 3,7 V ──► TP4056 (B+ / B-)          ◄── USB-C de charge
                   TP4056 OUT+ ──► interrupteur ──► MT3608 IN+ ──► 7,5 V ──┬──► Nano VIN
                   TP4056 OUT- ──────────────────► MT3608 IN- ──► GND ────┤
                                                                         └──► DRV8833 VCC (moteurs)
Nano 5V (sortie) ──► écran OLED, capteur de caresse, 2 capteurs anti-chute
```

**Pourquoi 7,5 V sur VIN :** la doc officielle de la Nano R4 ne prévoit pas d'alimenter la carte par sa broche 5V ;
elle s'alimente par **VIN (6–21 V)** ou l'USB-C. On remonte donc la batterie à 7,5 V avec un MT3608, et c'est le
régulateur de la Nano qui fournit le 5 V propre aux capteurs.
⚠️ **Régler le MT3608 à 7,5 V au voltmètre AVANT de le brancher** (vis du potentiomètre).
⚠️ Les moteurs sont des 6 V : dans Simulink, on **limite le PWM à 80 %** (≈ 6 V moyens). C'est une saturation dans le modèle.

> Le module TPS61023 (5 V fixe) de la commande n'est alors plus nécessaire : garde-le en rechange.

---

## 3. Câblage (broches de la Nano R4)

| Composant | Broche composant | → | Nano R4 | Remarque |
|---|---|---|---|---|
| Écran OLED | VDD / GND / SCK / SDA | → | 5V / GND / **A5** / **A4** | I2C 5 V. ⚠️ ordre des broches : VDD en premier |
| Driver DRV8833 | IN1 / IN2 | → | **D5** / **D6** | moteur gauche (2 PWM) |
| | IN3 / IN4 | → | **D9** / **D10** | moteur droit (2 PWM) |
| | VCC / GND | → | 7,5 V / GND | alimentation moteurs |
| | EEP (ou SLP/STBY) s'il existe | → | 5V | sinon le driver reste en veille |
| | OUT1-OUT2 / OUT3-OUT4 | → | moteur G / moteur D | si un moteur tourne à l'envers : inverser ses 2 fils |
| Capteur anti-chute G | DO / VCC / GND | → | **D7** / 5V / GND | régler le potentiomètre sur le bureau |
| Capteur anti-chute D | DO / VCC / GND | → | **D8** / 5V / GND | |
| Capteur de caresse | SIG (I/O) / VCC / GND | → | **D2** / 5V / GND | lu en continu par Simulink |
| MT3608 | OUT+ / OUT- | → | **VIN** / GND | 7,5 V |

Broches PWM de la Nano R4 (doc officielle) : D3, D5, D6, D9, D10, D11. Libres pour la suite : D3, D4, D11, D12, A0–A3.

---

## 4. Ordre de montage

**Avant tout : tester chaque composant seul sur table** (câbles Dupont), un par un dans Simulink :
moteurs → capteurs anti-chute → capteur de caresse → écran. On ne monte dans le robot que ce qui marche.

1. **Souder** : 2 fils sur chaque moteur ; fils sur le TP4056 (B+, B-, OUT+, OUT-), le MT3608 et l'interrupteur ;
   broches sur le DRV8833 si elles sont livrées à part. Gaines thermo sur les soudures d'alimentation.
2. **Roues** : 2 joints toriques par roue, puis emmancher sur l'axe des moteurs.
3. **Plancher, niveau bas** (coque retirée) :
   - poser les moteurs dans leurs berceaux, fils vers le centre, visser les **capots moteurs** (2 vis M2 chacun) ;
   - visser/coller la **bille folle** sous le chapeau arrière ;
   - coller le **chargeur** (glissé par la gauche, USB-C face à l'ouverture arrière), le **driver** (arrière droit),
     le **MT3608** (avant centre) et l'**interrupteur** entre ses deux cales ;
   - coller les **2 capteurs anti-chute** sous les étagères avant, œil au-dessus des fenêtres du plancher.
4. **Batterie** : souder/brancher sur B+/B- du TP4056, puis la poser dans son cadre sur l'étagère (elle passe en l'inclinant).
5. **Nano** : la coller sur son plateau, USB-C contre l'ouverture arrière. Faire tout le câblage du tableau ci-dessus,
   fils passés par les trous du plancher et des étagères.
6. **Test complet coque ouverte** : charge (LED rouge/verte), interrupteur, 7,5 V sur VIN, deploy Simulink, chaque capteur.
7. **Coque** : clipser/coller la **façade** par l'intérieur, glisser l'**écran** par le haut dans ses guides,
   coller le **capteur de caresse** dans sa cage (face sensible contre la coque).
8. **Fermeture** : brancher l'écran et le capteur de caresse, descendre la coque sur le plancher, **4 vis M2** par-dessous.

---

## 5. Points encore ouverts
- Les cotes du chargeur et du driver ne sont pas publiées : leurs emplacements sont larges, à vérifier à réception.
- Hauteur exacte de la bille folle (15 mm annoncés) : si le robot penche, caler avec des rondelles M2.
- Le sens de rotation des moteurs se règle au câblage (ou en inversant le signe dans Simulink).
