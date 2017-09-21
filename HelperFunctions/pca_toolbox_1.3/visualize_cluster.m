function varargout = visualize_cluster(varargin)

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
                   'gui_OpeningFcn', @visualize_cluster_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_cluster_OutputFcn, ...
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

% --- Executes just before visualize_cluster is made visible.
function visualize_cluster_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[102.8571 33.7647 165.7143 25.7059]);
set(handles.visualize_cluster,'Position',[102.8571 33.7647 165.7143 25.7059]);
set(handles.text13,'Position',[3.8 22.2308 19 1.1538]);
set(handles.number_cluster_pop,'Position',[3.6 20.5385 18.2 1.6923]);
set(handles.save_cluster_button,'Position',[3.6 17.5385 21.4 1.7692]);
set(handles.pca_title_text,'Position',[3 23.9231 13 1.1538]);
set(handles.open_score_button,'Position',[3.4 14.8462 22 1.8462]);
set(handles.frame_pca,'Position',[1.4 13.9231 28.6 10.3077]);
set(handles.score_plot,'Position',[39.8 4.1538 120.2 19.9231]);
movegui(handles.visualize_cluster,'center');
handles.model = varargin{1};

% initialize combo
str_disp = {};
max_clust = 10;
if size(handles.model.set.raw_data,1) < max_clust
    max_clust = floor(size(handles.model.set.raw_data,1)/2);
end
for k = 1:max_clust;
    str_disp{k} = num2str(k);
end
set(handles.number_cluster_pop,'String',str_disp);

update_plot(handles,0);
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_cluster_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes on button press in open_score_button.
function open_score_button_Callback(hObject, eventdata, handles)
update_plot(handles,1)

% --- Executes on button press in save_cluster_button.
function save_cluster_button_Callback(hObject, eventdata, handles)
num_cluster = get(handles.number_cluster_pop,'Value');
T = cluster(handles.model.L,'maxclust',num_cluster);
visualize_export(T,'cluster')

% --- Executes during object creation, after setting all properties.
function number_cluster_pop_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in number_cluster_pop.
function number_cluster_pop_Callback(hObject, eventdata, handles)
update_plot(handles,0)

% ---------------------------------------------------------
function update_plot(handles,external)

% settings
L = handles.model.L;

if length(handles.model.labels.sample_labels) > 0
    sample_labels = handles.model.labels.sample_labels;
else
    for k=1:size(handles.model.set.raw_data,1); sample_labels{k} = num2str(k); end
end
if length(handles.model.labels.variable_labels) > 0
    variable_labels = handles.model.labels.variable_labels;
else
    for k=1:size(handles.model.set.raw_data,2); variable_labels{k} = num2str(k); end
end

num_cluster = get(handles.number_cluster_pop,'Value');
% T = cluster(L,'maxclust',num_cluster);
find_thr = L(:,3);
thr = find_thr(end - num_cluster + 1);
thr = thr + 0.00001;

% display
if external; 
    figure; title('dendrogram'); set(gcf,'color','white'); box on; 
else
    axes(handles.score_plot); 
end
box on;
dendrogram(L,size(handles.model.set.raw_data,1),'colorthreshold',thr);
xlabel('samples')
ylabel('distance')
box on; 
