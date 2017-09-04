function [ output_args ] = plot_riwapr( Stemp,S_HDOD )
%PLOT_RIWAPR Summary of this function goes here
%   Detailed explanation goes here

figure

%Plot imputated data
plot(cell2mat(vertcat(Stemp(1).Xcleaned_timepoints(:,2))),S_HDOD(1).XX(:,1),'r');
hold on
scatter(cell2mat(vertcat(Stemp(1).Xcleaned_timepoints(:,2))),S_HDOD(1).XX(:,1),'r');

%Plot original data
plot(cell2mat(vertcat(Stemp(1).Xcleaned_timepoints(:,2))),Stemp(1).X(:,1),'b');
scatter(cell2mat(vertcat(Stemp(1).Xcleaned_timepoints(:,2))),Stemp(1).X(:,1),'b*');

title('Chloride concentration, Andijk, year 2010-2014','FontSize',24,'FontAngle','italic');
xlabel('Date','FontSize',20,'FontAngle','italic');
ylabel('mg/L','FontSize',20,'FontAngle','italic');
set(gca,'Xtick',cell2mat(vertcat(Stemp(1).Xcleaned_timepoints(:,2))),'XTickLabel',cell2mat(vertcat(Stemp(1).Xcleaned_timepoints(:,1))),'XTickLabelRotation',45);

end

