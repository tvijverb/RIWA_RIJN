function varargout = visualize_settings_mds(varargin)

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
                   'gui_OpeningFcn', @visualize_settings_mds_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_settings_mds_OutputFcn, ...
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


% --- Executes just before visualize_settings_mds_mds is made visible.
function visualize_settings_mds_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[103.7143 48.4706 56.7143 11]);
set(handles.visualize_settings_mds,'Position',[103.7143 48.4706 56.7143 11]);
set(handles.text16,'Position',[4.8 4.3077 22.8 1.1538]);
set(handles.pop_menu_scaling,'Position',[4.6 2.5385 26.6 1.6923]);
set(handles.text7,'Position',[4.6 7.8462 22.8 1.1538]);
set(handles.text3,'Position',[3.8 9.3846 9.8 1.1538]);
set(handles.pop_menu_distance,'Position',[4.6 6.0769 26.8 1.6923]);
set(handles.button_cancel,'Position',[37 5.4615 17.6 1.7692]);
set(handles.button_calculate_model,'Position',[37 7.9231 17.2 1.7692]);
set(handles.frame1,'Position',[2.2 0.92308 32.4 8.7692]);
set(handles.output,'Position',[103.7143 48.4706 56.7143 11]);
movegui(handles.visualize_settings_mds,'center')
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
str_disp{5} = 'jaccard';
set(handles.pop_menu_distance,'String',str_disp);

% initialize values
handles.domodel = 0;
% if we get a calculated model, we load the same settings
if handles.model_is_present == 2
    if strcmp(model_loaded.type,'mds')
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
        else
            set_dist = 5;            
        end      
        set(handles.pop_menu_scaling,'Value',set_this);
        set(handles.pop_menu_distance,'Value',set_dist);    
    else
        set(handles.pop_menu_scaling,'Value',3);
        set(handles.pop_menu_distance,'Value',1);
    end
else
    set(handles.pop_menu_scaling,'Value',3);
    set(handles.pop_menu_distance,'Value',1);
end
handles = enable_disable(handles);
guidata(hObject, handles);
uiwait(handles.visualize_settings_mds);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_settings_mds_OutputFcn(hObject, eventdata, handles)
len = length(handles);
if len > 0
    if get(handles.pop_menu_distance,'Value') == 1
        dist_selected = 'euclidean';
    elseif get(handles.pop_menu_distance,'Value') == 2
        dist_selected = 'cityblock';
    elseif get(handles.pop_menu_distance,'Value') == 3
        dist_selected = 'mahalanobis';
    elseif get(handles.pop_menu_distance,'Value') == 4
        dist_selected = 'minkowski';
    else
        dist_selected = 'jaccard';
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
    varargout{3} = handles.domodel;
    delete(handles.visualize_settings_mds)
else
    handles.settings.distance = NaN;
    handles.settings.scaling = NaN;
    handles.domodel = 0;
    varargout{1} = handles.settings.distance;
    varargout{2} = handles.settings.scaling;
    varargout{3} = handles.domodel;
end

% --- Executes on button press in button_calculate_model.
function button_calculate_model_Callback(hObject, eventdata, handles)
handles.domodel = 1;
guidata(hObject,handles)
uiresume(handles.visualize_settings_mds)

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
handles.settings = NaN;
guidata(hObject,handles)
uiresume(handles.visualize_settings_mds)

% --- Executes during object creation, after setting all properties.
function pop_menu_distance_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_distance.
function pop_menu_distance_Callback(hObject, eventdata, handles)
handles = enable_disable(handles);
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_scaling_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_scaling.
function pop_menu_scaling_Callback(hObject, eventdata, handles)

% -----------------------------------------------------------------
function handles = enable_disable(handles)
if get(handles.pop_menu_distance,'Value') == 5
    set(handles.pop_menu_scaling,'Value',1);
    set(handles.pop_menu_scaling,'Enable','off');
else
    set(handles.pop_menu_scaling,'Enable','on');
end