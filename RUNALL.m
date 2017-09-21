%% Created by Thomas Vijverberg on 04-09-2017 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 04-09-2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Runs complete data analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Load dataset to workspace
% Skips load function if data is already in workspace
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

if(exist('S_HighDensity') ~= 1) %skip this step if we want to avoid long computation times
    [ S_HighDensity ] = data_filter( StempLobith ,Slobith);
end

[ S_HighDensity ] = toxicity_subr( S_HighDensity,PNEC );