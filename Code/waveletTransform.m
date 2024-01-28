function [coeffs, freqs] = waveletTransform(data, level, waveletType)
    % This function performs wavelet transform on the input data
    % data: Input signal
    % level: Level of wavelet decomposition
    % waveletType: Type of wavelet used for decomposition

    % Perform wavelet decomposition
    [C, L] = wavedec(data, level, waveletType);

    % Extract approximation and detail coefficients
    coeffs = cell(1, level + 1);
    for i = 1:level
        coeffs{i} = detcoef(C, L, i);
    end
    coeffs{end} = appcoef(C, L, waveletType);

    % Calculate the corresponding frequencies for each level (optional)
    freqs = wavedecfreqs(length(data), level, waveletType);

    % Wavedecfreqs is a custom function to calculate frequencies. 
    % You need to define it based on your application and data sampling rate.
end
