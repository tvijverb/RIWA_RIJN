function [ ] = plot_pca( S_HighDensity )
%PLOT_PCA Summary of this function goes here
%   Detailed explanation goes here

b{2} = vertcat(S_HighDensity.Xcleaned_compounds(:,2));
b{1} = vertcat(S_HighDensity.Xcleaned_timepoints(:,1));

varLimiter = 0.02;
new_color = [0,0,0];
pca_visualization(S_HighDensity.XX,b,varLimiter,new_color);

end

