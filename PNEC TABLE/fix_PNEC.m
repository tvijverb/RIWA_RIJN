function [ PNEC ] = fix_PNEC( PNEC )
%% Created by Thomas Vijverberg on 31-08-2016 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 31-08-2016

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fixed PNEC values by row
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

len_PNEC = length(PNEC);

% Iterate over all PNEC rows
for len_iter_PNEC = 1 : len_PNEC
    % Get temporary values from non-empty rows
    if ~isempty(PNEC{len_iter_PNEC,1})
        temp_Filler_CAS = PNEC{len_iter_PNEC,1};
        temp_Filler_SUBS = PNEC{len_iter_PNEC,2};
        temp_Filler_SelPNEC = PNEC{len_iter_PNEC,3};
        temp_Filler_SourcePNEC = PNEC{len_iter_PNEC,4};
        temp_Unit = PNEC{len_iter_PNEC,8};
        
        % If nextrow is empty, replace with temporary values
    elseif (isempty(PNEC{len_iter_PNEC,1}) && strcmp(PNEC{len_iter_PNEC,8},temp_Unit))
        PNEC{len_iter_PNEC,1} = temp_Filler_CAS;
        PNEC{len_iter_PNEC,2} = temp_Filler_SUBS;
        PNEC{len_iter_PNEC,3} = temp_Filler_SelPNEC;
        PNEC{len_iter_PNEC,4} = temp_Filler_SourcePNEC;
    end
end

end

