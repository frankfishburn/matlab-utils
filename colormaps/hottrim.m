function cmap = hottrim(n)
% This is the hot colormap with white part removed
if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      n = size(get(groot,'DefaultFigureColormap'),1);
   else
      n = size(f.Colormap,1);
   end
end
cmap = zeros(n,3);
h = floor(n/2);
cmap(1:h,1) = linspace(0,1,h);
cmap(h+1:n,1) = 1;
cmap(h+1:end,2) = linspace(0,1,n-h);
end
