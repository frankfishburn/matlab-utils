function z = nanzscore( data , flag , dim , robust )
% Same as builtin zscore() function but ignores NaN values
%
% z = nanzscore( data, [flag], [dim], [robust] );
if nargin<2 || isempty(flag), flag = 0; end
if nargin<3 || isempty(dim), dim = 1; end
if nargin<4 || isempty(robust), robust = 0; end

if robust
    mu = nanmedian(data,dim);
    sigma = 1.4826 * mad(data,1,dim);
else
    mu = nanmean(data,dim);
    sigma = nanstd(data,flag,dim);
end

z = (data-mu)./sigma;

end