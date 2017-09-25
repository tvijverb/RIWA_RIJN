function [ ] = plot_true_imputed( S_HighDensity )
%% Created by Thomas Vijverberg on 25-09-2017 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 25-09-2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot true values over imputed graph

% Which columns do you want in the plot:
rowsToPlot = [3 5 7];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(2);
[r,c] = size(S_HighDensity.XXnotimputed);

xval = 1 : r;
hold on;

sum_mi = 0;
for i = 1 : length(rowsToPlot)
    plot(S_HighDensity.XXimputed(:,rowsToPlot(i)));
    
    notnanData = ~isnan(S_HighDensity.XXnotimputed(:,rowsToPlot(i)));
    thisX = xval(notnanData);
    thisY = S_HighDensity.XXnotimputed(notnanData,rowsToPlot(i));
    scatter(thisX,thisY);
    sum_mi = sum_mi + sum(~notnanData);
end

disp(['Number of missings: ', num2str(sum_mi), ' .This is ', num2str(sum_mi/(r*length(rowsToPlot))*100) '% of the data.'])

title('Lobith 2010-2015')
xlabel('timepoints');
ylabel('concentration ug/L')

%% legend preparation
legendCellMatrix = repmat(S_HighDensity.Xcleaned_compounds(rowsToPlot,2),1,2);
[lCM_rows,lCM_columns] = size(legendCellMatrix);

for i = 1 : lCM_rows
   legendCellMatrix(i,2) = strcat('true val-',legendCellMatrix(i,2));
end

legendCellMatrix = reshape(legendCellMatrix.',[2 * lCM_rows,1]).';

legend(legendCellMatrix');
end

