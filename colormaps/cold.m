function h = cold(n)
% cold
% Blue counterpart to the hot colormap
% h=cold(n);
if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      n = size(get(groot,'DefaultFigureColormap'),1);
   else
      n = size(f.Colormap,1);
   end
end
h = hot(n);
h = [h(:,3) h(:,2) h(:,1)];
end
    
