function varargout = visualize_settings_compsel(varargin)

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
                   'gui_OpeningFcn', @visualize_settings_compsel_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_settings_compsel_OutputFcn, ...
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


% --- Executes just before visualize_settings_compsel is made visible.
function visualize_settings_compsel_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[103.8571 46.6471 65.7143 12.8235]);
set(handles.visualize_settings_compsel,'Position',[103.8571 46.6471 65.7143 12.8235]);
set(handles.text17,'Position',[3.5714 10.5294 28.5714 1.0588]);
set(handles.pop_menu_scal,'Position',[3.5714 8.2941 33.2857 2.1176]);
set(handles.text16,'Position',[3.5714 7.0588 28.5714 1.2353]);
set(handles.pop_menu_cv_type,'Position',[3.5714 4.9412 33.2857 2.1176]);
set(handles.text7,'Position',[3.5714 3.8235 28.5714 1.1176]);
set(handles.text3,'Position',[5 14.3495 12.25 1.4423]);
set(handles.pop_menu_cv_groups,'Position',[3.5714 1.6471 33.5714 2.1176]);
set(handles.button_cancel,'Position',[45.7143 7.4118 17 2]);
set(handles.button_calculate_model,'Position',[45.7143 10.1765 17 2]);
set(handles.frame1,'Position',[2.1429 0.94118 40.7143 11.2353]);
set(handles.output,'Position',[103.8571 46.6471 65.7143 12.8235]);
movegui(handles.visualize_settings_compsel,'center')
handles.num_samples = varargin{1};

% set cv type combo
str_disp={};
str_disp{1} = 'venetian blinds';
str_disp{2} = 'contiguous blocks';
set(handles.pop_menu_cv_type,'String',str_disp);

% set cv groups combo
str_disp={};
cv_group(1) = 2;
cv_group(2) = 3;
cv_group(3) = 4;
cv_group(4) = 5;
cv_group(5) = 10;
cv_group(6) = handles.num_samples;
for j=1:length(cv_group)
    str_disp{j} = cv_group(j);
end
set(handles.pop_menu_cv_groups,'String',str_disp);
set(handles.pop_menu_cv_groups,'Value',4);

% set scaling combo
str_disp={};
str_disp{1} = 'none';
str_disp{2} = 'mean centering';
str_disp{3} = 'autoscaling';
str_disp{4} = 'range scaling';
set(handles.pop_menu_scal,'String',str_disp);
set(handles.pop_menu_scal,'Value',3);

% initialize values
handles.domodel = 0;

guidata(hObject, handles);
uiwait(handles.visualize_settings_compsel);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_settings_compsel_OutputFcn(hObject, eventdata, handles)
len = length(handles);
if len > 0
    if get(handles.pop_menu_cv_groups,'Value') == 1
        cv_groups = 2;
    elseif get(handles.pop_menu_cv_groups,'Value') == 2
        cv_groups = 3;
    elseif get(handles.pop_menu_cv_groups,'Value') == 3
        cv_groups = 4;
    elseif get(handles.pop_menu_cv_groups,'Value') == 4
        cv_groups = 5;
    elseif get(handles.pop_menu_cv_groups,'Value') == 5
        cv_groups = 10;
    else
        cv_groups = handles.num_samples;
    end
    varargout{1} = cv_groups;
    if get(handles.pop_menu_cv_type,'Value') == 1
        set_this = 'vene';
    else
        set_this = 'cont'; 
    end
    varargout{2} = set_this;
    if get(handles.pop_menu_scal,'Value') == 1
        set_this = 'none';
    elseif get(handles.pop_menu_scal,'Value') == 2
        set_this = 'cent';
    elseif get(handles.pop_menu_scal,'Value') == 3
        set_this = 'auto';
    else
        set_this = 'rang';
    end
    varargout{3} = set_this;
    varargout{4} = handles.domodel;
    delete(handles.visualize_settings_compsel)
else
    handles.settings.cv_groups = NaN;
    handles.settings.cv_type = NaN;
    handles.settings.scal = NaN;
    handles.domodel = 0;
    varargout{1} = handles.settings.cv_groups;
    varargout{2} = handles.settings.cv_type;
    varargout{3} = handles.settings.scal;
    varargout{4} = handles.domodel;
end

% --- Executes on button press in button_calculate_model.
function button_calculate_model_Callback(hObject, eventdata, handles)
handles.domodel = 1;
guidata(hObject,handles)
uiresume(handles.visualize_settings_compsel)

% --- Executes on button press in button_cancel.
function button_cancel_Callback(hObject, eventdata, handles)
handles.settings = NaN;
guidata(hObject,handles)
uiresume(handles.visualize_settings_compsel)

% --- Executes during object creation, after setting all properties.
function pop_menu_cv_groups_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_cv_groups.
function pop_menu_cv_groups_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_cv_type_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_cv_type.
function pop_menu_cv_type_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_menu_scal_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_menu_scal.
function pop_menu_scal_Callback(hObject, eventdata, handles)
