% Load dataset to workspace

disp('');
if(exist('StempLobith') ~= 1)
    load('StempLobith.mat');
end
if(exist('Slobith') ~= 1)
    load('SLobith.mat');
end
if(exist('PNEC') ~= 1)
    load('PNEC.mat');
end
PNEC = fillPNEC_Table(PNEC);
[ S_HighDensity ] = data_filter( StempLobith ,Slobith);
[ S_HDODtox ] = toxicity_subr( S_HighDensity,PNEC );