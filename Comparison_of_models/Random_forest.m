%% Part 1: Random Forest Training Script (Fixed for Simulink)
% Load your dataset
data = readtable('filtered_TSR_REGION_PITCH_CP.csv');

% Prepare Features (Inputs) and Target
X_train = [data.TSR, data.PITCH, data.REGION];
Y_train = data.CP;

% Train using fitrensemble (more robust for Simulink than TreeBagger)
% Method 'Bag' is equivalent to Random Forest
numTrees = 100;
rfModel = fitrensemble(X_train, Y_train, 'Method', 'Bag', ...
                       'NumLearningCycles', numTrees, ...
                       'Learners', templateTree('MinLeafSize', 5));

% IMPORTANT: Create the COMPACT model for Simulink
% This removes training data and keeps only the decision logic
compactRF = compact(rfModel);

% Assign specifically to the name the Simulink block is looking for
assignin('base', 'compactRF', compactRF);

% Save to a .mat file so you can load it later
save('myRFModel.mat', 'compactRF');

% Quick Accuracy Check
Cp_pred_rf = predict(compactRF, X_train);
MAE_RF = mean(abs(Y_train - Cp_pred_rf));

fprintf('Random Forest Training Complete.\n');
fprintf('Mean Absolute Error: %.4f\n', MAE_RF);