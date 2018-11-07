function polarline(vals,labels)
% An easy wrapper for categorical polar plots
% Usage: polarline(values, labels)
x = linspace(0,2*pi,length(vals)+1);
f=figure;
ax=polaraxes(f);
polarplot(ax,x,[vals(:)' vals(1)]);
set(ax,'ThetaAxisUnits','rad','ThetaTick',x,'ThetaTickLabel',labels);

end
