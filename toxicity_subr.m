function [ S_HDODtox ] = toxicity_subr( S_HDOD,PNEC );
%% Created by Thomas Vijverberg on 04-09-2017 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 04-09-2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs Water Quality Indices


%% Bookkeeping - Matching available compounds in dataset versus compounds with PNEC registered value
disp('Running toxicity_subr - remove values without PNEC - create Water Quality Indices (WQI)');
%Only loop over lobith to decrease computing load
for i = 1:1
    %Match dataset compounds versus compounds /w PNEC
    [S_HDOD(i).avail_compounds,S_HDOD(i).avail_compounds_ind] = ismember(S_HDOD(i).Xcleaned_compounds(:,3),PNEC(:,1));
    S_HDOD(i).avail_compounds_PNEC = num2cell(zeros(length(S_HDOD(i).avail_compounds),1));
    S_HDOD(i).avail_compounds_PNEC(S_HDOD(i).avail_compounds) = PNEC(S_HDOD(i).avail_compounds_ind(S_HDOD(i).avail_compounds),3);
    
    %Allocate memory for new matrix
    [row,column] = size(S_HDOD(i).XX);
    S_HDOD(i).XdivPNEC = zeros(row,column);
    
    %Insert compounds with available data AND available PNEC into new
    %matrix
    for r = 1 : row
        row_notnan = ~isnan(S_HDOD(i).XX(r,:));
        row_acceptable_for_PNEC = double(row_notnan).*double(S_HDOD(i).avail_compounds)';
        if(~isempty(S_HDOD(i).XX(r,logical(row_acceptable_for_PNEC))))
            %Divide compound concentration by PNEC value
            S_HDOD(i).XdivPNEC(r,logical(row_acceptable_for_PNEC)) = S_HDOD(i).XX(r,logical(row_acceptable_for_PNEC))./ cell2mat(S_HDOD(i).avail_compounds_PNEC(logical(row_acceptable_for_PNEC)))';
        end
    end
end

%Set unknown compounds to 1
low = S_HDOD(i).XdivPNEC < 1;
S_HDOD(i).XdivPNEC(low) = 1;

%Give dataset new name for saving purposes
S_HDODtox = S_HDOD;

%Plot sumlog - summation over all compounds - logscale (Not Available
%compounds are set to 0 (log(1) = 0))
XdevPNECsum = sum(log(S_HDODtox.XdivPNEC'));
plot(XdevPNECsum);

end

