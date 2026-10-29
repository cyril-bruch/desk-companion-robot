# Simulink model

Model-based design of the robot's behaviour (MATLAB / Simulink / Stateflow, R2026b),
deployed on an **Arduino Nano R4** with the Simulink Support Package for Arduino Hardware.

## Open and deploy
1. Open `models/DesktopRobotSimuModel.slx`. Its callbacks add `scripts/` and the two
   driver blocks to the MATLAB path and run `params.m` automatically.
2. Plug the Nano in over USB, then **Hardware → Build, Deploy & Start**.

## Layout
| Path | Content |
|---|---|
| `models/DesktopRobotSimuModel.slx` | top model: sensors → Stateflow chart "Robot mode" → actuators |
| `scripts/params.m` | every constant (timings, speeds, codes, pin map) |
| `scripts/build_robot_io.m` | script that builds the I/O around the chart (re-run safe) |
| `scripts/mlfcn/` | code of the MATLAB Function blocks (motion generator, DRV8833 table, battery filter, sound player) |
| `blocks/oled/Oled_eyes/` | IO Device Builder block: SH1106 OLED eyes (U8g2, software I2C) |
| `blocks/buzzer/Buzzer_tone/` | IO Device Builder block: passive buzzer (`tone()`) |

## Pin map (Nano R4)
| Pin | Signal |
|---|---|
| D3 | buzzer I/O |
| D5 / D6 | DRV8833 IN4 / IN3 (right motor, PWM) |
| D9 / D10 | DRV8833 IN2 / IN1 (left motor, PWM) |
| D7 / D8 | right / left cliff sensor DO |
| D11 | touch sensor SIG |
| A0 | battery voltage (after the switch) |
| A4 / A5 | OLED SCK / SDA |

## Tuning on the robot (`params.m`)
`dirLeft` / `dirRight` (wheel direction), `pwmMin` (motor dead band), `voidValue`
(cliff sensor level above a void), `adcMax` (10- or 14-bit ADC), `wanderWait`, `sleepTime`.

The U8g2 library sources in `blocks/oled/Oled_eyes/Dependencies` are © olikraus, BSD 2-clause.
