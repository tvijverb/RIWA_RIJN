function [ S ] = RIWA_show_row_column_names( S )
%% Created by Thomas Vijverberg on 23-05-2016 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 23-05-2016

% This script adds row & column names to the matlab variable 'S' from the
% RIWA dataset.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Load 'S.mat' into the matlab workspace

% Run this script with the following command: '[ S ] =
% RIWA_show_row_column_names( S );'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Two columns are added for each entity in matlab variable 'S' from the
% RIWA dataset.

%   1. Row variable: measurement timepoint of S(entity).Xcleaned
%   2. Column variable: measurement chemical compound of S(entity).Xcleaned

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% Start of the script

place = 1;
[meas, var] = size(S(place).Xcleaned);

S(1).X = S(1).X(~isnan(cell2mat(S(1).X(:,4))),:);
rownotnan = zeros(meas,1);
for i = 1:meas
rownotnan(i) = sum(isnan(S(1).Xcleaned(i,:)));
end
S(1).Xcleaned = S(1).Xcleaned(~(rownotnan == var),:);
%Number of entities
places = length(S);

% Loop over all entities
for place = 1 : places
    % Get Xcleaned timepoints from original data
    [S(place).Xcleaned_timepoints , timepoints_index] = unique(vertcat(S(place).X(:,3)),'stable');
    
    S(place).Xcleaned_timepoints(:,2) = num2cell(datenum(S(place).Xcleaned_timepoints(:,1)));
    
    % Get Xcleaned chemical compound code from original data
    [S(place).Xcleaned_compounds , compounds_index] = unique(vertcat(S(place).X(:,5)),'stable');
    
    % Get Xcleaned chemical compound name from original data
    S(place).Xcleaned_compounds(:,2) = vertcat(S(place).X(compounds_index,6));
    
    % Get Xcleaned chemical compound CAS number from original data
    S(place).Xcleaned_compounds(:,3) = vertcat(S(place).X(compounds_index,7));
end
end

