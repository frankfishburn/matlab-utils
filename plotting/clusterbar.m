function clusterbar( data , names , clusters , horizontal )
% Draw clustered bar graphs with errorbars 
% clusterbar( data , names , clusters , horizontal )
if nargin<4, horizontal = false; end
if nargin<3, clusters = ones(size(data,1),1); end
if nargin<2, names = cell(size(data,2),1); end

uclust = unique(clusters);
nclust = length(uclust);
nfeat = size(data,2);

% Extract cluster means and standard errors
means = nan(nfeat,nclust);
stderrs = nan(nfeat,nclust);
for i = 1:nclust
    idx = uclust(i);
    means(:,i) = mean(data(clusters==idx,:));
    stderrs(:,i) = std(data(clusters==idx,:)) / sqrt(sum(clusters==idx));
end

width = 1/(nclust+2);
xshift = linspace(-.5+width/2, .5-width/2,nclust+2);
xshift = xshift(2:end-1);

figure;
for i = 1:nclust
    
    if horizontal
        barh((1:nfeat)+xshift(i),means(:,i),width);
        hold on;
        errorbar(means(:,i),(1:nfeat)+xshift(i),stderrs(:,i),'horizontal', 'LineStyle','none','color','k','linewidth',1.5);
    else
        bar((1:nfeat)+xshift(i),means(:,i),width);
        hold on;
        errorbar((1:nfeat)+xshift(i),means(:,i),stderrs(:,i), 'LineStyle','none','color','k','linewidth',1.5);
    end
end

if horizontal
    set(gca,'YTick',1:nfeat,'YTickLabel',names,'YLim',[.5 nfeat+.5],'ydir','reverse');
else
    set(gca,'XTick',1:nfeat,'XTickLabel',names,'XLim',[.5 nfeat+.5]);
end

end
