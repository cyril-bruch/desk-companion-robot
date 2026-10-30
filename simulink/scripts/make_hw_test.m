%% make_hw_test.m - small test model: which wheel / direction each DRV8833 input
%  drives, and which cliff sensor is on which pin. Builds models/hw_test.slx.
%
%  Wheels (robot lifted, 16 s cycle, 2 s per step, a beep marks each step):
%    step 1  IN1 (D10) alone   - low beep
%    step 2  stop
%    step 3  IN2 (D9)  alone   - medium beep
%    step 4  stop
%    step 5  IN3 (D6)  alone   - high beep
%    step 6  stop
%    step 7  IN4 (D5)  alone   - very high beep
%    step 8  stop
%  Eyes (cliff sensors): neutral = no void, sad = void on D8,
%                        happy = void on D7, surprised = void on both.

scriptDir = fileparts(mfilename('fullpath'));
if isempty(scriptDir), scriptDir = pwd; end
root = fileparts(scriptDir);
addpath(scriptDir, fullfile(root,'blocks','oled','Oled_eyes'), fullfile(root,'blocks','buzzer','Buzzer_tone'));

mdl = 'hw_test';
if bdIsLoaded(mdl), close_system(mdl, 0); end
new_system(mdl);
set_param(mdl, 'HardwareBoard', 'Arduino Nano R4', 'SolverType', 'Fixed-step', ...
    'Solver', 'FixedStepDiscrete', 'FixedStep', '0.01', 'StopTime', 'inf');

% ---------- wheels: one DRV8833 input at a time ----------
duty = 150;                                % ~60 %, gentle
pins = [10 9 6 5];
for k = 1:4
    v = zeros(1, 8);  v(2*k - 1) = duty;
    y = 40 + 90*(k - 1);
    src = sprintf('%s/IN%d sequence', mdl, k);
    cvt = sprintf('%s/to uint8 %d', mdl, k);
    pwm = sprintf('%s/PWM D%d (IN%d)', mdl, pins(k), k);
    add_block('simulink/Sources/Repeating Sequence Stair', src, ...
        'OutValues', mat2str(v), 'tsamp', '2', 'Position', [40 y 120 y+40]);
    add_block('simulink/Signal Attributes/Data Type Conversion', cvt, ...
        'OutDataTypeStr', 'uint8', 'Position', [170 y 230 y+40]);
    add_block('arduinolib/PWM', pwm, 'Position', [290 y 410 y+50]);
    setPin(pwm, pins(k));
    add_line(mdl, [get_param(src,'Name') '/1'], [get_param(cvt,'Name') '/1']);
    add_line(mdl, [get_param(cvt,'Name') '/1'], [get_param(pwm,'Name') '/1']);
end

% ---------- a beep at the start of each wheel step ----------
f = zeros(1, 64);  f([1 17 33 49]) = [523 784 1047 1568];   % 0.25 s slots
add_block('simulink/Sources/Repeating Sequence Stair', [mdl '/beeps'], ...
    'OutValues', mat2str(f), 'tsamp', '0.25', 'Position', [40 420 120 460]);
add_block('simulink/User-Defined Functions/MATLAB System', [mdl '/Buzzer'], ...
    'System', 'Buzzer_tone', 'Position', [290 415 420 465]);
add_line(mdl, 'beeps/1', 'Buzzer/1');

% ---------- cliff sensors -> eyes ----------
add_block('arduinolib/Digital Input', [mdl '/D8'], 'Position', [40 520 160 570]);
add_block('arduinolib/Digital Input', [mdl '/D7'], 'Position', [40 600 160 650]);
setPin([mdl '/D8'], 8);  setPin([mdl '/D7'], 7);
set_param([mdl '/D8'], 'SampleTime', '0.01');  set_param([mdl '/D7'], 'SampleTime', '0.01');
fcn = [mdl '/sensors to face'];
add_block('simulink/User-Defined Functions/MATLAB Function', fcn, 'Position', [220 540 340 630]);
emc = sfroot().find('-isa', 'Stateflow.EMChart', 'Path', fcn);
emc.Script = sprintf(['function face = f(d8, d7)\n' ...
    '%% 1 neutral = no void, 5 sad = void on D8, 2 happy = void on D7, 4 surprised = both\n' ...
    'if d8 > 0 && d7 > 0\n    face = 4;\nelseif d8 > 0\n    face = 5;\n' ...
    'elseif d7 > 0\n    face = 2;\nelse\n    face = 1;\nend\nend\n']);
add_block('simulink/User-Defined Functions/MATLAB System', [mdl '/Eyes'], ...
    'System', 'Oled_eyes', 'Position', [400 560 530 610]);
add_line(mdl, 'D8/1', 'sensors to face/1');
add_line(mdl, 'D7/1', 'sensors to face/2');
add_line(mdl, 'sensors to face/1', 'Eyes/1');

save_system(mdl, fullfile(root, 'models', [mdl '.slx']));
open_system(mdl);
fprintf('hw_test built: Build, Deploy & Start, robot lifted.\n');

function setPin(blk, pin)
dp = fieldnames(get_param(blk, 'DialogParameters'));
k = find(contains(lower(dp), 'pin'), 1);
set_param(blk, dp{k}, num2str(pin));
end
