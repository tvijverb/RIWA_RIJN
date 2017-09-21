function [ S_HighDensity_ReducedData ] = data_filter( Stemp ,S)
%% Created by Thomas Vijverberg on 04-09-2017 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 04-09-2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filter data to reduce missing values

% Rows(measuring timepoints) are removed according to:
mindate = '01-Jan-2010 00:00:00';
maxdate = '01-Jan-2015 00:00:00';

% Columns (compounds)High density Already filtered in Compressed_Data.m

% Compounds with missing PNEC value are removed in 'toxicity_subr.m'

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Running data_filter - Replace missing values PNEC');

places = length(Stemp);

disp('Meancenter and autoscale for all locations:');
for place = 1 : places
    disp(['Meancenter and autoscale at: ', num2str(place), ' of ',num2str(places),'.']);
    [r,c] = size(Stemp(place).X);
    [S_HighDensity_ReducedData(place).XmeancenteredData,S_HighDensity_ReducedData(place).XmeancenteredColumns] = nanmean2(Stemp(place).X);
    [S_HighDensity_ReducedData(place).Xstdx,S_HighDensity_ReducedData(place).Xstd,S_HighDensity_ReducedData(place).Xkeepo] = nanstd(S_HighDensity_ReducedData(place).XmeancenteredData,1);
    S_HighDensity_ReducedData(place).Xcleaned_compounds = Stemp(place).Xcleaned_compounds(S_HighDensity_ReducedData(place).Xkeepo,:);
    S_HighDensity_ReducedData(place).Xcleaned_timepoints = Stemp(place).Xcleaned_timepoints;
    
    % Imputation Algorithm over meancentered data - limitation of PCA
    % method
    S_HighDensity_ReducedData(place).X = msvd(S_HighDensity_ReducedData(place).Xstdx,4);
    
    % Set imputed data back to original space (meancentered * std) + column
    % mean
    S_HighDensity_ReducedData(place).XX = S_HighDensity_ReducedData(place).X * diag(S_HighDensity_ReducedData(place).Xstd) + repmat(S_HighDensity_ReducedData(place).XmeancenteredColumns(S_HighDensity_ReducedData(place).Xkeepo),[1,r])';
end

disp('Removing timepoints outside "mindate" and "maxdate". ');
for place = 1 : places
    disp(['Removing timepoints at: ', num2str(place), ' of ',num2str(places),'.']);
    rows = length(S(place).X);
    notnan = [];
    for row = 1 : rows
            if(S(place).X{row,4} > datenum(mindate) && S(place).X{row,4} < datenum(maxdate) && ismember(S(place).X{row,5},S_HighDensity_ReducedData(place).Xcleaned_compounds(:,1)))
                notnan(1,row) = 1;
            else
                notnan(1,row) = 0;
            end
    end
    S_HighDensity_ReducedData(place).Xo = S(place).X(logical(notnan),:);
end

end

