%% Created by Thomas Vijverberg on 30-03-2016 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 19-04-2016

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%INPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input data structure (STRUCT) 'S' with dimension 1 x (total_measurements)
    %Must contain atleast contain:
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
% Preprocessing
place = 5;
cutoff_measurements_per_day = 10;
cutoff_variables_measured = 100;

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
uniqueparam = unique(S(place).X(:,5),'stable');


%% kNN imputation
if place == 5
    X = S(place).Xcleaned(year_measurement_index(108):year_measurement_index(113),:);
elseif place == 1
    X = S(place).Xcleaned(year_measurement_index(33):year_measurement_index(38),:);
end
var_n_measurements = sum(~isnan(X));
date_n_measurements = sum(~isnan(X),2);
%Xfilled = X;
Xfilled = X(date_n_measurements > cutoff_measurements_per_day, var_n_measurements > cutoff_variables_measured);
[Xpredicted ] = knnW3timeLag( Xfilled,10,4,2);
relevant_param = uniqueparam(var_n_measurements > cutoff_variables_measured);

[a,i]=ismember('temperatuur',vertcat(S(place).X(:,6)));
temp_paramname = S(place).X(i,5);
temp_unit = S(place).X(i,9);
[a,tempindex]=ismember(temp_paramname,relevant_param);

x = 1:length(Xpredicted(:,1));

[Xpcaia1] = msvd( Xfilled,1);
[Xpcaia2] = msvd( Xfilled,2);

% tmp = Xpredicted;
% tmp2 = zeros(length(tmp(:,1)),1);
% for j = 1 : 10
%     for i = 1 : length(tmp(:,1))
%         tmp(i,j) = NaN;
%         tmp = knnW3timeLag(tmp,20,6,3);
%         tmp2(i,j) = tmp(i,j);
%         tmp = Xpredicted;
%     end
% end

% for i = 1:10
% figure
% hold on
% plot(x,Xpredicted(:,i));
% plot(x,tmp2(:,i));
% title(relevant_param{i});
% end

for i = 1:10
figure
hold on
%plot(x,Xpredicted(:,i),'b');
scatter(x,Xpredicted(:,i),'bs','SizeData',12);

%plot(x,Xpcaia1(:,i),'k');
scatter(x,Xpcaia1(:,i),'ks','SizeData',12);

%plot(x,Xpcaia2(:,i),'g');
scatter(x,Xpcaia2(:,i),'gs','SizeData',12);

plot(x,Xfilled(:,i),'r');
scatter(x,Xfilled(:,i),'rs','SizeData',8);
[~,ii]=ismember(relevant_param(i),S(place).X(:,5));
title(S(place).X(ii,6));
ylabel(S(place).X(ii,9));
legend('k-NN imputation','PCA-IA 1LV','PCA-IA 2LV','Known data');
set(gca,'Xtick',year_measurement_index(108:113),'XTickLabel',uniqueyears(108:113),'XTickLabelRotation',45,'YGrid','on');
savestr = strcat(S(place).X{ii,6},'.tiff');
set(gcf, 'Position', [0, 0, 1920, 1080]);
saveas(gca,savestr);
end
tilefig();