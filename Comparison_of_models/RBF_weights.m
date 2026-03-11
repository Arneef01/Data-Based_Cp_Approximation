%% CP Approximation using Manual RBF (Radial Basis Function)


data = readtable('combined_total_no_REGION.csv');
TSR = data.TSR;
Pitch = data.PITCH;

Cp_actual = data.CP;

% Combine inputs into a matrix
X = [TSR, Pitch]; 

% 2. Define RBF Parameters
num_centers = 50; % Number of "neurons" or centers
spread = 1.2;     % Sigma (width of the Gaussian)

% 3. Select Centers (c)
% We pick points evenly distributed from the dataset to act as centers
idx = round(linspace(1, length(Cp_actual), num_centers));
centers = X(idx, :); 

% 4. Build the Design Matrix (Phi)
% Each column is the Gaussian activation of one center across all data points
Phi = zeros(length(Cp_actual), num_centers);
for j = 1:num_centers
    % Calculate Euclidean distance between all data points and center j
    dist_sq = sum((X - centers(j,:)).^2, 2);
    % Gaussian RBF formula
    Phi(:, j) = exp(-dist_sq / (2 * spread^2));
end

% 5. Solve for Weights (w)
% Exactly like your polynomial approach: Phi * weights = Cp_actual
weights2 = Phi \ Cp_actual;

% 6. Prediction
Cp_pred_rbf = Phi * weights2;

% 7. Visualization
figure(1);
scatter(Cp_actual, Cp_pred_rbf, 10, 'filled', 'MarkerFaceAlpha', 0.2);
hold on;
plot([min(Cp_actual) max(Cp_actual)], [min(Cp_actual) max(Cp_actual)], 'r', 'LineWidth', 2);
grid on;
title('RBF Manual Approach: Accuracy');
xlabel('Actual Cp');
ylabel('Predicted Cp');
legend('RBF Weights Fit', 'Perfect Fit');

%% Accuracy Metrics
MAE_RBF = mean(abs(Cp_actual - Cp_pred_rbf));
R2_RBF = 1 - sum((Cp_actual - Cp_pred_rbf).^2) / sum((Cp_actual - mean(Cp_actual)).^2);

fprintf('--- RBF Weight-Based Results ---\n');
fprintf('Number of Centers: %d\n', num_centers);
fprintf('RBF Accuracy (R^2): %.4f\n', R2_RBF);
fprintf('Mean Absolute Error: %.4f\n', MAE_RBF);

% To use in Simulink, you need these three variables:
% weights, centers, spread