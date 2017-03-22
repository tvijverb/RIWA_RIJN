function [ S_HDOD ] = PCAIA_HDOD( Stemp ,S)
%PCAIA_HDOD Summary of this function goes here
%   Detailed explanation goes here

places = length(Stemp);

for place = 1 : places
    disp(['Now at place: ', num2str(place)]);
    [r,c] = size(Stemp(place).X);
    [S_HDOD(place).Xmcx,S_HDOD(place).Xmc] = nanmean2(Stemp(place).X);
    [S_HDOD(place).Xstdx,S_HDOD(place).Xstd,S_HDOD(place).Xkeepo] = nanstd(S_HDOD(place).Xmcx,1);
    S_HDOD(place).Xcleaned_compounds = Stemp(place).Xcleaned_compounds(S_HDOD(place).Xkeepo,:);
    S_HDOD(place).Xcleaned_timepoints = Stemp(place).Xcleaned_timepoints;
    
    S_HDOD(place).X = msvd(S_HDOD(place).Xstdx,4);
    S_HDOD(place).XX = S_HDOD(place).X * diag(S_HDOD(place).Xstd) + repmat(S_HDOD(place).Xmc(S_HDOD(place).Xkeepo),[1,r])';
end

for place = 1 : places
    disp(['Now at place: ', num2str(place)]);
    rows = length(S(place).X);
    notnan = [];
    for row = 1 : rows
            if(S(place).X{row,4} > datenum('01-Jan-2010 00:00:00') && S(place).X{row,4} < datenum('01-Jan-2015 00:00:00') && ismember(S(place).X{row,5},S_HDOD(place).Xcleaned_compounds(:,1)))
                notnan(1,row) = 1;
            else
                notnan(1,row) = 0;
            end
    end
    S_HDOD(place).Xo = S(place).X(logical(notnan),:);
end

end

