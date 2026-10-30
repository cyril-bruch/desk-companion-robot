%% build_robot_io.m - completes DesktopRobotSimuModel around the Stateflow chart
%
%  What it does (re-run safe, makes a backup first):
%   1. Paths: model callbacks add scripts/ and the driver blocks to the path.
%   2. Battery: A0 read every Ts, converted to volts and low-pass filtered.
%   3. ACTIONNEURS: cmdMotor -> motion generator (wander/dance/back/align)
%                   -> soft start -> DRV8833 truth table -> PWM D10 D9 D6 D5.
%      + sensor pins: touch D11, cliff left D7, cliff right D8.
%   4. Sound: chart "sound" code -> melody player -> Buzzer_tone (D3).
%   5. Chart: after an edge go back to Wander (not Sleep), petting while
%      wandering makes it happy, a little yawn when it falls asleep.
%
%  Run from MATLAB:  run('<project>\simulink\scripts\build_robot_io.m')

scriptDir = fileparts(mfilename('fullpath'));
if isempty(scriptDir), scriptDir = pwd; end
root    = fileparts(scriptDir);                       % ...\simulink
mdlFile = fullfile(root, 'models', 'DesktopRobotSimuModel.slx');
fcnDir  = fullfile(scriptDir, 'mlfcn');
[~, mdl] = fileparts(mdlFile);
logFile = fullfile(scriptDir, 'build_log.txt');
if isfile(logFile), delete(logFile); end
diary(logFile);
fprintf('=== build_robot_io  %s ===\n', char(datetime('now')));

addpath(scriptDir, fullfile(root,'blocks','oled','Oled_eyes'), fullfile(root,'blocks','buzzer','Buzzer_tone'));
params;                                               % constants in the workspace

% ---------- 0. safety: open model must be saved, then backup ----------
if bdIsLoaded(mdl) && strcmp(get_param(mdl,'Dirty'),'on')
    diary off;
    error('The model has unsaved changes: save it (Ctrl+S) and run again.');
end
backup = fullfile(root, 'models', [mdl '_backup_avant_IO.slx']);
if ~isfile(backup), copyfile(mdlFile, backup); end
fprintf('Backup: %s\n', backup);
load_system(mdlFile);

% ---------- 1. paths in the model callbacks ----------
pathCode = ['robotRoot = fileparts(fileparts(get_param(bdroot,''FileName''))); ' ...
            'addpath(fullfile(robotRoot,''scripts''), ' ...
            'fullfile(robotRoot,''blocks'',''oled'',''Oled_eyes''), ' ...
            'fullfile(robotRoot,''blocks'',''buzzer'',''Buzzer_tone''));'];
set_param(mdl, 'PostLoadFcn', pathCode);
set_param(mdl, 'InitFcn', [pathCode newline 'params']);
fprintf('1. Model callbacks: paths + params\n');

chart = [mdl '/Robot mode'];
cph   = get_param(chart, 'PortHandles');              % Outport: 1 cmdMotor, 2 face, 3 sound

% ---------- 2. battery ----------
bat = [mdl '/batterie level'];
ain = [bat '/Analog Input'];
set_param(ain, 'SampleTime', 'Ts');                   % single rate model (no rate transitions)
gainBlk = [bat '/Gain'];
if getSimulinkBlockHandle(gainBlk) > 0
    removeLines(gainBlk); delete_block(gainBlk);
end
bf = addFcn([bat '/battFilter'], fullfile(fcnDir,'battFilter.m'), ...
            {'vRef','adcMax','Ts','tauBatt'}, [600 300 700 350]);
removeLines(bf);
connect(bat, ain, 1, bf, 1);
connect(bat, bf, 1, [bat '/Volt'], 1);
fprintf('2. Battery: A0 every Ts -> volts -> low-pass filter\n');

