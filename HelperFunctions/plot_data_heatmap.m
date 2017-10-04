function [ ] = plot_data_heatmap( S )
%PLOT_DATA_HEATMAP Summary of this function goes here
%   Detailed explanation goes here
fig = figure(3);

[r,c] = size(S(1).Ximputed);

imagesc((S(1).Ximputed'));

set(gca,'YDir','normal')

ylabel('Chemicals (var)','FontSize',40)
xlabel('Timepoints','FontSize',40)

yt = get(gca, 'YTick');
set(gca, 'FontSize', 30);
xt = get(gca, 'XTick');
set(gca, 'FontSize', 30);

rescalefig1080;
fig2plotly(gcf,'strip',false,'showscale',false,'showlegend',false);
close(gcf);
end

