function [Xwh,W] = whiten_data( X , method )
% Whiten data using one of several methods
% 
% [Xwh,W] = whiten_data( X , method )
%
% Inputs:  X      - Input data, a [ #observations x #features ] matrix
%          method - Whitening procedure to use ('ZCA', 'PCA', 'Cholesky', 'ZCA-cor', 'PCA-cor')
%
% Outputs: Xwh    - Whitened data, a [ #observations x #features ] matrix
%          W      - The whitening matrix, [ #features x #features ] matrix
%
% Methods:
%   ZCA     Maximizes the average covariance between original and whitened components
%   ZCA-cor Maximuzes the average correlation between original and whitened components
%   PCA     Maximizes the compression of elements based on covariance
%   PCA-cor Maximizes the compression of elements based on correlation
%
% Note that the whitened output will be shifted and scaled from the input. If this is
%   undesirable, you should standardize before and unstandardize afterward, see also DECORRELATE
%
% Kessy, A., Lewin, A., Strimmer, K. (2015). "Optimal whitening and decorrelation". 
% The American Statistician. arXiv:1512.00809. doi:10.1080/00031305.2016.1277159
assert(any(strcmpi({'ZCA','PCA','cholesky','chol','ZCA-cor','PCA-cor'},method)),sprintf('Unrecognized method: %s',method));

if size(X,2)>size(X,1)
    warning('Matrix is wide, result may not be valid');
end

if strcmpi(method,'ZCA') || strcmpi(method,'PCA')
    
    S = cov(X);
    [U,lambda]=eig(S);
    lambda = flipud(diag(lambda));
    U = fliplr(U);
    
    % remove zero eigenvalues
    badeig = (lambda<=0);
    lambda(badeig) = [];
    U(:,badeig) = [];
        
    % fix sign ambiguity in eigenvectors by making U positive diagonal
    U = bsxfun( @times , U , sign(diag(U))' );
    
    W = diag(1./sqrt(lambda)) * U';
    
    if strcmpi(method,'ZCA')
        W = U * W;
    end
    
end

if strcmpi(method,'cholesky') || strcmpi(method,'chol')
    
    S = cov(X);
    iS = inv(S);
    W = chol(iS);
    
end

if strcmpi(method,'ZCA-cor') || strcmpi(method,'PCA-cor')
    
    v = var(X);
    R = corrcoef(X);
    [G,theta] = eig(R);
    theta = flipud(diag(theta));
    G = fliplr(G);
    
    % fix sign ambiguity in eigenvectors by making U positive diagonal
    G = bsxfun( @times , G , sign(diag(G))' );
    
    W = diag(1./sqrt(theta)) * G' * diag(1./sqrt(v));
    
    if strcmpi(method,'ZCA-cor')
        W = G * W;
    end
    
end

W = W';
Xwh = X * W;

end
