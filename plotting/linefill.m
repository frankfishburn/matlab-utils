function handle = linefill(x,y,c,transparency,hide_edges)
% This function draws a semi-transparent fill between two lines.
% Intended primarily as an alternative to errorbars
% 
% handle = linefill( x, y, [ color, transparency, hide_edges ]);
%
% x: [N x 1] vector of x-axis positions
% y: [N x 2] upper and lower bounds of fill at each point
% color: [1 x 3] RGB values for fill
% transparency: scalar alpha value (0-1)
% hide_edges: True/False indicating whether to draw darker borders
if nargin<5, hide_edges = false; end
if nargin<4, transparency = .5; end
if nargin<3, c = [.6 0 0]; end
if size(x,1)==1
    x = x';
end
if size(y,1)==2
    y = y';
end

if size(x,1)~=size(y,1) || size(x,2)~=1 || size(y,2)~=2
    error('Inputs must be: X = [N x 1] , Y = [N x 2]');
end

badvals = isnan(x) | any(isnan(y),2) | ~isfinite(x) | any(~isfinite(y),2);
x(badvals) = [];
y(badvals,:) = [];

x = [x(:)' fliplr(x(:)')];

ymin = min(y,[],2);
ymax = max(y,[],2);

if hide_edges
    edge_alpha = 0;
else
    edge_alpha = 1;
end
handle = fill(x,[ymax' fliplr(ymin')],c,'EdgeColor',c,'EdgeAlpha',edge_alpha);

alpha(handle,transparency);
if nargout<1, clear handle; end

end
