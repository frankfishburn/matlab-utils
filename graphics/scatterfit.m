function [fig,ax,model] = scatterfit( xdata , ydata , weights , robust , modelspec )
% Create a scatterplot with weighted/robust regression fit and confidence
% bounds
%
% [fig,ax,model] = scatterfit( xdata , ydata , [ weights , robust , modelspec ] );
if nargin<5
    modelspec = 'linear';
end
if nargin<4
    robust = false;
end
if nargin<3 || isempty(weights)
    weights = ones(size(ydata));
end

%% Set visual properties
color_intercept = [0 0 0];
color_scatter = [.3 .6 1.0];
color_fit = [.1 .4 .8];
color_ci = [.3 .7 .3];
alpha_scatter = 1;
font_size = 12;

%% Normalize weights so mean is 1
weights = weights ./ mean(weights);

%% Remove NaN observations
bad = isnan(xdata) | isnan(ydata) | isnan(weights);
xdata(bad,:)=[];
ydata(bad,:)=[];
weights(bad,:)=[];

%% Determine axis limits
xmin = min(xdata); xmax = max(xdata);
ymin = min(ydata); ymax = max(ydata);
xunit = 10^floor(log10(xmax-xmin));
yunit = 10^floor(log10(ymax-ymin));
xlim = [floor(xmin/xunit) ceil(xmax/xunit)] * xunit;
ylim = [floor(ymin/yunit) ceil(ymax/yunit)] * yunit;
assert(all(xdata>xlim(1)) && all(xdata<xlim(2)) && all(ydata>ylim(1)) && all(ydata<ylim(2)),'Data falls outside of axis limits!');

%% Center x-data in case quadratic predictor
mu = nanmean(xdata);

%% Estimate regression model
mdl = fitlm( xdata-mu , ydata ,modelspec,'Weights',weights,'RobustOpts',robust);
xfit = linspace(xmin, xmax,1000)';
xci = linspace(xlim(1), xlim(2),1000)';
[yfit] = mdl.predict(xfit-mu);
[~,yci] = mdl.predict(xci-mu);
if robust
    weights = weights .* mdl.Robust.Weights;
end

%% Create figure
f = figure('renderer','painters','PaperPositionMode','auto','Position',[250 220 580 440]);
h = axes('Parent',f,'Linewidth',1.5,'FontSize',font_size,'FontName','Arial');
box(h,'off');
hold(h,'on');

%% Draw intercept
plot(h,xlim,[0 0],'-','Color',color_intercept,'LineWidth',1.5);

%% Draw prediction confidence interval
fill(h,[xci; flipud(xci)],[yci(:,1); flipud(yci(:,2))], color_ci,'FaceAlpha',.5,'EdgeAlpha',0);

%% Draw line of best fit
plot(h,xfit,yfit,'Color',color_fit,'LineWidth',1.5);

%% Draw data points
scatter(h,xdata,ydata,'LineWidth',.5,'MarkerFaceColor',color_scatter,'MarkerEdgeColor',[0 0 0],'SizeData',max(round(weights*30),1),'MarkerFaceAlpha',alpha_scatter);

%% Bring axes to top
set(h,'Layer','top','XLim',xlim,'YLim',ylim,'XTick',xlim(1):xunit:xlim(2),'YTick',ylim(1):yunit:ylim(2));

%% Print correlation value
r = sign(mdl.Coefficients.Estimate(end)) * sqrt(mdl.Rsquared.Ordinary);
df = length(ydata) - 2;
t = r .* sqrt(df ./ (1 - r.^2));
p = 2*tcdf(-abs(t),df);
fprintf('r(%i) = %4.4f, p < %4.4f\n',df,r,p);

%% Export handles and model
if nargout>2
    model = mdl;
end
if nargout>1
    ax = h;
end
if nargout>0
    fig = f;
end

end