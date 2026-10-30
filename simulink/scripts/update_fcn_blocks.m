%% update_fcn_blocks.m - copies the code of scripts/mlfcn/*.m into the MATLAB
%  Function blocks of the model (without rebuilding anything else), then
%  checks that the model compiles. Use it after editing a file in mlfcn/.
scriptDir = fileparts(mfilename('fullpath'));
if isempty(scriptDir), scriptDir = pwd; end
root = fileparts(scriptDir);
mdl  = 'DesktopRobotSimuModel';
logFile = fullfile(scriptDir, 'update_log.txt');
if isfile(logFile), delete(logFile); end
diary(logFile);
fprintf('=== update_fcn_blocks  %s ===\n', char(datetime('now')));
addpath(scriptDir, fullfile(root,'blocks','oled','Oled_eyes'), fullfile(root,'blocks','buzzer','Buzzer_tone'));
params;
if bdIsLoaded(mdl), close_system(mdl, 0); end           % reload the file from disk
load_system(fullfile(root, 'models', [mdl '.slx']));

blocks = {'Motors/motionGen', 'motionGen'; 'Motors/drv8833', 'drv8833'; ...
          'Sound player', 'soundPlayer'; 'Battery/battFilter', 'battFilter'};
for k = 1:size(blocks, 1)
    path = [mdl '/' blocks{k,1}];
    emc = sfroot().find('-isa', 'Stateflow.EMChart', 'Path', path);
    if isempty(emc)
        fprintf(2, 'NOT FOUND: %s\n', path); continue
    end
    % keep the block's own signature line (Simulink lists the params.m
    % parameters in it) and replace only the body with the file's code
    code  = splitlines(string(fileread(fullfile(scriptDir, 'mlfcn', [blocks{k,2} '.m']))));
    cur   = splitlines(string(emc.Script));
    newCode = strjoin([cur(1); code(2:end)], newline);
    if strtrim(strjoin(cur, newline)) == strtrim(newCode)
        fprintf('%-28s already up to date\n', blocks{k,1});
    else
        emc.Script = char(newCode);
        fprintf('%-28s UPDATED\n', blocks{k,1});
    end
end
save_system(mdl);
try
    set_param(mdl, 'SimulationCommand', 'update');
    fprintf('UPDATE DIAGRAM OK\n');
catch err
    fprintf(2, 'UPDATE DIAGRAM FAILED:\n%s\n', getReport(err, 'extended', 'hyperlinks', 'off'));
end
diary off;
