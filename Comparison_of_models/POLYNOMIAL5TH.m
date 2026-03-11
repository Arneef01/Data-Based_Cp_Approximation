%% CP Approximation using 5th Order Polynomial


% 1. Load your dataset
data = readtable('filtered_TSR_REGION_PITCH_CP.csv');

% 2. Prepare Inputs and Target
% We treat Region 2 and Region 3 separately or as a combined matrix
TSR = data.TSR;
Pitch = data.PITCH;
Region = data.REGION;
Cp_actual = data.CP;

% 3. Create the Design Matrix (Polynomial Features up to 5th order)
% For multivariate, we use the 'polyfeatures' approach
% We will simplify this to a focused 5th order model
X = [TSR, Pitch, Region]; 

% In MATLAB, 'nlinfit' or 'polyfitn' (from FileExchange) is standard.
% Here is the manual Matrix approach (A * w = b):
% We create terms: [1, x, y, z, x^2, y^2, z^2, ... x^5, y^5, z^5]
Degree = 5;
X_poly = [];
for d = 0:Degree
    X_poly = [X_poly, TSR.^d, Pitch.^d];
end

% 4. Solve for Weights (The "A" values)
% Using the Backslash operator (Moore-Penrose Pseudoinverse)
weights1 = X_poly \ Cp_actual;

% 5. Prediction
Cp_pred = X_poly * weights1;

% 6. Visualization
figure(1);
scatter(Cp_actual, Cp_pred, 10, 'filled', 'MarkerFaceAlpha', 0.2);
hold on;
plot([min(Cp_actual) max(Cp_actual)], [min(Cp_actual) max(Cp_actual)], 'r', 'LineWidth', 2);
grid on;
title('MATLAB: 5th Order Polynomial Accuracy');
xlabel('Actual Cp');
ylabel('Predicted Cp');
legend('Predictions', 'Perfect Fit');

%% Accuracy Metrics
MAE = mean(abs(Cp_actual - Cp_pred));
R2 = 1 - sum((Cp_actual - Cp_pred).^2) / sum((Cp_actual - mean(Cp_actual)).^2);

fprintf('Polynomial Accuracy (R^2): %.4f\n', R2);
fprintf('Mean Absolute Error: %.4f\n', MAE);