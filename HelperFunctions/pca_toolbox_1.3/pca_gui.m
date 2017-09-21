function varargout = pca_gui(varargin)

% pca_gui opens a GUI for calculating PCA, MDS and Cluster Analysis
% in order to open the graphical interface, just type on the matlab command line:
%
% pca_gui
%
% there are no inputs, data can be loaded and saved directly from the 
% graphical interface
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
                   'gui_OpeningFcn', @pca_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @pca_gui_OutputFcn, ...
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


% --- Executes just before pca_gui is made visible.
function pca_gui_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Position',[12 11.8824 84.5714 14.1176]);
set(handles.pca_gui,'Position',[12 11.8824 84.5714 14.1176]);
set(handles.listbox_model,'Position',[44 1.0353 38.5714 12.0588]);
set(handles.listbox_data,'Position',[2.1429 1.0353 38.5714 12.0588]);
set(handles.output,'Position',[12 11.8824 84.5714 14.1176]);
movegui('center');
% initialize handles
handles = init_handles(handles);

% enable/disable buttons and menu
handles = enable_disable(handles);

% updtae list boxes
update_listbox_data(handles)
update_listbox_model(handles)

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = pca_gui_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --------------------------------------------------------------------
function m_file_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function m_file_load_data_Callback(hObject, eventdata, handles)
% ask for overwriting
if handles.present.data == 1
    q = questdlg('Data are alreday loaded. Do you wish to overwrite them?','loading data','yes','no','yes');
else
    q = 'yes';
end
if strcmp(q,'yes')
    res = visualize_load(1,0);
    if isnan(res.loaded_file)
        if handles.present.data  == 0
            handles.present.data  = 0;
            handles = reset_labels(handles);
        else
            handles.present.data  = 1;
        end
    elseif res.from_file == 1
        handles = reset_data(handles);
        handles.present.data  = 1;
        handles = reset_labels(handles);
        if handles.present.model == 2; handles.present.model = 1; end % model becames loaded instead of calculated
        tmp_data = load(res.path);
        handles.data.X = getfield(tmp_data,res.name);
        handles.data.name_data = res.name;
        handles = reset_class(handles);
        handles = reset_response(handles);
    else
        handles = reset_data(handles);
        handles.present.data  = 1;
        handles = reset_labels(handles);
        if handles.present.model == 2; handles.present.model = 1; end % model becames loaded instead of calculated
        handles.data.X = evalin('base',res.name);
        handles.data.name_data = res.name;
        handles = reset_class(handles);
        handles = reset_response(handles);
    end
    handles = enable_disable(handles);
    update_listbox_data(handles)
    guidata(hObject,handles)
end

% --------------------------------------------------------------------
function m_file_load_class_Callback(hObject, eventdata, handles)
% ask for overwriting
if handles.present.response == 1 || handles.present.class == 1
    q = questdlg('Response/class is alreday loaded. Do you wish to overwrite it?','loading class','yes','no','yes');
else
    q = 'yes';
end
if strcmp(q,'yes') 
    res = visualize_load(2,size(handles.data.X,1));
    if isnan(res.loaded_file)
        if handles.present.class  == 0
            handles.present.class  = 0;
        else
            handles.present.class  = 1;
        end
    elseif res.from_file == 1
        handles.present.class  = 1;
        handles = reset_response(handles);
        tmp_data = load(res.path);
        handles.data.class = getfield(tmp_data,res.name);
        if size(handles.data.class,2) > size(handles.data.class,1)
            handles.data.class = handles.data.class';
        end
        handles.data.name_class = res.name;
    else
        handles.present.class  = 1;
        handles = reset_response(handles);
        handles.data.class = evalin('base',res.name);
        if size(handles.data.class,2) > size(handles.data.class,1)
            handles.data.class = handles.data.class';
        end
        handles.data.name_class = res.name;
    end
    handles = enable_disable(handles);
    update_listbox_data(handles)
    guidata(hObject,handles)
end

% --------------------------------------------------------------------
function m_file_load_response_Callback(hObject, eventdata, handles)
% ask for overwriting
if handles.present.response == 1 || handles.present.class == 1
    q = questdlg('Response/class is alreday loaded. Do you wish to overwrite it?','loading response','yes','no','yes');
