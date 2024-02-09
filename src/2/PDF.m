function p = PDF(mf, mi, si)
% Calculates the probability of each instrument for a set of observations
%
% Inputs:
%   - mf: observation matrix 
%   - mi: stacked-up mean vectors for each instrument
%   - si: stacked-up covariance matrices for each instrument
% Output:
%   - p: probability matrix of size n x n, where each row contains the
%        probabilities for each instrument for a given observation in mf

n_of_tests = size(mf, 1);
n_instruments = size(mi,1);

p = zeros(1, n_instruments);

si_jump = size(si,2);

for i =  4001:n_of_tests

    temp = [1:si_jump];
    for j = 1:n_instruments
        P(j) = mvnpdf(mf(i,:), mi(j,:), si(temp:j*si_jump,:));
        temp = temp + si_jump;
    end
    
    [~, id] = max(P);
    p(1, id) = p(1, id) + 1;
end

end




