%% ===================== params.m — Desk Companion Robot =====================
%  All model constants. Loaded automatically (model InitFcn callback).
%
%  Pin map (Arduino Nano R4, as wired) - set directly in the Arduino blocks:
%    D3  passive buzzer (I/O, low-level trigger)
%    D5  DRV8833 IN4 (right motor)        D6  DRV8833 IN3 (right motor)
%    D7  right cliff sensor (DO)          D8  left cliff sensor (DO)
%    D9  DRV8833 IN2 (left motor)         D10 DRV8833 IN1 (left motor)
%    D11 touch sensor TTP223 (SIG)
%    A0  battery voltage (after the switch)
%    A4  OLED SCK (clock)                 A5  OLED SDA (data)   (software I2C)

%% ---------- Timing ----------
Ts           = 0.01;  % [s] base sample time (= solver fixed step)

%% ---------- Sensors ----------
petOn        = 1;     % touch sensor value when touched
voidValue    = 1;     % cliff sensor value above a void (to be confirmed on the robot)
                      % (not named "void": it is a C keyword and breaks code generation)

% Side where the void is detected (voidSide / edgeSide)
sideRight    = 1;
sideLeft     = 2;
sideBoth     = 3;

%% ---------- Battery ----------
lowVolt      = 3.4;   % [V] below -> Deep_Sleep
highVolt     = 3.7;   % [V] above -> back to normal (hysteresis)
lowBattDelay = 5;     % [s] voltage must stay low this long (ignores motor-start dips)
adcMax       = 1023;  % ADC full scale (10-bit). If Volt reads ~16x too high, use 16383 (14-bit)
vRef         = 5;     % [V] ADC reference (Nano 5 V)
tauBatt      = 1;     % [s] low-pass filter on the battery voltage

%% ---------- Behaviour timing ----------
endHappy     = 3;     % [s] dance duration
wanderWait   = 5;    % [s] awake and idle -> start wandering
sleepTime    = 180;   % [s] wandering without being petted -> sleep

%% ---------- Edge-handling timing ----------
stopTime     = 1.5;   % [s] frozen in surprise
alignTimeout = 3;     % [s] max duration of the alignment facing the void
backTime     = 2;     % [s] reverse after alignment

%% ---------- Motor commands (cmdMotor) ----------
brake        = 0;
dance        = 1;
wander       = 2;
backward     = 3;
alignRight   = 4;     % right wheel braked, left wheel slowly forward
alignLeft    = 5;     % left wheel braked, right wheel slowly forward

%% ---------- Motors (ACTIONNEURS) ----------
% Wheel speeds are fractions (0..1) of the usable range [pwmMin .. pwmMax].
pwmMax       = 0.80;  % max duty: 6 V motors on 7.5 V -> 80 % = 6 V average
pwmMin       = 0.30;  % duty under which the motors do not start (tune on the robot)
rampTime     = 0.4;   % [s] soft start: 0 -> full speed (braking is immediate)
dirLeft      = -1;     % set to -1 if the left wheel turns backwards when it should go forward
dirRight     = -1;     % same for the right wheel

speedWander  = 0.45;   % small steps forward
speedTurn    = 0.4;   % turning on the spot while wandering
speedDance   = 0.4;   % happy wiggle
speedBack    = 0.5;   % reverse after an edge
speedAlign   = 0.4;   % alignment facing the void

% Wander = random sequence: pause -> (step forward OR turn on the spot) -> pause ...
wanderGo       = [0.4 1.2];  % [s] min / max duration of a step forward
wanderTurn     = [0.2 0.7];  % [s] min / max duration of a turn
wanderPause    = [1 3];      % [s] min / max pause between moves
wanderTurnProb = 0.4;        % probability that the next move is a turn
dancePeriod    = 1.6;        % [s] one left-right wiggle

%% ---------- Eye expressions (face) ----------
faceSleep     = 0;
faceNeutral   = 1;
faceHappy     = 2;
faceCurious   = 3;
faceSurprised = 4;
faceSad       = 5;

%% ---------- Sounds (sound) ----------
sndNone      = 0;
sndWake      = 1;
sndHappy     = 2;
sndOops      = 3;
sndSleep     = 4;
sndLowBatt   = 5;
soundOn      = 1;     % 0 = mute (handy while testing at night)