else
    q = 'yes';
end
if strcmp(q,'yes') 
    res = visualize_load(6,size(handles.data.X,1));
    if isnan(res.loaded_file)
        if handles.present.response  == 0
            handles.present.response  = 0;
        else
            handles.present.response  = 1;
        end
    elseif res.from_file == 1
        handles.present.response  = 1;
        handles = reset_class(handles);
        tmp_data = load(res.path);
        handles.data.response = getfield(tmp_data,res.name);
        if size(handles.data.response,2) > size(handles.data.response,1)
            handles.data.response = handles.data.response';
        end
        handles.data.name_response = res.name;
    else
        handles.present.response  = 1;
        handles = reset_class(handles);
        handles.data.response = evalin('base',res.name);
        if size(handles.data.response,2) > size(handles.data.response,1)
            handles.data.response = handles.data.response';
        end
        handles.data.name_response = res.name;
    end
    handles = enable_disable(handles);
    update_listbox_data(handles)
    guidata(hObject,handles)
end

% --------------------------------------------------------------------
function m_file_load_model_Callback(hObject, eventdata, handles)
% ask for overwriting
if handles.present.model > 0
    q = questdlg('Model is alreday loaded/calculated. Do you wish to overwrite it?','loading model','yes','no','yes');
else
    q = 'yes';
end
if strcmp(q,'yes')
    res = visualize_load(3,0);
    if isnan(res.loaded_file)
        if handles.present.model  == 0
            handles.present.model  = 0;
        else
            handles.present.model  = 1;
        end
    elseif res.from_file == 1
        handles.present.model  = 1;
        tmp_data = load(res.path);
        handles.data.model = getfield(tmp_data,res.name);
        handles.data.name_model = res.name;
    else
        handles.present.model  = 1;
        handles.data.model = evalin('base',res.name);
        handles.data.name_model = res.name;
    end
    handles = enable_disable(handles);
    update_listbox_model(handles)
    guidata(hObject,handles)
end

% --------------------------------------------------------------------
function m_file_load_labels_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function m_file_load_sample_labels_Callback(hObject, eventdata, handles)
res = visualize_load(4,size(handles.data.X,1));
if isnan(res.loaded_file)
    if handles.present.sample_labels == 0
        handles.present.sample_labels  = 0;
    else
        handles.present.sample_labels  = 1;
    end
elseif res.from_file == 1
    handles.present.sample_labels  = 1;
    tmp_data = load(res.path);
    handles.data.sample_labels = getfield(tmp_data,res.name);
    if size(handles.data.sample_labels,2) > size(handles.data.sample_labels,1)
        handles.data.sample_labels = handles.data.sample_labels';
    end
else
    handles.present.sample_labels  = 1;
    handles.data.sample_labels = evalin('base',res.name);
    if size(handles.data.sample_labels,2) > size(handles.data.sample_labels,1)
        handles.data.sample_labels = handles.data.sample_labels';
    end
end
handles = enable_disable(handles);
update_listbox_data(handles)
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_file_load_variable_labels_Callback(hObject, eventdata, handles)
res = visualize_load(5,size(handles.data.X,2));
if isnan(res.loaded_file)
    if handles.present.variable_labels == 0
        handles.present.variable_labels  = 0;
    else
        handles.present.variable_labels  = 1;
    end
elseif res.from_file == 1
    handles.present.variable_labels  = 1;
    tmp_data = load(res.path);
    handles.data.variable_labels = getfield(tmp_data,res.name);
    if size(handles.data.variable_labels,2) > size(handles.data.variable_labels,1)
        handles.data.variable_labels = handles.data.variable_labels';
    end
else
    handles.present.variable_labels  = 1;
    handles.data.variable_labels = evalin('base',res.name);
    if size(handles.data.variable_labels,2) > size(handles.data.variable_labels,1)
        handles.data.variable_labels = handles.data.variable_labels';
    end
end
handles = enable_disable(handles);
update_listbox_data(handles)
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_file_save_model_Callback(hObject, eventdata, handles)
visualize_export(handles.data.model,'model')

