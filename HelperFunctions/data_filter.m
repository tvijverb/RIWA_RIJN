function [ S_HDOD ] = data_filter( Stemp ,S)
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
    [S_HDOD(place).Xmcx,S_HDOD(place).Xmc] = nanmean2(Stemp(place).X);
    [S_HDOD(place).Xstdx,S_HDOD(place).Xstd,S_HDOD(place).Xkeepo] = nanstd(S_HDOD(place).Xmcx,1);
    S_HDOD(place).Xcleaned_compounds = Stemp(place).Xcleaned_compounds(S_HDOD(place).Xkeepo,:);
    S_HDOD(place).Xcleaned_timepoints = Stemp(place).Xcleaned_timepoints;
    
    S_HDOD(place).X = msvd(S_HDOD(place).Xstdx,4);
    S_HDOD(place).XX = S_HDOD(place).X * diag(S_HDOD(place).Xstd) + repmat(S_HDOD(place).Xmc(S_HDOD(place).Xkeepo),[1,r])';
end

disp('Removing timepoints outside "mindate" and "maxdate". ');
for place = 1 : places
    disp(['Removing timepoints at: ', num2str(place), ' of ',num2str(places),'.']);
    rows = length(S(place).X);
    notnan = [];
    for row = 1 : rows
            if(S(place).X{row,4} > datenum(mindate) && S(place).X{row,4} < datenum(maxdate) && ismember(S(place).X{row,5},S_HDOD(place).Xcleaned_compounds(:,1)))
                notnan(1,row) = 1;
            else
                notnan(1,row) = 0;
            end
    end
    S_HDOD(place).Xo = S(place).X(logical(notnan),:);
end

end

