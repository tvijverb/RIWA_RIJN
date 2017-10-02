function [ ] = draw_missings_heatmap( S )
%DRAW_MISSINGS Summary of this function goes here
%   Detailed explanation goes here
fig = figure(3);

[r,c] = size(S(1).XXnotimputed);

matrix = zeros(r,c);

for i = 1 : r
    for j = 1 : c
        if(~isnan(S(1).XXnotimputed(i,j)))
            matrix(i,j) = 1;
        end
    end
end

imagesc((1-matrix'));

set(gca,'YDir','normal')


layout = struct(...
    'title', 'Global Font', ...
    'font', struct(...
      'family', 'Courier New, monospace', ...
      'size', 40, ...
      'color', '#7f7f7f'));
  
  

ylabel('Chemicals (var)','FontSize',40)
xlabel('Timepoints','FontSize',40)

yt = get(gca, 'YTick');
set(gca, 'FontSize', 30);
xt = get(gca, 'XTick');
set(gca, 'FontSize', 30);

rescalefig1080;
fig2plotly(gcf,'strip',false,'showscale',false,'showlegend',false);
%imagesc(1-matrix);

datapoints = r * c;
havepoints = sum(sum(matrix));
havenotpoints = datapoints-havepoints;

disp(['We have', num2str(havepoints),' of ', num2str(datapoints), 'which is ', num2str(havepoints/datapoints*100),'% of the data.' ])

end

