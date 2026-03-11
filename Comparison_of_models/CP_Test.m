% ---------- Read CSV ----------


filename = 'ROSCO_Region3main_Results.csv';
opts = detectImportOptions(filename);
data = readtable(filename, opts);

lambda = data{:, "lambda"};
beta   = data{:, "BldPitch1"};
cp     = data{:, "Cp"};
wind_S = data{:, "Wind1VelX"};
% ---------- Create time vector ----------
Ts = 0.0125;   % <<<<<< IMPORTANT: set this to your Simulink sample time (e.g., 0.01 or 0.001)
t  = (0:length(cp)-1)' * Ts;

% ---------- Create timeseries for Simulink ----------
Cp_ts = timeseries(cp, t);
Cp_ts.Name = "Cp";
wind_S = timeseries (wind_S, t);
wind_S.Name = "WInd_S";
% (Optional) save everything
save('Region_3_Data.mat', 'lambda', 'beta', 'cp', 'Ts', 't', 'Cp_ts');

% Quick MATLAB check (optional)
figure; plot(t, cp); grid on;
xlabel('Time (s)'); ylabel('Cp'); title('Cp from CSV');

figure; plot(wind_S.Time, wind_S.Data); grid on;
xlabel('Time (s)'); ylabel('Speed'); title('WInd Speed');