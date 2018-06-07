function cmap = hotcold(n)
% Colormap with hot and cold colors
if nargin < 1, n = size(get(gcf,'colormap'),1); end
if mod(n,2), isodd=1; n=n-1; else isodd=0; end
h = hot(n/2);
c = [h(:,3) h(:,2) h(:,1)];
if isodd
    cmap = [c(end:-1:1,:); 0 0 0; h];
else
    cmap = [c(end:-1:1,:); h];
end

end
