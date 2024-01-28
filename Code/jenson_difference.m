function delta_jk = jenson_difference(Q1_jk, Q2_jk) 
% In this function, Q1_jk and Q2_jk represent the wavelet packet coefficients 
% for the two nodes you're comparing
    % Ensure the coefficients are normalized and positive
    P1 = abs(Q1_jk) / sum(abs(Q1_jk));
    P2 = abs(Q2_jk) / sum(abs(Q2_jk));
    
    % Avoid log of zero by adding a small constant
    epsilon = 1e-10;
    P1(P1 == 0) = epsilon;
    P2(P2 == 0) = epsilon;

    % Calculate the average distribution
    M = 0.5 * (P1 + P2);

    % Calculate the Jensen difference
    Jenson = 0.5 * (sum(P1 .* log(P1 ./ M)) + sum(P2 .* log(P2 ./ M)));
    
    % Calculate the dissimilarity measure delta_jk
    delta_jk = 1 - Jenson;
end
