function [ ] = plot_pca( S_HighDensity )
%PLOT_PCA Summary of this function goes here
%   Detailed explanation goes here

b{2} = vertcat(S_HighDensity.Xcleaned_compounds(:,2));
b{1} = vertcat(S_HighDensity.Xcleaned_timepoints(:,1));

varLimiter = 1;
new_color = [0,0,0];
Xmncn = nanmean2(S_HighDensity.XX);
Xauto = nanstd(Xmncn);

pca_visualization(Xauto,b,varLimiter,new_color);

end

