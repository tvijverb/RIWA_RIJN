%% Created by Thomas Vijverberg on 04-09-2017 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 04-09-2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Runs complete data analysis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
% Load dataset to workspace
% Skips load function if data is already in workspace
if(exist('Slobith') ~= 1)
    load('SLobith.mat');
    Slobith2 = Slobith;
end
if(exist('PNEC') ~= 1)
    load('PNEC.mat');
end
if(exist('parametersenhunparametergroepen') ~= 1)
    load('parametergroups.mat');
end

Slobith = Slobith2;

PNEC = fillPNEC_Table(PNEC);

[ Slobith ] = data_compression( Slobith,parametersenhunparametergroepen );

if(exist('S_HighDensity') ~= 1) %skip this step if we want to avoid long computation times
    [ S_HighDensity ] = data_imputation(Slobith);
end

[ S_HighDensity ] = toxicity_subr( S_HighDensity,PNEC )

plot_pca(S_HighDensity);

plot_true_imputed(S_HighDensity);