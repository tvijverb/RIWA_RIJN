function [ ] = plot_pca( S_HighDensity )
%PLOT_PCA Summary of this function goes here
%   Detailed explanation goes here

b{2} = vertcat(S_HighDensity.Xcleaned_compounds(:,2));
b{1} = vertcat(S_HighDensity.Xcleaned_timepoints(:,1));

varLimiter = 0.15;
new_color = [0,0,0];
Xmncn = nanmean2(S_HighDensity.XXimputed);
Xauto = nanstd(Xmncn);
timeLabels = vertcat(S_HighDensity.Xcleaned_timepoints(:,1));
plot_scr = true;
plot_lds = false;


pca_visualization(Xauto,b,timeLabels,varLimiter,new_color,plot_scr,plot_lds);
close all;
end

