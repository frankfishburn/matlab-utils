function cmap = coldtrim(n)
% This is the cold colormap with white part removed
if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      n = size(get(groot,'DefaultFigureColormap'),1);
   else
      n = size(f.Colormap,1);
   end
end
cmap = hottrim(n);
cmap = fliplr(cmap);
end
