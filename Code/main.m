% ================ Feature extraction methods (2023-2024) =================
% ================== Presented by: Reza Saadatyar =========================
% ==== E-mail: Reza.Saadatyar92@gmail.com; Reza.Saadatyar@outlook.com =====

clc; clear; close all;
%% Load or generate your data here
data = randn(100, 1); 
%% Define wavelet function and maximum level for decomposition
wavelet = 'db1'; % Daubechies 1 wavelet
max_level = 3; % Level of decomposition
% Step 1: Decompose the data using Wavelet Packet Transform (WPT)
wp = wpdec(data, max_level, wavelet);
% Step 2: Define the discriminant criterion function (e.g., Shannon entropy)
% Step 3: Traverse the wavelet packet tree and evaluate the discriminant criterion
% for each node to find the best bases.
criteria = struct;
Q0_00 = wpcoef(wp, 0); % The root node coefficients, Q0_00, are the approximation coefficients at level 0
type = "jenson";   % entropy, energy, cosine, jenson
if type =="entropy" || type=="energy"
    for idx = 1:(2^max_level - 1)
        nodeCoeffs = wpcoef(wp, idx);
        criteria.(['n' num2str(idx)]) = discriminant_criterion(nodeCoeffs, Q0_00, type);
    end
elseif type == "jenson"
    for idx = 1:2^max_level-1
    % Ensure the coefficients are normalized and positive
    P1 = abs(wpcoef(wp, 2*idx-1)) / sum(abs(wpcoef(wp, 2*idx-1)));
    P2 = abs(wpcoef(wp, 2*idx)) / sum(abs(wpcoef(wp, 2*idx)));
    epsilon = 1e-10; % Avoid log of zero by adding a small constant
    P1(P1 == 0) = epsilon;
    P2(P2 == 0) = epsilon;
    M = 0.5 * (P1 + P2);% Calculate the average distribution
    % Calculate the Jensen difference
    Jenson = 0.5 * (sum(P1 .* log(P1 ./ M)) + sum(P2 .* log(P2 ./ M)));
    % Calculate the dissimilarity measure delta_jk
    criteria.(['n' num2str(idx)]) = 1 - Jenson;
    end
else
    for idx = 1:2^max_level-1
    % Ensure the coefficients are normalized and positive
    P1 = abs(wpcoef(wp, 2*idx-1)) / sum(abs(wpcoef(wp, 2*idx-1)));
    P2 = abs(wpcoef(wp, 2*idx)) / sum(abs(wpcoef(wp, 2*idx)));
    epsilon = 1e-10; % Avoid log of zero by adding a small constant
    P1(P1 == 0) = epsilon;
    P2(P2 == 0) = epsilon;
    criteria.(['n' num2str(idx)]) = 1 - dot(P1, P2); % Compute the cosine similarity;
    end
end
% Step 4: Sort the nodes based on the discriminant criterion
criteria_values = struct2array(criteria);
[sorted_values, sorted_indices] = sort(criteria_values, 'descend');
% Step 5: Select the nodes whose power is more than the mean of discriminant powers
mean_discriminant_power = mean(criteria_values);
selected_indices = sorted_indices(sorted_values > mean_discriminant_power);
% The nodes in 'selected_indices' are the ones selected by the LDB algorithm.
% These can now be used to create a feature space for classification.
% Example usage of the selected nodes as features for a classifier
num_features = length(selected_indices);
% num_features = 3;
features = [];
for i = 1:num_features % Fill the features matrix with the coefficients of the selected nodes
    coeffs = wpcoef(wp, selected_indices(i));
    if i == 1
        features = [features;coeffs];
    else
        n=min(length(features), length(coeffs));
        features = [features(1:n, :), coeffs(1:n, :)];
    end
end
% At this point, you would feed 'features' into a classifier.