% --------------------------------------------------------------------
function m_file_clear_data_Callback(hObject, eventdata, handles)
handles = reset_data(handles);
handles = reset_class(handles);
handles = reset_response(handles);
handles = reset_labels(handles);
handles = enable_disable(handles);
update_listbox_data(handles)
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_file_clear_model_Callback(hObject, eventdata, handles)
handles = reset_model(handles);
handles = enable_disable(handles);
update_listbox_model(handles)
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_file_clear_labels_Callback(hObject, eventdata, handles)
handles = reset_labels(handles);
handles = enable_disable(handles);
update_listbox_data(handles)
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_file_exit_Callback(hObject, eventdata, handles)
close

% --------------------------------------------------------------------
function m_view_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function m_view_data_Callback(hObject, eventdata, handles)
assignin('base','tmp_view',handles.data.X);
openvar('tmp_view');

% --------------------------------------------------------------------
function m_view_plot_profiles_Callback(hObject, eventdata, handles)
visualize_profiles(handles.data.X,handles.data.class,handles.data.variable_labels)

% --------------------------------------------------------------------
function m_view_plot_univariate_Callback(hObject, eventdata, handles)
visualize_variable(handles.data.X,handles.data.class,handles.data.response,handles.data.variable_labels,handles.data.sample_labels)

% --------------------------------------------------------------------
function m_view_delete_Callback(hObject, eventdata, handles)
out = visualize_delete_samples(size(handles.data.X,1),handles.data.class,handles.data.response,handles.data.sample_labels);
if ~isnan(out)
    if size(handles.data.X,1) > 1
        dodelete = 0;
        if handles.present.class || handles.present.response
            if handles.present.class
                in = ones(size(handles.data.X,1),1);
                in(out) = 0;
                in = find(in);
                tmpclass = handles.data.class(in);
                if max(tmpclass) < 2
                    h1 = 'sample can not be deleted since the number of classes would be reduced to just one!';
                    warndlg([h1],'Delete samples')
                else
                    dodelete = 1;
                end
            end
            if handles.present.response
                in = ones(size(handles.data.X,1),1);
                in(out) = 0;
                in = find(in);
                tmpresponse = handles.data.response(in);
                if max(tmpresponse) == min(tmpresponse)
                    h1 = 'sample can not be deleted sice the response would be reduced to a constant!';
                    warndlg([h1],'Delete samples')
                else
                    dodelete = 1;
                end
            end
        else
            dodelete = 1;
        end
        if dodelete
            in = ones(size(handles.data.X,1),1);
            in(out) = 0;
            in = find(in);
            % update handles
            handles.data.X = handles.data.X(in,:,:);
            if handles.present.class
                handles.data.class = handles.data.class(in);
            end
            if handles.present.response
                handles.data.response = handles.data.response(in);
            end
            if handles.present.sample_labels
                handles.data.sample_labels = handles.data.sample_labels(in);
            end    
            % update sample info
            update_listbox_data(handles)
            if handles.present.model == 2
                handles = reset_model(handles);
                update_listbox_model(handles);
            end
            guidata(hObject,handles)
        end
    else
        h1 = ['There is just one sample in the dataset. It is not possible to delete it!'];
        warndlg([h1],'Delete samples')
    end
end

% --------------------------------------------------------------------
function m_calculate_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function m_calculate_pca_compsel_Callback(hObject, eventdata, handles)
do_pca_compsel(handles);
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_calculate_pca_Callback(hObject, eventdata, handles)
handles = do_pca(handles);
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_calculate_mds_Callback(hObject, eventdata, handles)
handles = do_mds(handles);
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_calculate_cluster_Callback(hObject, eventdata, handles)
handles = do_cluster(handles);
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_results_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function m_results_plots_Callback(hObject, eventdata, handles)
disp_plots_pca(handles)

% --------------------------------------------------------------------
function m_results_view_eigen_Callback(hObject, eventdata, handles)
view_eigen(handles.data.model.E,handles.data.model.exp_var,handles.data.model.cum_var);

% --------------------------------------------------------------------
function m_results_eigen_Callback(hObject, eventdata, handles)
disp_eigen(handles)

