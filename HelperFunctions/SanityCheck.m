%SANITYCHECK Summary of this function goes here
%   Detailed explanation goes here

%%
%load('S.mat');

%%
% Point of measurement 'place' 
    % 1:Rhine,Andijk
    % 2:Meuse, Eijsden
    % 3:Meuse, Heel
    % 4:Meuse, Keizersveer
    % 5:Rhine, Lobith
    
place = 5;
[meas, var] = size(S(place).Xcleaned);

S(5).X = S(5).X(~isnan(cell2mat(S(5).X(:,4))),:);
rownotnan = zeros(meas,1);
for i = 1:meas
rownotnan(i) = sum(isnan(S(5).Xcleaned(i,:)));
end
S(5).Xcleaned = S(5).Xcleaned(~(rownotnan == var),:);

for i = 1 : length(S(place).X)
    years(i) = str2double(S(place).X{i,3}(8:12));
end
[uniqueyears, uniqueyearsindex] = unique(years,'stable');
[uniqueplace, uniqueplaceindex] = unique(vertcat(S(place).X{:,4}));
[x,year_measurement_index]=intersect(uniqueplaceindex,uniqueyearsindex);
%% Barchart measurements
figure

% Loop over #variables
for i = 1 : var
    varmeasurements(i) = sum(~isnan(S(place).Xcleaned(:,i)));
end
%bar(sort(varmeasurements,'descend'));
bar(varmeasurements);
xlabel('variables','FontSize',16,'FontAngle','italic');
ylabel('#measurements','FontSize',16,'FontAngle','italic');
title('Missing Data at Andijk (Rhine)','FontSize',16);
set(gca,'Ylim',[1 meas]);
legend('measured data');
missingdata = 1-(sum(varmeasurements)/(meas*var));
disp([num2str(missingdata*100) '% of data is missing']);

%% #Variable measurements
figure

plot(var-rownotnan)
xlabel('year','FontSize',16,'FontAngle','italic');
ylabel('#variables measured','FontSize',16,'FontAngle','italic');
set(gca,'Xtick',year_measurement_index,'XTickLabel',uniqueyears,'XTickLabelRotation',45);
title('#variables measured at Andijk (Rhine)','FontSize',16);
%% Measurement frequency
figure
dates = unique(vertcat(S(place).X{:,4}),'stable');
plot(diff(dates));
xlabel('year','FontSize',16,'FontAngle','italic');
ylabel('measurement gap (days)','FontSize',16,'FontAngle','italic');
set(gca,'Xtick',year_measurement_index,'XTickLabel',uniqueyears,'XTickLabelRotation',45);
title('Measurement frequency at Andijk (Rhine)','FontSize',16);

figure
histogram(diff(dates));
xlabel('measurement gap (days)','FontSize',16,'FontAngle','italic');
ylabel('gap frequency','FontSize',16,'FontAngle','italic');
title('Measurement frequency at Andijk (Rhine)','FontSize',16);

uniqueparam = unique(S(place).X(:,5),'stable');
[a,i]=ismember('carbamazepine',vertcat(S(place).X(:,6)));
carbaparamname = S(place).X(i,5);
carbaparaunit = S(place).X(i,9);
[a,carbaparamindex]=ismember(carbaparamname,uniqueparam);

%% Check for duplicates

%Days
% d = cell2mat(S(5).X(:,4));
% ud = unique(d);
% 
% for i = 1: length(ud)
% carbacount(i) = sum(ismember(S(place).X(d == ud(i),5),'1860'));
% end
