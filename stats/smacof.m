function [est_coords,stress] = smacof( known_dists, init_coords , w )
% Solve multidimensional scaling (MDS) problem using the SMACOF algorithm
%
% 
n = size(known_dists,1);

%% Set weighting matrix
if ~exist('w','var') || isempty(w)
    w = ~isnan(known_dists) & ~eye(n);
end

%% Normalize weighting matrix so sum(w .* d^2) = n*(n-1)/2 (is it needed?)
% w = w * (n*(n-1)/2) / sum(w(mask) .* known_dists(mask).^2);

%% Construct matrix V
V = -w;
V(1:n+1:end) = sum(w,2);
iV = pinv(V);

%% Precomute the static part of B(Y)
Vd = V .* known_dists;

%% Setup main loop
max_iter = 1000;
iter = 0;
est_coords = init_coords;
stress = inf;

while (iter < max_iter)
    
    iter = iter + 1;
    
    %% Update stress
    stress_prev = stress;
    est_dists = squareform(pdist(est_coords));
    stress = 0.5 * sum(sum( w .* (est_dists - known_dists).^2 ));

    %% Print info
    if mod(iter,25)==0
        fprintf('Iteration %03i: Current=%g, Delta=%g\n',iter,stress,stress-stress_prev);
    end
    
    %% Check termination condition
    if abs(stress-stress_prev)<10^-12
        break;
    end
    
    %% Contruct matrix B(Y)
    By = Vd./est_dists;
    By(1:n+1:end) = -nansum(By,2);

    %% Solve for new coordinates
    est_coords = iV * By * est_coords;

end

end