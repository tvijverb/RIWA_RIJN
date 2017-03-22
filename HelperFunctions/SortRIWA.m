%% Sort Imported RIWA data
% 
% Written by T.G.M. Vijverberg on 14-03-2016 at Radboud University Nijmegen
% Last edited by T.G.M. Vijverberg on 22-07-2016

% Clean up imported excel data from RIWA database

% Samples and variables are both listed row-wise after default MATLAB 
% import, this is corrected by this script

% Property of the OFF/ON Public Private Partnership
% OFF/ON Contact: jj.jansen@science.ru.nl 

% README
%%%%%%%%%%%%%%%%%%%%%%%%%%%INPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Excel database of RIWA

% Import EXCEL to MATLAB using default settings
    % Right-click excel file in MATLAB working directory
    % Select 'Import Data...'
    % Select Import
    
% This script will complain if the EXCEL file was not imported

%%%%%%%%%%%%%%%%%%%%%%%%%%%OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Cleaned RIWA data in MATLAB structure S

% Locations are split from the UnsortedData structure; set as entries 1-5
% in 'S'

% Variables are now listed column-wise, as conventional

% Samples are now listed row-wise, as conventional

% Missing values are listed as NaN in S.Xcleaned

%% Start of the script

% Uncomment this if you want to load data as saved .mat file
%load('UnsortedData.mat');

% Check if the EXCEL sheet data was loaded correctly
% Load variable : date
if(exist('datum') == 1)
    UnsortedData.date = datum;
else
    warning('Variable datum does not exist');
end

% Load variable river
if(exist('stroomgebied_omschrijving') == 1)
    UnsortedData.river = stroomgebied_omschrijving;
else
    warning('Variable stroomgebied_omschrijving does not exist');
end

% Load variable river 2
if(exist('stroomgebiedomschrijving') == 1)
    UnsortedData.river = stroomgebiedomschrijving;
else
    warning('Variable stroomgebied_omschrijving does not exist');
end

% Load variable parametercode
if(exist('par') == 1)
    UnsortedData.parametercode = par;
else
    warning('Variable par does not exist');
end

% Load variable place
if(exist('rappunt_omschrijving') == 1)
    UnsortedData.place = rappunt_omschrijving;
else
    warning('Variable rappunt_omschrijving does not exist');
end

% Load variable place 2
if(exist('rappuntomschrijving') == 1)
    UnsortedData.place = rappuntomschrijving;
else
    warning('Variable datum does not exist');
end

% Load variable parameter
if(exist('naam') == 1)
    UnsortedData.parameter = naam;
else
    warning('Variable naam does not exist');
end

% Load variable casnumber
if(exist('casnummer') == 1)
    UnsortedData.casnumber = casnummer;
else
    warning('Variable casnummer does not exist');
end

% Load variable sign
if(exist('teken') == 1)
    UnsortedData.sign = teken;
else
    warning('Variable teken does not exist');
end

% Load variable unit of measurement
if(exist('dimensie') == 1)
    UnsortedData.dimension = dimensie;
else
    warning('Variable dimensie does not exist');
end

% Load variable place
if(exist('waarde') == 1)
    UnsortedData.value = waarde;
else
    warning('Variable waarde does not exist');
    warning('RTFM, README is at the top of this script');
end


%% Restructure imported data according to measurement location
% List of measurement locations
Locationlist = unique(UnsortedData.place);

% Convert to cell type
UnsortedData.value = num2cell(UnsortedData.value);
UnsortedData.datenum = datenum(UnsortedData.date);
UnsortedData.datenum = num2cell(UnsortedData.datenum);
UnsortedData.date = cellstr(UnsortedData.date);

% Data dump of the original data
UnsortedData.X_unsorted = [UnsortedData.place UnsortedData.river UnsortedData.date UnsortedData.datenum UnsortedData.parametercode UnsortedData.parameter UnsortedData.casnumber UnsortedData.sign UnsortedData.dimension UnsortedData.value];
UnsortedData.variablelist = {'place','river','date','datenum','parametercode','parameter','casnumber','sign','dimension','value'};

% Sort data
for i = 1 : length(Locationlist)
    locationNamecell = Locationlist(i);
    locationName = locationNamecell{1,1};
    index_place = ismember(UnsortedData.place,locationName);
    %UnsortedData.value(index_place);
    S(i).name = locationName;
    S(i).X = UnsortedData.X_unsorted(index_place,:);
    S(i).variablelist = UnsortedData.variablelist;
end

%% Created Xcleaned Database, store data in conventional row x column = sample x variable format

%Loop over all locations
for i = 1 : length(S)
    %Number of unique days and unique parameters in location i
    uniquedays = unique(S(i).X(:,3),'stable');
    uniqueparam = unique(S(i).X(:,5),'stable');
    %Preallocate memory
    S(i).Xcleaned = zeros(length(uniquedays),length(uniqueparam));
    %Loop over unique days
    for j = 1 : length(uniquedays)
        %Get indices of of day j
        index_days = ismember(S(i).X(:,3),uniquedays(j));
        %Loop over unique parameters
        for k = 1 : length(uniqueparam)
            %Get indexed data from day j
            daymat = S(i).X(index_days,:);
            %Get get parameter k from day j
            index_days_params = ismember(S(i).X(index_days,5),uniqueparam(k));
            %Day has no parameters
            if index_days_params == 0
                S(i).Xcleaned(j,k) = NaN;
            %Parameter is empty, NaN, not a day
            elseif(isnan(daymat{1,4}))
                S(i).Xcleaned(j,k) = NaN;
            elseif(isempty(daymat{1,10}))
                S(i).Xcleaned(j,k) = NaN;
            %Parameter is correct => put it in the matrix at day j,
            %parameter k
            else
                S(i).Xcleaned(j,k) = daymat{index_days_params,10};
            end
        end
    end
end

%% List Xcleaned timepoints and variables
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
end
