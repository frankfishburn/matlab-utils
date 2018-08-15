function coords = mds(dists,ndim)
% Classical multidimensional scaling
%
% coords = mds(dists,ndim)
N = size(dists,1);

assert(issymmetric(dists),'Distance matrix must be symmetric');
assert(ndim<=N,'# of dimensions must be less than number of objects');

%% Apply double-centering to squared distance matrix
% Canonical method
% C = eye(N) - 1/N * ones(N);
% M = -(1/2) * C * dists.^2 * C;

% More efficient double-centering
dists = dists.^2;
mu = mean(dists);
M = -(1/2) * ( bsxfun(@minus,bsxfun(@minus,dists,mu),mu') + sum(dists(:))/N^2);

%% Eigenvalue decomposition
[V,D] = eigs(M,ndim);

%% Coordinates
coords = V*sqrt(D);

end