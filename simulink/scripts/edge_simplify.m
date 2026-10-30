%% edge_simplify.m - new edge reaction in the "Robot mode" chart (v1.1)
%
%  Before: Stop -> align facing the void (searching the other side) -> Backward
%          The alignment drove the robot along the edge: it often fell.
%  Now:    Stop -> Backward (straight) -> turn AWAY from the void -> Wait -> Wander
%            void on the right (or both) -> Turn_Left  (cmd alignLeft : right wheel forward)
%            void on the left            -> Turn_Right (cmd alignRight: left wheel forward)
%  Re-run safe. Makes a backup of the model first.

scriptDir = fileparts(mfilename('fullpath'));
if isempty(scriptDir), scriptDir = pwd; end
root = fileparts(scriptDir);
mdl  = 'DesktopRobotSimuModel';
mdlFile = fullfile(root, 'models', [mdl '.slx']);
addpath(scriptDir, fullfile(root,'blocks','oled','Oled_eyes'), fullfile(root,'blocks','buzzer','Buzzer_tone'));
params;
if bdIsLoaded(mdl), save_system(mdl); close_system(mdl, 0); end
backup = fullfile(root, 'models', [mdl '_backup_avant_edge_v11.slx']);
if ~isfile(backup), copyfile(mdlFile, backup); end
load_system(mdlFile);

ch    = sfroot().find('-isa', 'Stateflow.Chart', 'Path', [mdl '/Robot mode']);
st    = @(n) ch.find('-isa', 'Stateflow.State', 'Name', n);
edgeS = st('Edge');  stopS = st('Stop');  backS = st('Backward');  waitS = st('Wait');
tl = st('Align_Left');  if isempty(tl), tl = st('Turn_Left');  end
tr = st('Align_right'); if isempty(tr), tr = st('Turn_Right'); end

% junction inside Edge
J = ch.find('-isa', 'Stateflow.Junction');
J = J(arrayfun(@(x) isequal(x.getParent, edgeS), J));
j = J(1);

% rewire the existing transitions
for t = ch.find('-isa', 'Stateflow.Transition')'
    s = t.Source;
    if isempty(s), continue, end
    if isequal(s, stopS)
        t.Destination = backS;  t.LabelString = 'after(stopTime, sec)';
    elseif isequal(s, backS)
        t.Destination = j;      t.LabelString = 'after(backTime, sec)';
    elseif isequal(s, tl) || isequal(s, tr)
        t.Destination = waitS;  t.LabelString = 'after(turnTime, sec)';
    elseif isequal(s, j)
        delete(t);                                  % old exits of the junction
    end
end

% new exits of the junction: turn away from the void
t1 = Stateflow.Transition(edgeS); t1.Source = j; t1.Destination = tl;
t1.LabelString = '[edgeSide == sideRight || edgeSide == sideBoth]';
t2 = Stateflow.Transition(edgeS); t2.Source = j; t2.Destination = tr;
t2.LabelString = '[edgeSide == sideLeft]';
t3 = Stateflow.Transition(edgeS); t3.Source = j; t3.Destination = waitS;   % safety default

% rename the two states (the commands stay alignLeft / alignRight)
tl.LabelString = sprintf('Turn_Left\nentry:\ncmdMotor = alignLeft\nface = faceSurprised\nsound = sndNone');
tr.LabelString = sprintf('Turn_Right\nentry:\ncmdMotor = alignRight\nface = faceSurprised\nsound = sndNone');

% chart data: turnTime in, alignTimeout out
if isempty(ch.find('-isa', 'Stateflow.Data', 'Name', 'turnTime'))
    d = Stateflow.Data(ch); d.Name = 'turnTime'; d.Scope = 'Parameter';
end
d = ch.find('-isa', 'Stateflow.Data', 'Name', 'alignTimeout');
if ~isempty(d), delete(d); end

save_system(mdl);
try
    set_param(mdl, 'SimulationCommand', 'update');
    fprintf('edge_simplify: UPDATE DIAGRAM OK\n');
catch err
    fprintf(2, 'edge_simplify: UPDATE FAILED\n%s\n', getReport(err, 'extended', 'hyperlinks', 'off'));
end
% print the Edge transitions for a check
for t = ch.find('-isa', 'Stateflow.Transition')'
    if isequal(t.getParent, edgeS) || isequal(t.Source, stopS) || isequal(t.Source, backS)
        sn = 'default'; if ~isempty(t.Source), try sn = t.Source.Name; catch, sn = 'junction'; end, end
        dn = 'junction'; try dn = t.Destination.Name; catch, end
        fprintf('  %-12s -> %-12s %s\n', sn, dn, t.LabelString);
    end
end
