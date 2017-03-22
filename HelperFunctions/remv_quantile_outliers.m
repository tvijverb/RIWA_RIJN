function [ S_O,percentage_retained_idv,percentage_retained_total] = remv_quantile_outliers(S,Lowerlimit)
%% outlier removal
% Written by Thomas Vijverberg on 26-5-2015 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 10-06-2015

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Input data structure (STRUCT) 'S' with dimension 1 x (total_measurements)
    %Must contain atleast contain:
    %Data input (S.Data)
    %IDs input (S.ID)
    %Labels S.Labels
    
%Input Lowerlimit integer (INT) with dimension 1 x 1
    % Possible values (0 to number_variables)
    % Recommended value 1 to 4
    % Lower values will remove more outliers. eg. less conservative

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Output data structure (STRUCT) 'S_O' with dimension 1 x (total_measurements)
    %Data (S_O.Data)
    %IDs (S_O.ID)
    %Labels (S_O.Labels)
    
%Output retained percentage of cells per individual
    %'percentage_retained_idv' with dimension (number_individuals x 1)
    
%Output retained percentage average 'percentage_retained_total'   
    %with dimension (1 x 1)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calculate 95% quantiles (5% considered outlier) for each ID,variable.
% If cell of individual has ['Lowerlimit'] or more variables considered outlier, it is
% removed. This is done to correct instrumental errors in FACS data.

N_Var = length(S(1).Data(1,:));
N_ID = length(S);
data = vertcat(S.Data)';

for i = 1:N_Var
    y(i,:) = quantile(data(i,:),[0.025 0.25 0.50 0.75 0.975]);
end
S_temp = S;
S_temp2 =S;
S_O = S;
percentage_retained_idv = zeros(N_ID,1);
for j = 1:N_ID
    for i = 1:N_Var
        S_temp(j).Data(:,i)=S(j).Data(:,i) <= y(i,1);
        S_temp2(j).Data(:,i)=S(j).Data(:,i) >= y(i,5);
    end
    S_temp(j).Data2(:,1) = ~((sum(S_temp(j).Data,2)+sum(S_temp2(j).Data,2)) > Lowerlimit);
    S_O(j).Data = S(j).Data(S_temp(j).Data2,:);
    percentage_retained_idv(j) = (length(S_O(j).Data) / length(S(j).Data))*100;
end
    percentage_retained_total = mean(percentage_retained_idv);
end

