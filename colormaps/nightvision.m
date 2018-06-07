function h = nightvision( m )
% Nightvision colormap
%
% nightvision( m )
if nargin < 1
   f = get(groot,'CurrentFigure');
   if isempty(f)
      m = size(get(groot,'DefaultFigureColormap'),1);
   else
      m = size(f.Colormap,1);
   end
end
n = round(m/3);
q = m - 2*n;
r = [  zeros(n,1);  (1:q)'/q;           ones(n,1)   ];
g = [  zeros(n,1);  zeros(q,1);         (1:n)'/n    ];
b = [  (1:n)'/n;    ((q-1):-1:0)'/q;    zeros(n,1)  ];
h = [r g b];
end