function [uL, uR, brkL, brkR] = motionGen(cmd)
% MOTION GENERATOR - turns the chart's motor command (cmdMotor) into a
% target speed for each wheel (-1..1, + = forward) and a brake flag per wheel.
% Parameters come from params.m (command codes, speeds, wander/dance timing, Ts).
persistent lastCmd t tc phase dur turnDir seed
if isempty(lastCmd)
    lastCmd = -1; t = 0; tc = 0; phase = 0; dur = 1; turnDir = 1; seed = 20261101;
end
if cmd ~= lastCmd               % new command: restart its little sequence
    t = 0; tc = 0; phase = 0; dur = wanderPause(1);
    lastCmd = cmd;
end
t = t + Ts;
tc = tc + Ts;                   % time since the command changed

uL = 0; uR = 0; brkL = false; brkR = false;
if tc < 0.2 && cmd ~= 0         % short coast between two moves: the wheels slow
    return                      % down before the next one (no current spike)
end

if cmd == wander
    % random sequence: pause -> (step forward OR gentle curve) -> pause ...
    % Both wheels always turn forward: no spinning on the spot, no reversing
    % (there is no cliff sensor at the back).
    if t >= dur
        t = 0;
        [r1, seed] = rnd(seed);
        [r2, seed] = rnd(seed);
        if phase ~= 0                       % a move just ended -> pause
            phase = 0;
            dur = wanderPause(1) + r1*(wanderPause(2) - wanderPause(1));
        elseif r1 < wanderTurnProb          % curve, random side
            phase = 2;
            if r2 < 0.5, turnDir = 1; else, turnDir = -1; end
            [r3, seed] = rnd(seed);
            dur = wanderTurn(1) + r3*(wanderTurn(2) - wanderTurn(1));
        else                                % small step forward
            phase = 1;
            dur = wanderGo(1) + r2*(wanderGo(2) - wanderGo(1));
        end
    end
    if phase == 1
        uL = speedWander;        uR = speedWander;
    elseif phase == 2
        % outer wheel at speedTurn, inner wheel at 30 % of it -> curve
        if turnDir > 0
            uL = speedTurn;      uR = 0.3*speedTurn;     % curve to the right
        else
            uL = 0.3*speedTurn;  uR = speedTurn;         % curve to the left
        end
    else
        brkL = true;             brkR = true;
    end

elseif cmd == dance
    % gentle wiggle: one wheel at a time, with a short gap before each
    % change of direction (both motors reversing at once reset the Nano)
    k = mod(t, dancePeriod) / dancePeriod;   % position in one wiggle, 0..1
    if k < 0.2
        uL = speedDance;                     % left wheel forward
    elseif k >= 0.25 && k < 0.45
        uL = -speedDance;                    % left wheel back
    elseif k >= 0.5 && k < 0.7
        uR = speedDance;                     % right wheel forward
    elseif k >= 0.75 && k < 0.95
        uR = -speedDance;                    % right wheel back
    end                                      % gaps: wheels slow down to 0 (soft start)

elseif cmd == backward
    uL = -speedBack; uR = -speedBack;

elseif cmd == alignRight            % right wheel braked, left wheel slowly forward
    uL = speedAlign; brkR = true;

elseif cmd == alignLeft             % left wheel braked, right wheel slowly forward
    uR = speedAlign; brkL = true;

else                                % brake (and any unknown code)
    brkL = true; brkR = true;
end
end

function [r, s] = rnd(s)
% Park-Miller pseudo-random number in (0,1)
s = mod(s*16807, 2147483647);
r = s/2147483647;
end
