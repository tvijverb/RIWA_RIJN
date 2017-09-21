function varargout = visualize_settings_cluster(varargin)

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
                   'gui_OpeningFcn', @visualize_settings_cluster_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_settings_cluster_OutputFcn, ...
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


% --- Executes just before visualize_settings_cluster_cluster is made visible.
function visualize_settings_cluster_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[103.8571 46.2941 56.7143 13.1765]);
set(handles.visualize_settings_cluster,'Position',[103.8571 46.2941 56.7143 13.1765]);
set(handles.text17,'Position',[4.8 3.3077 22.8 1.1538]);
set(handles.pop_menu_linkage,'Position',[4.6 1.5385 26.6 1.6923]);
set(handles.text16,'Position',[4.8 6.6923 22.8 1.1538]);
set(handles.pop_menu_scaling,'Position',[4.6 4.9231 26.6 1.6923]);
set(handles.text7,'Position',[4.6 10.0769 22.8 1.1538]);
set(handles.text3,'Position',[3.8 11.5385 9.8 1.1538]);
set(handles.pop_menu_distance,'Position',[4.6 8.3077 26.8 1.6923]);
set(handles.button_cancel,'Position',[37 7.6923 17.6 1.7692]);
set(handles.button_calculate_model,'Position',[37 10.1538 17.2 1.7692]);
set(handles.frame1,'Position',[2.2 0.84615 32.4 11.0769]);
set(handles.output,'Position',[103.8571 46.2941 56.7143 13.1765]);
movegui(handles.visualize_settings_cluster,'center')
handles.model_is_present = varargin{1};
model_loaded = varargin{2};

% set scaling combo
str_disp={};
str_disp{1} = 'none';
str_disp{2} = 'mean centering';
str_disp{3} = 'autoscaling';
str_disp{4} = 'range scaling';
set(handles.pop_menu_scaling,'String',str_disp);

% set distance combo
str_disp={};
str_disp{1} = 'euclidean';
str_disp{2} = 'cityblock';
str_disp{3} = 'mahalanobis';
str_disp{4} = 'minkowski';
set(handles.pop_menu_distance,'String',str_disp);

% set linkage combo
str_disp={};
str_disp{1} = 'single';
str_disp{2} = 'complete';
str_disp{3} = 'average';
str_disp{4} = 'centroid';
set(handles.pop_menu_linkage,'String',str_disp);

% initialize values
handles.domodel = 0;
% if we get a calculated model, we load the same settings
if handles.model_is_present == 2
    if strcmp(model_loaded.type,'cluster')
        if strcmp(model_loaded.set.param.pret_type,'none')
            set_this = 1;
        elseif strcmp(model_loaded.set.param.pret_type,'cent')
            set_this = 2;
        elseif strcmp(model_loaded.set.param.pret_type,'auto')
            set_this = 3;
        else
            set_this = 4;
        end
        if strcmp(model_loaded.set.distance,'euclidean')
            set_dist = 1;
        elseif strcmp(model_loaded.set.distance,'cityblock')
            set_dist = 2;
        elseif strcmp(model_loaded.set.distance,'mahalanobis')
            set_dist = 3;
        elseif strcmp(model_loaded.set.distance,'minkowski')
            set_dist = 4;
        end      
        if strcmp(model_loaded.set.linkage_type,'single')
            set_linkage = 1;
        elseif strcmp(model_loaded.set.linkage_type,'complete')
            set_linkage = 2;
        elseif strcmp(model_loaded.set.linkage_type,'average')
            set_linkage = 3;
        elseif strcmp(model_loaded.set.linkage_type,'centroid')
            set_linkage = 4;
        end       
        set(handles.pop_menu_scaling,'Value',set_this);
        set(handles.pop_menu_distance,'Value',set_dist);
        set(handles.pop_menu_linkage,'Value',set_linkage);
    else
        set(handles.pop_menu_scaling,'Value',3);
        set(handles.pop_menu_distance,'Value',1);
        set(handles.pop_menu_linkage,'Value',1);
    end
else
    set(handles.pop_menu_scaling,'Value',3);
    set(handles.pop_menu_distance,'Value',1);
    set(handles.pop_menu_linkage,'Value',1);
end

guidata(hObject, handles);
uiwait(handles.visualize_settings_cluster);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_settings_cluster_OutputFcn(hObject, eventdata, handles)
len = length(handles);
if len > 0
    if get(handles.pop_menu_distance,'Value') == 1
        dist_selected = 'euclidean';
    elseif get(handles.pop_menu_distance,'Value') == 2
        dist_selected = 'cityblock';
    elseif get(handles.pop_menu_distance,'Value') == 3
        dist_selected = 'mahalanobis';
    else
        dist_selected = 'minkowski';
    end
    varargout{1} = dist_selected;
    if get(handles.pop_menu_scaling,'Value') == 1
        set_this = 'none';
    elseif get(handles.pop_menu_scaling,'Value') == 2
        set_this = 'cent';
    elseif get(handles.pop_menu_scaling,'Value') == 3
        set_this = 'auto';
    else
        set_this = 'rang';
    end
    varargout{2} = set_this;
    if get(handles.pop_menu_linkage,'Value') == 1
        linkage_selected = 'single';
    elseif get(handles.pop_menu_linkage,'Value') == 2
        linkage_selected = 'complete';
    elseif get(handles.pop_menu_linkage,'Value') == 3
        linkage_selected = 'average';
    else
        linkage_selected = 'centroid';
    end
    varargout{3} = linkage_selected;
    varargout{4} = handles.domodel;
    delete(handles.visualize_settings_cluster)
else
    handles.settings.distance = NaN;
    handles.settings.scaling = NaN;
    handles.settings.linkage_type = NaN;
    handles.domodel = 0;
    varargout{1} = handles.settings.distance;
    varargout{2} = handles.settings.scaling;
    varargout{3} = handles.settings.linkage_type;
    varargout{4} = handles.domodel;
end

% --- Executes on button press in button_calculate_model.
function button_calculate_model_Callback(hObject, eventdata, handles)
handles.domodel = 1;
guidata(hObject,handles)
uiresume(handles.visualize_settings_cluster)

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
handles.settings = NaN;
guidata(hObject,handles)
uiresume(handles.visualize_settings_cluster)

% --- Executes during object creation, after setting all properties.
function pop_menu_distance_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_distance.
function pop_menu_distance_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_scaling_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_scaling.
function pop_menu_scaling_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_linkage_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_linkage.
function pop_menu_linkage_Callback(hObject, eventdata, handles)
