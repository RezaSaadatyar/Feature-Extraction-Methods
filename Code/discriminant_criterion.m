% Define the discriminant criterion function (e.g., Shannon entropy)
function criterion = discriminant_criterion(coeffs, Q0_00, type)
% This is an example using Shannon entropy as a discriminant criterion.
if type == "entropy"
    p = abs(coeffs) / sum(abs(coeffs));
    p(p == 0) = [];  % Remove zero entries
    criterion = -sum(p .* log(p));
elseif type == "energy"
    E_jk = sum(coeffs .^ 2) / sum(Q0_00 .^ 2);  % Calculate the energy for Q_jk
    E_00 = 1; % The energy of Q0_00 is 1 since it is normalized by itself
    criterion = E_jk - E_00; % Calculate the normalized energy difference
end
end