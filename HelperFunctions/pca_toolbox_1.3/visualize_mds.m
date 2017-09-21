function varargout = visualize_mds(varargin)

% This routine is used in the graphical user interface of the toolbox
%
% Note that a detailed HTML help is provided with the toolbox.
% See the HTML HELP files (help.htm) for futher details and examples
%
% PCA toolbox for MATLAB
% version 1.3 - May 2017
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% http://michem.disat.unimib.it/chm/

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @visualize_mds_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_mds_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before visualize_mds is made visible.
function visualize_mds_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Position',[103.7143 33.8235 134.5714 25.6471]);
set(handles.visualize_mds,'Position',[103.7143 33.8235 134.5714 25.6471]);
set(handles.pop_y,'Position',[4.1429 18.9 20.8571 1]);
set(handles.pop_x,'Position',[4 20.55 20.7143 1]);
set(handles.view_sample_button,'Position',[3.4 15.9577 21.8 1.7692]);
set(handles.pca_title_text,'Position',[3 23.9231 13 1.1538]);
set(handles.score_lab_chk,'Position',[3 22 16.6 1.1538]);
set(handles.open_score_button,'Position',[3.4 13.1885 22 1.8462]);
set(handles.frame_pca,'Position',[1.4286 11.6 28.5714 12.6]);
set(handles.score_plot,'Position',[39.8 4.0769 91.2 20]);
set(handles.output,'Position',[103.7143 33.8235 134.5714 25.6471]);
movegui(handles.visualize_mds,'center');
handles.model = varargin{1};
str_disp={};
for k=1:size(handles.model.T,2)
    str_disp{k} = ['dimension ' num2str(k)];
end
set(handles.pop_x,'String',str_disp);
set(handles.pop_y,'String',str_disp);
set(handles.pop_y,'Value',2);
update_plot(handles,[1 1],0);
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_mds_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on button press in open_score_button.
function open_score_button_Callback(hObject, eventdata, handles)
update_plot(handles,[1 0],1)

% --- Executes on button press in score_lab_chk.
function score_lab_chk_Callback(hObject, eventdata, handles)
update_plot(handles,[1 0],0)

% --- Executes on button press in view_sample_button.
function view_sample_button_Callback(hObject, eventdata, handles)
select_sample(handles)

% --- Executes on selection change in pop_x.
function pop_x_Callback(hObject, eventdata, handles)
update_plot(handles,[1 0],0)

% --- Executes during object creation, after setting all properties.
function pop_x_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in pop_y.
function pop_y_Callback(hObject, eventdata, handles)
update_plot(handles,[1 0],0)

% --- Executes during object creation, after setting all properties.
function pop_y_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% ---------------------------------------------------------
function update_plot(handles,update_this,external)

% settings
T = handles.model.T;
col_ass = visualize_colors;

if length(handles.model.labels.sample_labels) > 0
    sample_labels = handles.model.labels.sample_labels;
else
    for k=1:size(T,1); sample_labels{k} = num2str(k); end
end
if length(handles.model.labels.variable_labels) > 0
    variable_labels = handles.model.labels.variable_labels;
else
    for k=1:length(handles.model.E); variable_labels{k} = num2str(k); end
end

class_in = handles.model.set.class;
response_in = handles.model.set.response;
label_scores   = get(handles.score_lab_chk, 'Value');

x = get(handles.pop_x,'Value');
y = get(handles.pop_y,'Value');
Tx = T(:,x);
Ty = T(:,y);
lab_Tx = ['coordinate ' num2str(x) ' (eigenvalue: ' num2str(round(handles.model.E(x)*100)/100) ')'];
lab_Ty = ['coordinate ' num2str(y) ' (eigenvalue: ' num2str(round(handles.model.E(y)*100)/100) ')'];

