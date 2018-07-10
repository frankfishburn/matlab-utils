function [isoutlier,scores] = univariate_outliers(X,robust,cutoff)
% Detect univariate outliers using (optionally robust) Z-score
%
% Usage: [isoutlier,score] = univariate_outliers(X,robust,cutoff)
%
% Inputs:
% X is an [observation x feature] matrix
% robust indicates whether location and scale are robustly estimated via median and MAD
% cutoff is the threshold based on Z distribution
%
% Outputs:
% isoutlier is a [observation x 1] binary vector indicating whether observation contains a univariate outlier
% scores is a [observation x feature] matrix of Z-scores
if nargin<2 || isempty(robust)
    robust = false;
end
if nargin<3 || isempty(cutoff)
    cutoff = 3;
end

if robust
    mu = median(X,1);
    sigma = 1.4826 * mad(X,1,1);
else
    mu = mean(X,1);
    sigma = std(X,0,1);
end

scores = bsxfun(@rdivide,bsxfun(@minus,X,mu),sigma);
isoutlier = any(abs(scores)>cutoff,2);

end