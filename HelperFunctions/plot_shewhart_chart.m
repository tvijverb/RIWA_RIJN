function [ ] = plot_shewhart_chart( S_HighDensity_ReducedData )
%PLOT_SHEWHART_CHART Summary of this function goes here
%   Detailed explanation goes here
figure(1);

orange = [1, 0.5, 0];
red = [1, 0, 0];

plot(sum(S_HighDensity_ReducedData.XdevPNECsum_log_avail_compounds_wPNEC'),'LineWidth',6);

x = sum(S_HighDensity_ReducedData.XdevPNECsum_log_avail_compounds_wPNEC');

% Mean
xmean = mean(sum(S_HighDensity_ReducedData.XdevPNECsum_log_avail_compounds_wPNEC'));
xmean = repmat(xmean,2,1);

% Std lines
mstd = std(sum(S_HighDensity_ReducedData.XdevPNECsum_log_avail_compounds_wPNEC'));
sigma_2p = xmean + 2 * mstd;
sigma_2m = xmean - 2 * mstd;
sigma_3p = xmean + 3 * mstd;
sigma_3m = xmean - 3 * mstd;

above_2sig = x > sigma_2p(1);
above_3sig = x > sigma_3p(1);

lengthx = 1 : length(x);

hold on
grid on
ylim = get(gca,'Ylim');
ylim(1) = 0;
ylim(2) = 50;
set(gca,'Ylim',ylim);

% Obtain the tick mark locations
xtick = get(gca,'XTick');
ytick = get(gca,'YTick');
% Obtain the limits of the y axis
ylim = get(gca,'Ylim');
xlim = get(gca,'Xlim');
% Create line data
X = repmat(xtick,2,1);
Y = repmat(ylim',1,size(xtick,2));
X2 = repmat(ytick,2,1);
Y2 = repmat(xlim',1,size(ytick,2));

grid off;
% Plot line data
plot(X(:,2:end),Y(:,2:end),'Color',[0.1, 0.1, 0.1]);
plot(Y2,X2,'Color',[0.1, 0.1, 0.1]);

% Plot mean bar
ymean= [X(1,1), X(1,end)];
plot(ymean,xmean,'--g','LineWidth',6);

% Plot std bar
plot(ymean,sigma_2p,'--','LineWidth',4,'Color',orange);
plot(ymean,sigma_2m,'--','LineWidth',4,'Color',orange);
plot(ymean,sigma_3p,'--','LineWidth',4,'Color',red);
plot(ymean,sigma_3m,'--','LineWidth',4,'Color',red);

% Scatter colormarkers
scatter(lengthx(above_2sig),x(above_2sig),24,'filled','MarkerFaceColor',orange);
scatter(lengthx(above_3sig),x(above_3sig),24,'filled','MarkerFaceColor',red);

yt = get(gca, 'YTick');
set(gca, 'FontSize', 30);
xt = get(gca, 'XTick');
set(gca, 'FontSize', 30);

% Text plotting
thistext = vertcat(S_HighDensity_ReducedData.Xcleaned_timepoints{above_2sig,1});
thistext = thistext(:,1:end-9);
text(lengthx(above_2sig)+1,x(above_2sig)+1,thistext,'FontSize',30);

% Labels
ylabel('Water Quality Index (WQI)','FontSize',40);
xlabel('timepoints','FontSize', 40);
rescalefig1080;
xt = get(gca, 'XTick');

%set(gca,'XTick',(xt(2:end-1)));
%set(gca,'XTickLabels',thistext);
%set(gca,'XTickLabelRotation',45);

fig2plotly(gcf,'strip',false);
close(gcf);

end

