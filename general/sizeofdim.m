function thesize = sizeofdim(dim, humanflag)
% Returns the storage size of a hypothetical variable with specified
% dimensions
%
% size = sizeofdim( dims , [ human_readable ] );
%
% sizeofdim( [100 100 3] , true );
% '234.375 KB'
if nargin<2, humanflag=0; end
thesize = prod(dim) * sizeof(1);
if humanflag
   thesize = bytes2human( thesize );
end
if nargout==0
    disp(thesize);
    clear thesize;
end
end
