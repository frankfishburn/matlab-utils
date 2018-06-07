function [fig, ax1, ax2] = imagecorr( values , varargin )
% Draw correlation image
%
% Usage:    [fig, ax1, ax2] = imagecorr( values , varargin )
%
% Inputs:   values (req) - [N x N] - matrix of numeric values
%
%           labels     - [N x 1] cell array of labels or [N x 2] X and Y-axis labels
%           clim       - [min max] color limits
%           cmap       - colormap
%           clabel     - colorbar label

%% Parse inputs
N = size(values,1);
default_labels = cell(N,2);
default_clim = [-1 1] * max(abs(values(:)));
default_cmap = jet(1000);
default_clabel = 'Correlation';

p = inputParser;
addParameter(p,'labels',default_labels,@iscell);
addParameter(p,'clim',default_clim,@isnumeric);
addParameter(p,'cmap',default_cmap,@isnumeric);
addParameter(p,'clabel',default_clabel,@isstr);
parse(p,varargin{:});

labels = p.Results.labels;
clim = p.Results.clim;
cmap = p.Results.cmap;
clabel = p.Results.clabel;

%% Check inputs
if size(labels,1)==1 && size(labels,2)==N
    labels = labels';
end
if size(labels,1)==2 && size(labels,2)==N && N>2
    labels = labels';
end
if size(labels,2)==1
    labels(:,2) = labels(:,1);
end

mask = tril(true(N),-1);

%% Create figure
fig = figure('PaperPositionMode','Auto','Renderer','Painters','Color',[1 1 1]);
ax1 = axes(fig);
ax2 = axes(fig);

%% Draw the masked correlation matrix
imagesc(values,'parent',ax1,'AlphaData',mask);

set(ax1,'Box','off', 'DataAspectRatio',[1 1 1], 'xlim',[0.5 N-.5], 'ylim',[1.5 N+.5], ...
    'clim',clim, 'xtick',1:N, 'ytick',1:N, 'TickLength',[0 0], ...
    'xticklabel',labels(:,1), 'yticklabel',labels(:,2), 'XTickLabelRotation',45);

%% Add colorbar and updates labels so size is finalized
colormap(ax1,cmap);
b = colorbar(ax1);
ylabel(b,clabel);
title(' ')
xlabel(' ')
ylabel(' ')

%% Draw grid on top separating the correlation values
linkprop([ax1 ax2],{'Position','CLim'});
imagesc(nan(size(values)),'parent',ax2,'AlphaData',zeros(N));

set(ax2,'Box','off', 'DataAspectRatio',[1 1 1], 'xlim',[0.5 N-.5], 'ylim',[1.5 N+.5], ...
    'clim',clim, 'xticklabel',{}, 'yticklabel',{}, 'Color','none', 'XTick',.5:N+.5, 'YTick',.5:N+.5, ...
    'XGrid','on', 'YGrid','on', 'GridAlpha',1, 'LineWidth',1.5, 'XColor','w', 'YColor','w');

if nargout==0
    clear fig ax1 ax2;
end

end