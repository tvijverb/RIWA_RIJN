%% Measurements carbapara 2008 to 2012
%% Created by Thomas Vijverberg on 20-03-2016 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 31-03-2016

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input data structure (STRUCT) 'S' with dimension 1 x 5
    %Must contain atleast contain 5 measurement places
    %Data input (S.Data)
    %IDs input (S.ID)
    %Labels S.Labels

%Point of measurement 'place' 
    % 1:Rhine,Andijk
    % 2:Meuse, Eijsden
    % 3:Meuse, Heel
    % 4:Meuse, Keizersveer
    % 5:Rhine, Lobith
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% Start of the script    
place = 5;
[meas, var] = size(S(place).Xcleaned);

% S(5).X = S(5).X(~isnan(cell2mat(S(5).X(:,4))),:);
% rownotnan = zeros(meas,1);
% for i = 1:meas
% rownotnan(i) = sum(isnan(S(5).Xcleaned(i,:)));
% end
% S(5).Xcleaned = S(5).Xcleaned(~(rownotnan == var),:);

for i = 1 : length(S(place).X)
    years(i) = str2double(S(place).X{i,3}(8:12));
end
[uniqueyears, uniqueyearsindex] = unique(years,'stable');
[uniqueplace, uniqueplaceindex] = unique(vertcat(S(place).X{:,4}));
[x,year_measurement_index]=intersect(uniqueplaceindex,uniqueyearsindex);
uniqueparam = unique(S(place).X(:,5),'stable');
[a,i]=ismember('carbamazepine',vertcat(S(place).X(:,6)));
carbaparamname = S(place).X(i,5);
carbaparaunit = S(place).X(i,9);
[a,carbaparamindex]=ismember(carbaparamname,uniqueparam);

%%
%sum(~isnan(S(place).Xcleaned(:,carbaparamindex)))
x = year_measurement_index(108):year_measurement_index(113);
y = S(place).Xcleaned(year_measurement_index(108):year_measurement_index(113),carbaparamindex);

p1 = scatter(x,y,'r*','SizeData',8);
set(gca,'Xtick',year_measurement_index(108:113),'XTickLabel',uniqueyears(109:114),'XTickLabelRotation',45, 'YLim',[-0.2 0.3],'YTick',[-0.2 -0.1 0 0.1 0.2 0.3],'YGrid','on');
y1 = y(~isnan(y));
x1 = x(~isnan(y));
hold on
p2 = plot(x1,y1,'b');
xlabel('year','FontSize',16,'FontAngle','italic');
ylabel(carbaparaunit{1,1},'FontSize',16);
title('Lobith carbamazepine concentration','FontSize',16);
legend(p2,{'gemeten'});

X = S(place).Xcleaned(year_measurement_index(108):year_measurement_index(113),:);

%% Fourier input: BAD Measurement carbapara total
% tmp = y1;
% tmp2 = zeros(length(tmp),1);
% for i = 1 : length(tmp)
%     tmp(i) = NaN;
%     tmp = FourierImpute(tmp);
%     tmp2(i) = tmp(i);
%     tmp = y1;
% end
% plot(x1,tmp2);