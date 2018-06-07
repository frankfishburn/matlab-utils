function cmap = hotcoldtrim(n)
% This is the hotcold colormap with the white parts removed
if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      n = size(get(groot,'DefaultFigureColormap'),1);
   else
      n = size(f.Colormap,1);
   end
end
isodd = mod(n,2);
if isodd
    n = n - 1;    
end
h = hottrim(n/2);
c = flipud(coldtrim(n/2));
if isodd
    cmap = [c; 0 0 0; h];
else
    cmap = [c; h];
end
end
