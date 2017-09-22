function [ S ] = data_compression( S,parametersenhunparametergroepen )
%COMPRESSED_DATA Summary of this function goes here
%   Detailed explanation goes here
min_number_of_p_values = 100;
min_number_of_r_values = 100;


places = length(S);
for place = 1 : places
    rows = [];
    columns = [];
    notnan = [];
    notnan2 = [];
    [rows,columns] = size(S(place).Xcleaned);
    
    % Variables to keep
    for column = 1 : columns
        notnan(column) = sum(~isnan(S(place).Xcleaned(:,column)));
    end
    notnan = notnan > min_number_of_p_values;
    
    % Measurements to keep
    for row = 1 : rows
        notnan2(row) = sum(~isnan(S(place).Xcleaned(row,:)));
    end
    
    
    % Keep measurements after 2010
    notnan2 = notnan2 > min_number_of_r_values;
    
    notnan3 = zeros(1,rows);
    for row = 1 : rows
        if(S(place).Xcleaned_timepoints{row,2} > datenum('01-Jan-2010 00:00:00') && S(place).Xcleaned_timepoints{row,2} < datenum('01-Jan-2015 00:00:00'))
            notnan3(1,row) = 1;
        end
    end
    notnan3 = logical(notnan3);
    
   % Combine both row (measurement) arguments
    notnan4 = notnan2 .* notnan3;
    notnan4 = logical(notnan4);

    % Copy data
    S(place).X = S(place).Xcleaned(notnan4,notnan);
    
    % Copy measurement metadata
    S(place).Xcleaned_timepoints = S(place).Xcleaned_timepoints(notnan4,:);
 
    % Copy variables metadata
    S(place).Xcleaned_compounds = S(place).Xcleaned_compounds(notnan,:);

    % Last check
    num_meas = sum(~isnan(S(place).X));
    num_meas = num_meas > 10;
    S(place).X = S(place).X(:,num_meas);
    S(place).Xcleaned_compounds = S(place).Xcleaned_compounds(num_meas,:);
    [~,i] = ismember(S(place).Xcleaned_compounds(:,1),parametersenhunparametergroepen(:,1));
    S(place).Xcleaned_compounds(:,4) = parametersenhunparametergroepen(i,4);
    %[V,N,X] = unique(SLobith.Xcleaned_compounds(:,4));
    %V(:,2) = num2cell(histc(X,1:length(N)));
    %S(place).Xpcaia = knnW3timeLag(S(place).X,20,4,6);
end

end

