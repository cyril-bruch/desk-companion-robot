function freq = soundPlayer(snd)
% SOUND PLAYER - plays a short melody each time the chart asks for a new
% sound code (1 wake, 2 happy, 3 oops, 4 sleep, 5 low battery).
% Output: note frequency in Hz for the Buzzer_tone block (0 = silence).
% F = notes [Hz] (0 = short silence between notes), D = durations [ms].
F = [1047    0 1319    0 1568    0;    % 1 wake     : rising C-E-G
     1568 2093 1568 2093    0 2637;    % 2 happy    : chirpy trill
     1760 1319  880    0    0    0;    % 3 oops     : falling "oh-oh"
      784    0  659    0  523    0;    % 4 sleep    : slow yawn
      440    0  349    0  262    0];   % 5 low batt : sad and low
D = [  70   20   70   20  140    0;
       60   60   60   60   30  160;
       90   90  220    0    0    0;
      160   40  160   40  320    0;
      250   80  250   80  450    0];
N = [5 6 3 5 5];                        % number of notes per melody

persistent lastSnd mel idx tLeft
if isempty(lastSnd)
    lastSnd = 0; mel = 1; idx = 0; tLeft = 0;
end
if snd ~= lastSnd && snd >= 1 && snd <= 5      % new sound requested
    mel = round(snd); idx = 1; tLeft = D(mel, 1);
end
lastSnd = snd;

freq = 0;
if idx > 0
    freq = F(mel, idx) * 0.5;                  % one octave lower: softer, quieter
    tLeft = tLeft - Ts*1000;
    if tLeft <= 0                               % next note
        idx = idx + 1;
        if idx > N(mel)
            idx = 0;                            % melody finished
        else
            tLeft = tLeft + D(mel, idx);
        end
    end
end
if soundOn == 0
    freq = 0;
end
end
