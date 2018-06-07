function thesize = sizeof(var, humanflag) %#ok<INUSL>
% Returns the storage size of a given variable
%
% size = sizeof( var , [ human_readable ] );
%
% sizeof(rand(500), true)
% '1.9073 MB'
if nargin<2, humanflag=0; end
varinfo=whos('var');
thesize=varinfo.bytes;
if humanflag
   thesize = bytes2human( thesize );
end
if nargout==0
    disp(thesize);
    clear thesize;
end
end
