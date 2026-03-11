filename = 'ROSCO_Region3main_Results.csv';
data = readtable(filename);

% show columns (optional)
disp(data.Properties.VariableNames);

N  = min(48000, height(data));
Ts = 0.0125;                 % sampling time for Simulink
t  = (0:N-1)'*Ts;

% --- TSR ---
if ismember('TSR', data.Properties.VariableNames)
    tsr = data.TSR(1:N);
elseif ismember('lambda', data.Properties.VariableNames)
    tsr = data.lambda(1:N);
else
    error('No TSR/lambda column found.');
end

% --- Pitch ---
if ismember('PITCH', data.Properties.VariableNames)
    pitch = data.PITCH(1:N);
elseif ismember('BldPitch1', data.Properties.VariableNames)
    pitch = data.BldPitch1(1:N);
else
    error('No PITCH/BldPitch1 column found.');
end

% --- Cp (optional but recommended for plotting) ---
if ismember('Cp', data.Properties.VariableNames)
    cp = data.Cp(1:N);
elseif ismember('CP', data.Properties.VariableNames)
    cp = data.CP(1:N);
else
    cp = []; % if not available, skip
end

% ---- Simulink-friendly STRUCTURE WITH TIME ----
tsr_sim.time = t;
tsr_sim.signals.values = tsr;
tsr_sim.signals.dimensions = 1;

pitch_sim.time = t;
pitch_sim.signals.values = pitch;
pitch_sim.signals.dimensions = 1;

if ~isempty(cp)
    cp_sim.time = t;
    cp_sim.signals.values = cp;
    cp_sim.signals.dimensions = 1;
    save('Region3_SimulinkInputs.mat','tsr_sim','pitch_sim','cp_sim');
else
    save('Region3_SimulinkInputs.mat','tsr_sim','pitch_sim');
end

fprintf('✅ Ready: tsr_sim, pitch_sim');
if ~isempty(cp), fprintf(', cp_sim'); end
fprintf('\n');