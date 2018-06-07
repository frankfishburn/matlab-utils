function u = betterjet(m)
% The default Matlab 'jet' colormap has blackish-red
% and blackish-blue at each end of the spectrum.
% This version has pure red and pure blue at each end 
% to be more intuitive.
if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      m = size(get(groot,'DefaultFigureColormap'),1);
   else
      m = size(f.Colormap,1);
   end
end
n = ceil(m/3)+1;
v=[(n-1:-1:1)/n];

nullblock = zeros(1,ceil((m-n)/2));
fullblock =  ones(1,m-(length(nullblock)+n)+1);

r = [nullblock v(end:-1:1)  fullblock];
b = [fullblock v            nullblock];
g = ones(m,1);
g(1:n-1)=v(end:-1:1);
g(m-n+2:end)=v;

u(:,1) = r;
u(:,2) = g;
u(:,3) = b;

end