% --------------------------------------------------------------------
function m_results_mds_Callback(hObject, eventdata, handles)
disp_plots_mds(handles)

% --------------------------------------------------------------------
function m_results_cluster_Callback(hObject, eventdata, handles)
disp_plots_cluster(handles)

% --------------------------------------------------------------------
function m_predict_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function m_predict_samples_Callback(hObject, eventdata, handles)
handles = predict_samples(handles);
guidata(hObject,handles)

% --------------------------------------------------------------------
function m_help_Callback(hObject, eventdata, handles)

% --------------------------------------------------------------------
function m_help_html_Callback(hObject, eventdata, handles)
h1 = ['A complete HTML guide is provided.'];
hr = sprintf('\n');
h3 = ['Look for the help.htm file in the toolbox folder' sprintf('\n') 'and open it in your favourite browser!'];
web('help.htm','-browser')
helpdlg([h1 hr h3],'HTML help')

% --------------------------------------------------------------------
function m_how_to_cite_Callback(hObject, eventdata, handles)
h1 = ['The toolbox is freeware and may be used (but not modified) if proper reference is given to the authors. Preferably refer to the following paper:'];
hr = sprintf('\n');
h3 = ['D. Ballabio'];
h4 = ['A MATLAB toolbox for Principal Component Analysis and unsupervised exploration of data structure'];
h5 = ['Chemometrics and Intelligent Laboratory Systems (2015), 149 Part B, 1-9'];
h6 = ['doi: 10.1016/j.chemolab.2015.10.003'];
helpdlg([h1 hr hr h3 hr h4 hr h5 hr h6 hr],'HTML help')

% --------------------------------------------------------------------
function m_about_Callback(hObject, eventdata, handles)
h1 = 'PCA toolbox for MATLAB version 1.3';
hr = sprintf('\n');
h2 = 'Milano Chemometrics and QSAR Research Group ';
h3 = 'University of Milano-Bicocca, Italy';
h4 = 'http://michem.disat.unimib.it/chm';
helpdlg([h1 hr h2 hr h3 hr h4],'HTML help')

% --- Executes during object creation, after setting all properties.
function listbox_data_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in listbox_data.
function listbox_data_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function listbox_model_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in listbox_model.
function listbox_model_Callback(hObject, eventdata, handles)


% ------------------------------------------------------------------------
function do_pca_compsel(handles)
% open settings
[cv_groups,cv_type,scal,domodel] = visualize_settings_compsel(size(handles.data.X,1));
if domodel
    % activate pointer
    set(handles.pca_gui,'Pointer','watch')
    % run code
    res_compsel = pca_compsel(handles.data.X,scal,cv_type,cv_groups);
    % check if results are calculated
    if isstruct(res_compsel)
        % show results
        visualize_compsel(res_compsel)
    end
    % update model listbox
    set(handles.pca_gui,'Pointer','arrow')    
else
    set(handles.pca_gui,'Pointer','arrow')
end

% ------------------------------------------------------------------------
function handles = do_pca(handles)

model = NaN;
% open do settings
maxcomp = min([size(handles.data.X,2) size(handles.data.X,1)]);
if maxcomp > 20; maxcomp = 20; end
[num_comp,scaling,domodel] = visualize_settings(maxcomp,handles.present.model,handles.data.model);

if domodel
    % activate pointer
    set(handles.pca_gui,'Pointer','watch')
    % run model
    model = pca_model(handles.data.X,num_comp,scaling);
    % check if model and cv are calculated
    if isstruct(model)
        handles.data.model = model;
        handles.data.model.type = 'pca';
        handles.data.model.set.raw_data = handles.data.X;
        if handles.present.sample_labels == 1
            handles.data.model.labels.sample_labels = handles.data.sample_labels;
        else
            handles.data.model.labels.sample_labels = {};
        end
        if handles.present.variable_labels == 1
            handles.data.model.labels.variable_labels = handles.data.variable_labels;
        else
            handles.data.model.labels.variable_labels = {};
        end
        if handles.present.class == 1
            handles.data.model.set.class = handles.data.class;
        else
            handles.data.model.set.class = [];
        end
        if handles.present.response == 1
            handles.data.model.set.response = handles.data.response;
        else
            handles.data.model.set.response = [];
        end
        handles.present.model = 2;
        handles.data.name_model = 'calculated';
    end
    % update model listbox
    set(handles.pca_gui,'Pointer','arrow')
    update_listbox_model(handles)
    handles = enable_disable(handles);
