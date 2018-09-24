function z = nanzscore( data , flag , dim )
% Same as builtin zscore() function but ignores NaN values
%
% z = nanzscore( data, [flag], [dim] );
if nargin<2 || isempty(flag), flag = 0; end
if nargin<3 || isempty(dim), dim = 1; end

z = bsxfun( @rdivide , bsxfun( @minus , data , nanmean(data,dim) ) , nanstd(data,flag,dim) );

end