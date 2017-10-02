function [ S_HighDensity_ReducedData] = toxicity_subr( S_HighDensity_ReducedData,PNEC );
%% Created by Thomas Vijverberg on 04-09-2017 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 04-09-2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs Water Quality Indices


%% Bookkeeping - Matching available compounds in dataset versus compounds with PNEC registered value
disp('Running toxicity_subr - remove values without PNEC - create Water Quality Indices (WQI)');
%Only loop over lobith to decrease computing load
for i = 1:1
    %Match dataset compounds versus compounds /w PNEC
    
    [r,c] = size(S_HighDensity_ReducedData(i).Xcleaned_compounds);
    for j = 1 : r
        S_HighDensity_ReducedData(i).Xcleaned_compounds{j,3} = strcat('#',S_HighDensity_ReducedData(i).Xcleaned_compounds{j,3});
    end
    
    [S_HighDensity_ReducedData(i).avail_compounds,S_HighDensity_ReducedData(i).avail_compounds_ind] = ismember(S_HighDensity_ReducedData(i).Xcleaned_compounds(:,3),PNEC(:,1));
    S_HighDensity_ReducedData(i).avail_compounds_PNEC = num2cell(zeros(length(S_HighDensity_ReducedData(i).avail_compounds),1));
    S_HighDensity_ReducedData(i).avail_compounds_PNEC(S_HighDensity_ReducedData(i).avail_compounds) = PNEC(S_HighDensity_ReducedData(i).avail_compounds_ind(S_HighDensity_ReducedData(i).avail_compounds),3);
    
    %Allocate memory for new matrix
    [row,column] = size(S_HighDensity_ReducedData(i).XXimputed);
    S_HighDensity_ReducedData(i).XdivPNEC = zeros(row,column);
    
    %Insert compounds with available data AND available PNEC into new
    %matrix
    for r = 1 : row
        row_notnan = ~isnan(S_HighDensity_ReducedData(i).XXimputed(r,:));
        row_acceptable_for_PNEC = double(row_notnan).*double(S_HighDensity_ReducedData(i).avail_compounds)';
        if(~isempty(S_HighDensity_ReducedData(i).XXimputed(r,logical(row_acceptable_for_PNEC))))
            %Divide compound concentration by PNEC value
            S_HighDensity_ReducedData(i).XdivPNEC(r,logical(row_acceptable_for_PNEC)) = S_HighDensity_ReducedData(i).XXimputed(r,logical(row_acceptable_for_PNEC))./ ...
            cell2mat(S_HighDensity_ReducedData(i).avail_compounds_PNEC(logical(row_acceptable_for_PNEC)))';
        end
    end
end

%Set unknown compounds to 1
low = S_HighDensity_ReducedData(i).XdivPNEC < 1;
S_HighDensity_ReducedData(i).XdivPNEC(low) = 1;

%Plot sumlog - summation over all compounds - logscale (Not Available
%compounds are set to 0 (log(1) = 0))
figure(1);
XdevPNECsum = sum(log(S_HighDensity_ReducedData.XdivPNEC'));
S_HighDensity_ReducedData(i).XdevPNECsum = S_HighDensity_ReducedData.XdivPNEC;
plot(XdevPNECsum);

%figure(2);
%XdevPNECsum_avail_compounds_wPNEC = sum(log(S_HighDensity_ReducedData.XdivPNEC(:,S_HighDensity_ReducedData.avail_compounds)'));
S_HighDensity_ReducedData(i).XdevPNECsum_avail_compounds_wPNEC = S_HighDensity_ReducedData.XdivPNEC(:,S_HighDensity_ReducedData.avail_compounds);
%plot(XdevPNECsum_avail_compounds_wPNEC);

end