% display scores
if update_this(1)
    if external; figure; title('MDS plot'); set(gcf,'color','white'); box on; else; axes(handles.score_plot); end
    cla;
    hold on
    if length(class_in) > 0
        for i=1:size(T,1)
            c = col_ass(class_in(i)+1,:);
            plot(Tx(i),Ty(i),'o','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor',c)
        end
    elseif length(response_in) > 0
        [My,wheremax] = max(response_in);
        [my,wheremin] = min(response_in);
        % add max and min for legend
        color_here = 1 - (response_in(wheremax) - my)/(My - my);
        color_in = [color_here color_here color_here];
        plot(Tx(wheremax),Ty(wheremax),'o','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor',color_in)
        legend_label{1} = ['max response'];
        color_here = 1 - (response_in(wheremin) - my)/(My - my);
        color_in = [color_here color_here color_here];
        plot(Tx(wheremin),Ty(wheremin),'o','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor',color_in)
        legend_label{2} = ['min response'];
        for g=1:length(response_in)
            color_here = 1 - (response_in(g) - my)/(My - my);
            color_in = [color_here color_here color_here];
            plot(Tx(g),Ty(g),'o','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor',color_in)
        end    
    else
        plot(Tx,Ty,'o','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor','w')
    end
    
    % add labels
    if label_scores;
        range_span = (max(Tx) - min(Tx));
        plot_string_label(Tx,Ty,'k',sample_labels,range_span);
    end
      
    % set max and min for axis
    range_x = max(Tx) - min(Tx); add_space_x = range_x/20;      
    x_lim = [min(Tx)-add_space_x max(Tx)+add_space_x];
    range_y = max(Ty) - min(Ty); add_space_y = range_y/20;      
    y_lim = [min(Ty)-add_space_y max(Ty)+add_space_y];
        
    axis([x_lim(1) x_lim(2) y_lim(1) y_lim(2)])
    xlabel(lab_Tx)
    ylabel(lab_Ty)
    hold off
end

% ---------------------------------------------------------
function plot_string_label(X,Y,col,lab,range_span)

add_span = range_span/100;
for j=1:length(X); text(X(j)+add_span,Y(j),lab{j},'Color',col); end;

% ---------------------------------------------------------
function select_sample(handles)

T = handles.model.T;
raw_data = handles.model.set.raw_data;
if length(handles.model.labels.sample_labels) > 0
    sample_labels = handles.model.labels.sample_labels;
else
    for k=1:size(T,1); sample_labels{k} = num2str(k); end
end
if length(handles.model.labels.variable_labels) > 0
    variable_labels = handles.model.labels.variable_labels;
else
    for k=1:size(raw_data,2); variable_labels{k} = num2str(k); end
end

Tx = T(:,1);
Ty = T(:,2);

Xd = [Tx Ty];
[x_sel,y_sel] = ginput(1);
xd = [x_sel y_sel];
D_squares_x = (sum(xd'.^2))'*ones(1,size(Xd,1));
D_squares_w = sum(Xd'.^2);
D_product   = - 2*(xd*Xd');
D = (D_squares_x + D_squares_w + D_product).^0.5;
[d_min,closest] = min(D);

update_plot(handles,[1 0],0)
axes(handles.score_plot);
hold on
plot(Tx(closest),Ty(closest),'o','MarkerEdgeColor','r','MarkerSize',8)
plot(Tx(closest),Ty(closest),'o','MarkerEdgeColor','r','MarkerSize',11)
hold off

% find scaled data
datain = raw_data(closest,:);
p = size(raw_data,2);
m = handles.model.set.param.m;
s = handles.model.set.param.s;
scal = handles.model.set.param.pret_type;
if scal == 'none'
    datain_scal = datain;
elseif scal == 'cent'    % centering
    for j=1:p; datain_scal(j) = datain(j)-m(j); end;
else                     % autoscaling
    for j=1:p; datain_scal(j) = (datain(j)-m(j))/s(j); end;
end

figure
subplot(2,1,1)
hold on
inplot = datain_scal;
plot(inplot,'k')
if length(inplot) < 20
    plot(inplot,'o','MarkerEdgeColor','k','MarkerSize',6,'MarkerFaceColor','r')
end
hold off
range_y = max(max(inplot)) - min(min(inplot)); 
add_space_y = range_y/20;
y_lim = [min(min(inplot))-add_space_y max(max(inplot))+add_space_y];
axis([0.5 length(inplot)+0.5 y_lim(1) y_lim(2)])
if length(inplot) < 20
    set(gca,'XTick',[1:length(inplot)])
    set(gca,'XTickLabel',variable_labels)
end
%xlabel('variables')
title(['variable profile of sample ' sample_labels{closest} ' - scaled data'])
set(gcf,'color','white')
box on

subplot(2,1,2)
hold on
inplot = datain;
plot(inplot,'k')
if length(inplot) < 20
    plot(inplot,'o','MarkerEdgeColor','k','MarkerSize',6,'MarkerFaceColor','r')
end
hold off
range_y = max(max(inplot)) - min(min(inplot)); 
add_space_y = range_y/20;
y_lim = [min(min(inplot))-add_space_y max(max(inplot))+add_space_y];
axis([0.5 length(inplot)+0.5 y_lim(1) y_lim(2)])
if length(inplot) < 20
    set(gca,'XTick',[1:length(inplot)])
    set(gca,'XTickLabel',variable_labels)
end
xlabel('variables')
title(['variable profile of sample ' sample_labels{closest} ' - raw data'])
set(gcf,'color','white')
box on

