# Desk Companion Robot

A small, cute desk robot with animated eyes, touch reactions and cliff-safe wandering —
built as a birthday gift, and as a hands-on **Model-Based Design** project with
**MATLAB / Simulink & Stateflow** deployed on an **Arduino Nano R4**.

> 🚧 Work in progress

## Features (v1 target)
- **Animated eyes** on a 1.3" OLED display (blink, happy, sleepy…)
- **Touch reaction** — capacitive sensor under the head
- **Desk wandering** with two N20 micro gear motors
- **Cliff detection** — two downward IR sensors so it never falls off the desk
- Rechargeable LiPo battery (USB-C)

## Behaviour (Stateflow)
```
SLEEP  --(touch)-->  AWAKE  --(timer)-->  WANDER
  ^                    ^                    |
  |                    +--(touch)-- HAPPY   |
  +---------(long inactivity)---------------+
WANDER: random walk; edge detected -> back up + turn
```

## Repository layout
| Folder | Content |
|---|---|
| `docs/` | Requirements, decisions, bill of materials |
| `cad/src/` | Parametric 3D sources (Python / CadQuery) |
| `cad/stl/` | Print-ready STL files |
| `electronics/` | Wiring diagram and pinout |
| `simulink/models/` | Simulink / Stateflow models (`.slx`) |
| `simulink/scripts/` | `params.m` — every tunable constant lives here |
| `media/` | Photos, videos, GIFs |

## Tools
- MATLAB / Simulink R2026a, Stateflow
- Simulink Support Package for Arduino Hardware
- CadQuery (3D models)

## Credits
| Part | Author |
|---|---|
| Simulink / Stateflow models, hardware integration, testing | Cyril Bruch |
| 3D mechanical design | AI-generated (Claude), printed and assembled by Cyril |
| Component selection & wiring | AI-proposed, validated and built by Cyril |

The mechanical design was deliberately delegated in order to focus on the
Model-Based Design workflow.

## Roadmap
- [ ] Requirements & bill of materials
- [ ] 3D design v1 — fit test print (v0 preview done: `cad/src/robot.py`)
- [ ] Component bring-up in Simulink (motors, IR, touch, OLED driver block)
- [ ] Stateflow behaviours (SLEEP / AWAKE / WANDER / HAPPY)
- [ ] Final assembly