% ---------- 3. ACTIONNEURS ----------
act = [mdl '/ACTIONNEURS'];
if getSimulinkBlockHandle(act) > 0, removeLines(act); delete_block(act); end
add_block('built-in/Subsystem', act, 'Position', [675 400 805 470]);
add_block('simulink/Sources/In1', [act '/cmdMotor'], 'Position', [20 103 50 117]);
mg = addFcn([act '/motionGen'], fullfile(fcnDir,'motionGen.m'), ...
     {'Ts','wander','dance','backward','alignRight','alignLeft', ...
      'speedWander','speedTurn','speedDance','speedBack','speedAlign', ...
      'wanderGo','wanderTurn','wanderPause','wanderTurnProb','dancePeriod'}, [100 50 260 170]);
rl = [act '/Soft start L'];  rr = [act '/Soft start R'];
add_block('simulink/Discontinuities/Rate Limiter', rl, 'Position', [320 52 360 78], ...
          'RisingSlewLimit', '1/rampTime', 'FallingSlewLimit', '-1/rampTime');
add_block('simulink/Discontinuities/Rate Limiter', rr, 'Position', [320 92 360 118], ...
          'RisingSlewLimit', '1/rampTime', 'FallingSlewLimit', '-1/rampTime');
dr = addFcn([act '/drv8833'], fullfile(fcnDir,'drv8833.m'), ...
     {'dirLeft','dirRight','pwmMin','pwmMax'}, [430 40 590 180]);
connect(act, [act '/cmdMotor'], 1, mg, 1);
connect(act, mg, 1, rl, 1);  connect(act, rl, 1, dr, 1);
connect(act, mg, 2, rr, 1);  connect(act, rr, 1, dr, 2);
connect(act, mg, 3, dr, 3);  connect(act, mg, 4, dr, 4);
pins  = [10 9 6 5];                                  % must be PWM pins: D3 D5 D6 D9 D10 D11
names = {'PWM D10 (IN1 left)','PWM D9 (IN2 left)','PWM D6 (IN3 right)','PWM D5 (IN4 right)'};
for k = 1:4
    p = [act '/' names{k}];
    add_block('arduinolib/PWM', p, 'Position', [680 25+40*k 800 55+40*k]);
    setPin(p, pins(k));
    connect(act, dr, k, p, 1);
end
removeLines(chart, 'out', 1);
connect(mdl, chart, 1, act, 1);
fprintf('3. ACTIONNEURS: motionGen -> soft start -> drv8833 -> PWM D10 D9 D6 D5\n');

% ---------- 3b. sensor pins (as wired on the robot) ----------
setPin([mdl '/pet captor'], 11);                     % touch sensor SIG -> D11
ed = [mdl '/edge detector'];
cl = renameIf([ed '/Digital Input1'], 'Cliff left (D7)');   % feeds the x2 gain
cr = renameIf([ed '/Digital Input'],  'Cliff right (D8)');  % feeds the x1 input
setPin(cl, 7);  setPin(cr, 8);
fprintf('3b. Pins: touch D11, cliff left D7, cliff right D8\n');

% ---------- 4. sound ----------
old = [mdl '/SoundPlayer (a faire)'];
if getSimulinkBlockHandle(old) > 0, removeLines(old); delete_block(old); end
sp = addFcn([mdl '/SoundPlayer'], fullfile(fcnDir,'soundPlayer.m'), ...
     {'Ts','soundOn'}, [675 290 785 340]);
buz = [mdl '/Buzzer'];
removeLines(buz, 'in', 1);
removeLines(chart, 'out', 3);
connect(mdl, chart, 3, sp, 1);
connect(mdl, sp, 1, buz, 1);
fprintf('4. Sound: chart -> SoundPlayer -> Buzzer (D3)\n');

% ---------- 5. chart tweaks ----------
ch = sfroot().find('-isa', 'Stateflow.Chart', 'Path', chart);
st = @(n) ch.find('-isa', 'Stateflow.State', 'Name', n);
waitS = st('Wait'); wanderS = st('Wander'); happyS = st('Happy'); sleepS = st('Sleep');
allTr = ch.find('-isa', 'Stateflow.Transition');
% 5a. Wait -> Wander (before: Wait -> Normal -> default Sleep, the robot fell asleep after each edge)
for tr = allTr'
    if isequal(tr.Source, waitS) && ~isequal(tr.Destination, wanderS)
        tr.Destination = wanderS;
        fprintf('5a. Wait -> Wander\n');
    end