else
    set(handles.pca_gui,'Pointer','arrow')
end

% ------------------------------------------------------------------------
function handles = do_mds(handles)

model = NaN;
% open do settings
[distance,scaling,domodel] = visualize_settings_mds(handles.present.model,handles.data.model);

% check for statistic toolbox
if ~license('test','statistics_toolbox')
    domodel = 0;
    errortype = (['MDS can be calculated only if the MATLAB statistical toolbox is installed']);
    errordlg(errortype,'calculation error') 
end

if domodel
    % activate pointer
    set(handles.pca_gui,'Pointer','watch')
    % run model
    model = mds_model(handles.data.X,distance,scaling);
    % check if model is calculated
    if isstruct(model)
        if size(model.D,1) > 1
            handles.data.model = model;
            handles.data.model.type = 'mds';
            handles.data.model.set.raw_data = handles.data.X;
            if handles.present.sample_labels == 1
                handles.data.model.labels.sample_labels = handles.data.sample_labels;
            else
                handles.data.model.labels.sample_labels = {};
            end
            if handles.present.variable_labels == 1
                handles.data.model.labels.variable_labels = handles.data.variable_labels;
            else
                handles.data.model.labels.variable_labels = {};
            end
            if handles.present.class == 1
                handles.data.model.set.class = handles.data.class;
            else
                handles.data.model.set.class = [];
            end
            if handles.present.response == 1
                handles.data.model.set.response = handles.data.response;
            else
                handles.data.model.set.response = [];
            end
            handles.present.model = 2;
            handles.data.name_model = 'calculated';
        else
            h1 = ['Multidimensional Scaling not calculated'];
            hr = sprintf('\n');
            h3 = ['The statistics toolbox of MATLAB is needed for calculating Multidimensional Scaling'];
            helpdlg([h1 hr h3],'Cluster analysis')
        end
    end
    % update model listbox
    set(handles.pca_gui,'Pointer','arrow')
    update_listbox_model(handles)
    handles = enable_disable(handles);
else
    set(handles.pca_gui,'Pointer','arrow')
end

% ------------------------------------------------------------------------
function handles = do_cluster(handles)

model = NaN;
% open do settings
[distance,scaling,linkage_type,domodel] = visualize_settings_cluster(handles.present.model,handles.data.model);

% check for statistic toolbox
if ~license('test','statistics_toolbox')
    domodel = 0;
    errortype = (['Hierarchical clustering can be calculated only if the MATLAB statistical toolbox is installed']);
    errordlg(errortype,'calculation error') 
end

if domodel
    % activate pointer
    set(handles.pca_gui,'Pointer','watch')
    % run model
    model = cluster_model(handles.data.X,distance,scaling,linkage_type);
    % check if model is calculated
    if isstruct(model)
        if size(model.D,1) > 1
            handles.data.model = model;
            handles.data.model.type = 'cluster';
            handles.data.model.set.raw_data = handles.data.X;
            if handles.present.sample_labels == 1
                handles.data.model.labels.sample_labels = handles.data.sample_labels;
            else
                handles.data.model.labels.sample_labels = {};
            end
            if handles.present.variable_labels == 1
                handles.data.model.labels.variable_labels = handles.data.variable_labels;
            else
                handles.data.model.labels.variable_labels = {};
            end
            if handles.present.class == 1
                handles.data.model.set.class = handles.data.class;
            else
                handles.data.model.set.class = [];
            end
            if handles.present.response == 1
                handles.data.model.set.response = handles.data.response;
            else
                handles.data.model.set.response = [];
            end
            handles.present.model = 2;
            handles.data.name_model = 'calculated';
        else
            h1 = ['Cluster analysis not calculated'];
            hr = sprintf('\n');
            h3 = ['The statistics toolbox of MATLAB is needed for calculating Cluster Analysis'];
            helpdlg([h1 hr h3],'Cluster analysis')
        end
    end
    % update model listbox
    set(handles.pca_gui,'Pointer','arrow')
    update_listbox_model(handles)
    handles = enable_disable(handles);
