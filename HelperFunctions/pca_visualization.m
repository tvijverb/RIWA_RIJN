function [] = pca_visualization(inputMatrix,inputLabels,timeLabels,varLimiter,new_color,plot_scr,plot_lds)
figure(2);
hold on;
data = inputMatrix';

arrowcolor = new_color;
textcolor = new_color;
textfontsize=24 ;
%textFontWeight='bold';


[r,c]=size(data);

% Compute the mean of the data matrix "The mean of each row" (Equation (10))
m=mean(data')';

% Subtract the mean from each image [Centering the data] (Equation (11))
d=data-repmat(m,1,c);

% Compute the covariance matrix (co) (Equation (12))
co=1 / (c-1)*d*d';

% Compute the eigen values and eigen vectors of the covariance matrix (Equation (2))
[eigvector,eigvl]=eig(co);

% Project the original data on only two eigenvectors
Data_2D=eigvector(:,1:2)'*d;

% Project the original data on only three eigenvectors
Data_3D=eigvector(:,1:3)'*d;

% Reconstruction of the original data 
% Two dimensional case
Res_2D= (eigvector(:,1:2))*Data_2D;
TotRes_2D=Res_2D+repmat(m,1,c);

% Two dimensional case
Res_3D= (eigvector(:,1:3))*Data_3D;
TotRes_3D=Res_3D+repmat(m,1,c);

% Calculate the error between the original data and the reconstructed data
% (Equation (8))
% (Two dimensional case)
MSE=(1/(size(data,1)*size(data,2)))*...
sum(sum(abs(TotRes_2D-double(data))));
% (Three dimensional case)
MSE=(1/(size(data,1)*size(data,2)))*...
sum(sum(abs(TotRes_3D-double(data))));

% Calculate the Robustness of the PCA space (Equation (9))
% (Two Dimensional case)
SumEigvale=diag(eigvl);
Weight_2D=sum(SumEigvale(1:2))/sum(SumEigvale);
% (Three Dimensional case)
Weight_3D=sum(SumEigvale(1:3))/sum(SumEigvale);

% Visualize the data in two dimensional space
% The first class (Setosa) in red, the second class (Versicolour) in blue, and the third class (Virginica) in
% green


if(plot_scr)
    plot(Data_2D(1,:),Data_2D(2,:),'rd'...
        ,'MarkerFaceColor','r','MarkerSize',3); 


    scorelength = sqrt(Data_2D(1,:).^2+Data_2D(1,:));
    [~,arrowSortIndex] = sort(scorelength,'descend');
    keepthis = round(varLimiter * length(scorelength));
    scoreSortIndex = arrowSortIndex(1:keepthis);
    N_var = length(scoreSortIndex);
    DATA_2D = Data_2D(:,scoreSortIndex);
    sortedTimeLabels = timeLabels(scoreSortIndex);

    for i = 1 : length(DATA_2D(1,:))
        text(DATA_2D(1,i),DATA_2D(2,i),sortedTimeLabels{i}(1:end-9),'FontSize',textfontsize);
    end

    %hold on
    %plot(Data_2D(1,51:100),Data_2D(2,51:100),'bd'...
    %    ,'MarkerFaceColor','b'); hold on
    %plot(Data_2D(1,101:150),Data_2D(2,101:150),'gd'...
    %    ,'MarkerFaceColor','g')
    hold on;
    LDS =eigvector(:,1:2);
    SampleNamesVariableNames = inputLabels;

end

%% set standard parameters
if(plot_lds)
    SampleNames = SampleNamesVariableNames{1};
    VariableNames = SampleNamesVariableNames{2};

    if isa(LDS,'single'); LDS=double(LDS);end % because the <text> can only handle double precision.
    axishandle=get(gcf,'CurrentAxes');
    if nargin<2 || isempty(VariableNames);
       A=size(LDS,1); VariableNames={['v' num2str(1)]};
       for L1=2:A;
          VariableNames(end+1)={['v' num2str(L1)]};
       end
    end
    if size(LDS,1)~=length(VariableNames);
       %    disp('ERROR: LDS size - Variable size MISMATCH');
       if size(LDS,1)<length(VariableNames);
          VariableNames=VariableNames(1:size(LDS,1));
       else
          return
       end
    end;


    if nargin <2
        varLimiter = 1;
        arrowcolor=new_color; 
        textcolor=arrowcolor;
    elseif nargin<3; 
        arrowcolor=new_color; 
        textcolor=arrowcolor;
    else new_color=arrowcolor;
    end
    %% determining scale
    [axisrange] = axis(axishandle);
    scaler(1)=(axisrange(1,1))/(-abs(min(LDS(:,1))));
    scaler(2)=(axisrange(1,2))/max(LDS(:,1));
    scaler(3)=(axisrange(1,3))/(-abs(min(LDS(:,2))));
    scaler(4)=(axisrange(1,4))/max(LDS(:,2));
    if length(LDS(1,:)) == 3;
        scaler(5)=(axisrange(1,3))/(-abs(min(LDS(:,3))));
        scaler(6)=(axisrange(1,4))/max(LDS(:,3));
    end
    scaler = min(abs(scaler))*1 ;
    LDS_forplot=LDS.*scaler;
    %% plottign arrows / text
    N_var=size(LDS,1);
    if length(LDS(1,:)) <= 2;

        arrowlength = sqrt(LDS_forplot(:,1).^2+LDS_forplot(:,2));
        [arrowLength_sort,arrowSortIndex] = sort(arrowlength,'descend');
        keepthis = round(varLimiter * length(arrowlength));
        arrowSortIndex = arrowSortIndex(1:keepthis);
        N_var = length(arrowSortIndex);
        LDS_forplot = LDS_forplot(arrowSortIndex,:);
        for L1=1:N_var
           if size(new_color,1)>2
              arrowcolor=new_color(L1,:); textcolor=arrowcolor;
           end
           LDS_quiver(L1,:)=quiver(0,0,LDS_forplot(L1,1),LDS_forplot(L1,2),1,'color',arrowcolor, 'linewidth', 2);
           if LDS_forplot(L1,1) > 0
              horzalignment='left';
           else
              horzalignment='right';
           end
           if abs(LDS_forplot(L1,1)/LDS_forplot(L1,2)) > 1
              vertalignment='middle';
           elseif LDS_forplot(L1,2) > 0
              vertalignment='top';
           else
              vertalignment='bottom';
           end
           LDS_text=text(LDS_forplot(L1,1),LDS_forplot(L1,2),VariableNames{L1},'HorizontalAlignment',horzalignment,'VerticalAlignment',vertalignment,'fontsize',textfontsize,'color',textcolor);
        end

    elseif length(LDS(1,:)) == 3;
       for L1=1:N_var
           if size(new_color,1)>2
              arrowcolor=new_color(L1,:); textcolor=arrowcolor;
           end
           LDS_quiver(L1,:)=quiver3(0,0,0,LDS_forplot(L1,1),LDS_forplot(L1,2),LDS_forplot(L1,3),1,'color',arrowcolor, 'linewidth', 2);
           if LDS_forplot(L1,1) > 0
              horzalignment='left';
           else
              horzalignment='right';
           end
           if abs(LDS_forplot(L1,1)/LDS_forplot(L1,2)) > 1
              vertalignment='middle';
           elseif LDS_forplot(L1,2) > 0
              vertalignment='top';
           else
              vertalignment='bottom';
           end
           LDS_text=text(LDS_forplot(L1,1),LDS_forplot(L1,2),LDS_forplot(L1,3),VariableNames{L1},'HorizontalAlignment',horzalignment,'VerticalAlignment',vertalignment,'fontsize',textfontsize,'color',textcolor,'FontWeight',textFontWeight) ;
       end
    end
end
xlim([-40 40]);
ylim([-30 30]);
grid on;
yt = get(gca, 'YTick');
set(gca, 'FontSize', 30);
xt = get(gca, 'XTick');
set(gca, 'FontSize', 30);
xlabel('Principal Component 1','FontSize',40);
ylabel('Principal Component 2','FontSize', 40);
set(gcf, 'Position', get(0, 'Screensize'));
%rescalefig1080;
fig2plotly(gcf,'strip',false);

end