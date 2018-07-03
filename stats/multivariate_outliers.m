function [isoutlier,mahdist] = multivariate_outliers(X,robust,alpha)
% Detect multivariate outliers using leave-one-out or robust Mahalanobis distance
%
% Usage: [isoutlier,mahdist] = multivariate_outliers(X,robust,alpha)
%
% X is an [observation x feature] matrix
% alpha is the threshold based on chi-squared distribution
% isoutlier is a [observation x 1] binary vectory of multivariate outliers
% mahdist is a [observation x 1] vector of Mahalanobis distances
if nargin<2 || isempty(robust)
    robust = false;
end
if nargin<3 || isempty(alpha)
    alpha = .05;
end

[n,p] = size(X);

if robust
    [~,~,mahdist] = robustcov(X);
else
    mahdist = nan(n,1);
    for i=1:n
        mahdist(i) = sqrt(mahal(X(i,:),X(setdiff(1:n,i),:)));
    end
end
thresh = chi2inv(1-alpha,p);
isoutlier = mahdist>thresh;

end