else
    set(handles.pca_gui,'Pointer','arrow')
end

% ------------------------------------------------------------------------
function update_listbox_data(handles)
if handles.present.data == 0
    set(handles.listbox_data,'String','data not loaded');
else
    str{1} = ['data: loaded'];
    str{2} = ['name: ' handles.data.name_data];
    str{3} = ['samples: ' num2str(size(handles.data.X,1))];
    str{4} = ['variables: ' num2str(size(handles.data.X,2))];
    if handles.present.sample_labels
        str{5} = ['sample labels: loaded'];
    else
        str{5} = ['sample labels: not loaded'];
    end
    if handles.present.variable_labels
        str{6} = ['variable labels: loaded'];
    else
        str{6} = ['variable labels: not loaded'];
    end
    if handles.present.class == 1
        str{7} = ['class: loaded'];
        str{8} = ['name: ' handles.data.name_class];
        str{9} = ['number of classes: ' num2str(max(handles.data.class))];
    elseif handles.present.response == 1
        str{7} = ['response: loaded'];
        str{8} = ['name: ' handles.data.name_response];
        str{9} = '';
    end
    set(handles.listbox_data,'String',str);
end

% ------------------------------------------------------------------------
function update_listbox_model(handles)
if handles.present.model == 0
    set(handles.listbox_model,'String','model not loaded/calculated');
elseif strcmp(handles.data.model.type,'pca')
    nc = handles.data.model.set.num_comp;
    ev = round((handles.data.model.cum_var(end)*1000))/10;
    scal = handles.data.model.set.param.pret_type;
    if handles.present.model == 1
        str{1} = ['model: loaded'];
    elseif handles.present.model == 2
        str{1} = ['model: calculated'];
    end    
    if strcmp(scal,'none')
        set_this = 'none';
    elseif strcmp(scal,'cent')
        set_this = 'mean centering';
    elseif strcmp(scal,'auto')
        set_this = 'autoscaling';
    else
        set_this = 'range scaling';
    end
    str{2} = ['model type: PCA'];
    str{3} = ['data scaling: ' set_this];
    str{4} = ['components in the model: ' num2str(nc)];
    str{5} = ['explained variance: ' num2str(ev) ' %'];
    set(handles.listbox_model,'String',str);
elseif strcmp(handles.data.model.type,'mds')
    scal = handles.data.model.set.param.pret_type;
    distance = handles.data.model.set.distance;
    if handles.present.model == 1
        str{1} = ['model: loaded'];
    elseif handles.present.model == 2
        str{1} = ['model: calculated'];
    end    
    if strcmp(scal,'none')
        set_this = 'none';
    elseif strcmp(scal,'cent')
        set_this = 'mean centering';
    elseif strcmp(scal,'auto')
        set_this = 'autoscaling';
    else
        set_this = 'range scaling';
    end
    str{2} = ['model type: MDS'];
    str{3} = ['distance: ' distance];
    str{4} = ['data scaling: ' set_this]; 
    set(handles.listbox_model,'String',str);        
elseif strcmp(handles.data.model.type,'cluster')
    scal = handles.data.model.set.param.pret_type;
    distance = handles.data.model.set.distance;
    linkage_type = handles.data.model.set.linkage_type;
    if handles.present.model == 1
        str{1} = ['model: loaded'];
    elseif handles.present.model == 2
        str{1} = ['model: calculated'];
    end    
    if strcmp(scal,'none')
        set_this = 'none';
    elseif strcmp(scal,'cent')
        set_this = 'mean centering';
    elseif strcmp(scal,'auto')
        set_this = 'autoscaling';
    else
        set_this = 'range scaling';
    end
    str{2} = ['model type: clustering'];
    str{3} = ['distance: ' distance];
    str{4} = ['data scaling: ' set_this]; 
    str{5} = ['linkage: ' linkage_type]; 
    set(handles.listbox_model,'String',str);    
end