end
% 5b. petting while wandering -> Happy
hasIt = false;
for tr = allTr'
    if isequal(tr.Source, wanderS) && isequal(tr.Destination, happyS), hasIt = true; end
end
if ~hasIt
    t = Stateflow.Transition(wanderS.getParent);
    t.Source = wanderS; t.Destination = happyS;
    t.LabelString = '[hasChangedTo(pet, petOn)]';
    fprintf('5b. Wander -> Happy when petted\n');
end
% 5c. yawn when falling asleep
if isempty(ch.find('-isa', 'Stateflow.Data', 'Name', 'sndSleep'))
    d = Stateflow.Data(ch); d.Name = 'sndSleep'; d.Scope = 'Parameter';
end
lbl = regexprep(sleepS.LabelString, 'sound\s*=\s*sndNone', 'sound = sndSleep');
if ~strcmp(lbl, sleepS.LabelString)
    sleepS.LabelString = lbl;
    fprintf('5c. Sleep plays sndSleep\n');
end

% 5d. "void" is a C keyword: code generation refuses it -> voidValue
dv = ch.find('-isa', 'Stateflow.Data', 'Name', 'void');
if ~isempty(dv)
    dv.Name = 'voidValue';
    fprintf('5d. Parameter void renamed voidValue\n');
end
for tr = ch.find('-isa', 'Stateflow.Transition')'
    lbl = regexprep(tr.LabelString, '\<void\>', 'voidValue');
    if ~strcmp(lbl, tr.LabelString), tr.LabelString = lbl; end
end

% ---------- save + compile check ----------
save_system(mdl);
fprintf('Saved %s\n', mdl);
try
    set_param(mdl, 'SimulationCommand', 'update');
    fprintf('UPDATE DIAGRAM OK (Ctrl+D): the model compiles.\n');
catch err
    fprintf(2, 'UPDATE DIAGRAM FAILED:\n%s\n', getReport(err, 'extended', 'hyperlinks', 'off'));
end
open_system(mdl);
diary off;

%% ====================== helpers ======================
function blk = addFcn(path, codeFile, prm, pos)
% MATLAB Function block from a .m file, with params.m variables as Parameters
if getSimulinkBlockHandle(path) > 0, removeLines(path); delete_block(path); end
add_block('simulink/User-Defined Functions/MATLAB Function', path, 'Position', pos);
emc = sfroot().find('-isa', 'Stateflow.EMChart', 'Path', path);
emc.Script = fileread(codeFile);
for k = 1:numel(prm)
    d = emc.find('-isa', 'Stateflow.Data', 'Name', prm{k});
    if isempty(d), d = Stateflow.Data(emc); d.Name = prm{k}; end
    d.Scope = 'Parameter';
end
blk = path;
end

function connect(sys, src, sp, dst, dp)
s = get_param(src, 'PortHandles'); d = get_param(dst, 'PortHandles');
add_line(sys, s.Outport(sp), d.Inport(dp), 'autorouting', 'smart');
end

function removeLines(blk, kind, idx)
% delete the lines on a block (all, or one port)
lh = get_param(blk, 'LineHandles');
if nargin == 1
    h = [lh.Inport(:); lh.Outport(:)];
elseif strcmp(kind, 'in')
    h = lh.Inport(idx);
else
    h = lh.Outport(idx);
end
for x = h(:)'
    if x ~= -1, delete_line(x); end
end
end

function p = renameIf(oldPath, newName)
% rename a block once (re-run safe): returns its current path
p = [fileparts(oldPath) '/' newName];
if getSimulinkBlockHandle(p) < 0 && getSimulinkBlockHandle(oldPath) > 0
    set_param(oldPath, 'Name', newName);
end
end

function setPin(blk, pin)
% the pin parameter name differs between Arduino blocks: find it
dp = fieldnames(get_param(blk, 'DialogParameters'));
k = find(contains(lower(dp), 'pin'), 1);
if isempty(k)
    fprintf(2, 'No pin parameter on %s. Parameters: %s\n', blk, strjoin(dp, ', '));
else
    set_param(blk, dp{k}, num2str(pin));
end
end
