function [Xreduced,M,lambda] = reduce_dimension(X,nPC_or_proportion)
% Reduce the dimension of the input matrix using PCA
% [Xreduced,M,lambda] = reduce_dimension(X,nPC_or_proportion)
%
% Inputs
% X:                 [# observations x # variables] input matrix
% nPC_or_proportion: scalar indicating number of PCs (>=1) or proportion of variance (0-1)
%
% Outputs
% Xreduced:          [# observations x # PCs] output matrix
% M:                 [# variables x # PCs] mapping matrix
% lambda:            [# PCs x 1] vector of eigenvalues
if nargin<2
    nPC_or_proportion = .95;
end

% Center the data
X = bsxfun(@minus, X, nanmean(X));

% Compute covariance matrix
if size(X, 2) < size(X, 1)
    C = nancov(X);
else
    C = (1 / size(X, 1)) * (X * X');
end

% Perform eigendecomposition of C
C(isnan(C)) = 0;
C(isinf(C)) = 0;
[M, lambda] = eig(C);

% Sort eigenvectors in descending order
[lambda,sortinds] = sort(diag(lambda), 'descend');
M = M(:,sortinds);

% Get number of dimensions needed to account for proportion of data
if nPC_or_proportion < 1
    percentvar = cumsum(lambda) ./ sum(lambda);
    num_dim = find(percentvar >= nPC_or_proportion,1,'first');
else
    num_dim = nPC_or_proportion;
end

% Reduce dimension
lambda = lambda(1:num_dim);
M = M(:,1:num_dim);
Xreduced = X * M;

end