% ------------------------------------------------------------------------
function disp_eigen(handles)
E = handles.data.model.E;
exp_var = handles.data.model.exp_var;
cum_var = handles.data.model.cum_var;
num_comp = length(E);
marker_size = 15;

figure
subplot(3,1,1)
hold on
plot(E,'k')
plot(E,'o','MarkerSize',5,'MarkerFaceColor','r','MarkerEdgeColor','k')
ylim = get(gca, 'YLim');
axis([0.6 (num_comp + 0.4) ylim(1) ylim(2)])
set(gca,'xtick',[1:num_comp]);
hold off
ylabel('eigenvalues')
set(gca,'YGrid','on','GridLineStyle',':')
box on
title('profiles of eigenvalues and explained variance')

subplot(3,1,2)
hold on
bar(exp_var*100,'k')
%plot(exp_var*100,'.k','MarkerSize',marker_size)
ylim = get(gca, 'YLim');
axis([0.6 (num_comp + 0.4) 0 100])
set(gca,'xtick',[1:num_comp]);
hold off
ylabel('exp var (%)')
box on
set(gca,'YGrid','on','GridLineStyle',':')

subplot(3,1,3)
hold on
bar(cum_var*100,'k')
%plot(cum_var*100,'.k','MarkerSize',marker_size)
ylim = get(gca, 'YLim');
axis([0.6 (num_comp + 0.4) 0 100])
set(gca,'xtick',[1:num_comp]);
hold off
ylabel('cum exp var (%)')
xlabel('principal components')
set(gca,'YGrid','on','GridLineStyle',':')
box on
set(gcf,'color','white')

% ------------------------------------------------------------------------
function disp_plots_pca(handles)
visualize_pca(handles.data.model,handles.data.X)

% ------------------------------------------------------------------------
function disp_plots_mds(handles)
visualize_mds(handles.data.model,handles.data.X)

% ------------------------------------------------------------------------
function disp_plots_cluster(handles)
visualize_cluster(handles.data.model)

% ------------------------------------------------------------------------
function handles = predict_samples(handles)
% check data and model size
if size(handles.data.model.L,1) == size(handles.data.X,2)
    errortype = 'none';
else
    errortype = ['mismatch in the number of variables: data have ' num2str(size(handles.data.X,2)) ...
                 ' variables, but model was calculated with ' num2str(size(handles.data.model.L,1)) ' variables'];
end
if strcmp(errortype,'none')
    model = pca_project(handles.data.X,handles.data.model);
    if handles.present.sample_labels
        model.labels.sample_labels_pred = handles.data.sample_labels;
    else
        for k=1:size(model.Tpred,1)
            model.labels.sample_labels_pred{k} = ['P' num2str(k)]; 
        end
    end
    model.set.class_pred = handles.data.class;
    model.set.response_pred = handles.data.response;
    handles.data.model = model;
    h1 = 'Samples have been predicted.';
    hr = sprintf('\n');
    h2 = 'Open the score plot to see their projection in the PCA space.';
    helpdlg([h1 hr h2])
else
    errordlg(errortype,'error comparing data and model sizes') 
end

% ------------------------------------------------------------------------
function handles = init_handles(handles)
handles.present.data  = 0;
handles.present.class = 0;
handles.present.response = 0;
handles.present.model = 0;  % = 1 is loaded, = 2 is calculated
handles.present.sample_labels = 0;
handles.present.variable_labels = 0;
handles.data.name_class = [];
handles.data.name_response = [];
handles.data.name_data = [];
handles.data.name_model = [];
handles.data.X = [];
handles.data.class = [];
handles.data.response = [];
handles.data.model = [];

% ------------------------------------------------------------------------
function handles = reset_data(handles)
handles.present.data  = 0;
handles.data.X = [];
handles.data.name_data = [];

% ------------------------------------------------------------------------
function handles = reset_labels(handles)
handles.present.sample_labels = 0;
handles.present.variable_labels = 0;
handles.data.sample_labels = [];
handles.data.variable_labels = [];

% ------------------------------------------------------------------------
function handles = reset_class(handles)
handles.present.class = 0;
handles.data.name_class = [];
handles.data.class = [];

% ------------------------------------------------------------------------
function handles = reset_response(handles)
handles.present.response = 0;
handles.data.name_response = [];
handles.data.response = [];

