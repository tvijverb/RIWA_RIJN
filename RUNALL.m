% Load dataset to workspace
if(exist('StempLobith') ~= 1)
    load('StempLobith.mat');
end
if(exist('Slobith') ~= 1)
    load('SLobith.mat');
end
if(exist('PNEC') ~= 1)
    load('PNEC.mat');
end
PNEC = fix_PNEC(PNEC);
[ S_HDOD ] = PCAIA_HDOD( StempLobith ,Slobith);
[ S_HDODtox ] = toxicity_subr( S_HDOD,PNEC );