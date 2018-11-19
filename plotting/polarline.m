function polarline(vals,labels,ax)
% An easy wrapper for categorical polar plots
% Usage: polarline(values, labels)
if nargin<3
    f=figure;
    ax=polaraxes(f);
end
x = linspace(0,2*pi,length(vals)+1);
polarplot(ax,x,[vals(:)' vals(1)]);
set(ax,'ThetaAxisUnits','rad','ThetaTick',x,'ThetaTickLabel',labels,'RTickLabel',{});
end