% ------------------------------------------------------------------------
function handles = reset_model(handles)
handles.present.model = 0;
handles.data.name_model = [];
handles.data.model = [];

% ------------------------------------------------------------------------
function handles = enable_disable(handles)

if handles.present.data == 0
    set(handles.m_file_load_class,'Enable','off');
    set(handles.m_file_load_response,'Enable','off');    
    set(handles.m_file_clear_data,'Enable','off');
    set(handles.m_calculate_pca,'Enable','off');
    set(handles.m_calculate_pca_compsel,'Enable','off');
    set(handles.m_calculate_mds,'Enable','off');
    set(handles.m_calculate_cluster,'Enable','off');
    set(handles.m_view_data,'Enable','off');
    set(handles.m_view_plot_profiles,'Enable','off');
    set(handles.m_view_plot_univariate,'Enable','off');
    set(handles.m_file_load_sample_labels,'Enable','off');   
    set(handles.m_file_load_variable_labels,'Enable','off');
    set(handles.m_view_delete,'Enable','off');
else
    set(handles.m_file_clear_data,'Enable','on');
    set(handles.m_calculate_pca,'Enable','on');
    set(handles.m_calculate_pca_compsel,'Enable','on');
    set(handles.m_calculate_mds,'Enable','on');
    set(handles.m_calculate_cluster,'Enable','on');
    set(handles.m_file_load_class,'Enable','on');
    set(handles.m_file_load_response,'Enable','on');
    set(handles.m_view_data,'Enable','on');
    set(handles.m_view_plot_profiles,'Enable','on');
    set(handles.m_view_plot_univariate,'Enable','on');
    set(handles.m_file_load_sample_labels,'Enable','on');   
    set(handles.m_file_load_variable_labels,'Enable','on');
    set(handles.m_view_delete,'Enable','on');
end

if handles.present.model == 0
    set(handles.m_file_save_model,'Enable','off');
    set(handles.m_file_clear_model,'Enable','off');
    set(handles.m_results_plots,'Enable','off');
    set(handles.m_results_eigen,'Enable','off');
    set(handles.m_results_view_eigen,'Enable','off');
    set(handles.m_results_mds,'Enable','off');
    set(handles.m_results_cluster,'Enable','off');
else
    set(handles.m_file_clear_model,'Enable','on');   
    set(handles.m_file_save_model,'Enable','on');
    if strcmp(handles.data.model.type,'pca')
        set(handles.m_results_eigen,'Enable','on');
        set(handles.m_results_view_eigen,'Enable','on');
        set(handles.m_results_plots,'Enable','on');
        set(handles.m_results_mds,'Enable','off');
        set(handles.m_results_cluster,'Enable','off');
    elseif strcmp(handles.data.model.type,'mds')
        set(handles.m_results_mds,'Enable','on');
        set(handles.m_results_eigen,'Enable','off');
        set(handles.m_results_view_eigen,'Enable','off');
        set(handles.m_results_plots,'Enable','off');
        set(handles.m_results_cluster,'Enable','off');
    elseif strcmp(handles.data.model.type,'cluster')
        set(handles.m_file_save_model,'Enable','off');
        set(handles.m_results_mds,'Enable','off');
        set(handles.m_results_eigen,'Enable','off');
        set(handles.m_results_view_eigen,'Enable','off');
        set(handles.m_results_plots,'Enable','off');
        set(handles.m_results_cluster,'Enable','on');
    end
end

if handles.present.sample_labels | handles.present.variable_labels
    set(handles.m_file_clear_labels,'Enable','on');
else
    set(handles.m_file_clear_labels,'Enable','off');
end

% predict new samples is active when
% 1. model is loaded and data are already loaded
% 2. data are loaded and model is already loaded
% is not active when
% 3. model is calculated with the loaded data
% 4. PCA is taken into account
if handles.present.model == 1 & handles.present.data == 1
    if strcmp(handles.data.model.type,'pca')
        set(handles.m_predict_samples,'Enable','on');
    else
        set(handles.m_predict_samples,'Enable','off');
    end
else
    set(handles.m_predict_samples,'Enable','off');
end
