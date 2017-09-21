function varargout = visualize_compsel(varargin)

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
                   'gui_OpeningFcn', @visualize_compsel_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_compsel_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before visualize_compsel is made visible.
function visualize_compsel_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[145.5714 36.9412 123 22.5294]);
set(handles.visualize_compsel,'Position',[145.5714 36.9412 123 22.5294]);
set(handles.text5,'Position',[1.8571 20.1176 20 1.1176]);
set(handles.button_export,'Position',[1.8571 7.1176 21.1429 2.3529]);
set(handles.pop_criterion,'Position',[1.8571 17.5882 20.7143 2.2353]);
set(handles.text3,'Position',[1.8571 16.2353 22.5714 1.0588]);
set(handles.pop_components,'Position',[1.8571 13.8235 20.7143 2.1176]);
set(handles.button_eigen,'Position',[1.8571 10.7647 21.1429 2.3529]);
set(handles.plot_area,'Position',[32.1429 3.5294 82.1429 17.5294]);
set(handles.output,'Position',[145.5714 36.9412 123 22.5294]);
movegui(handles.visualize_compsel,'center');
handles.res_compsel = varargin{1};
% set combo criterion
str_disp{1} = 'eigenvalues';
str_disp{2} = 'explained var';
str_disp{3} = 'cumulative var';
str_disp{4} = 'RMSECV';
str_disp{5} = 'IE';
str_disp{6} = 'IND';
set(handles.pop_criterion,'String',str_disp);
% set combo components
str_disp={};
for j=1:length(handles.res_compsel.settings.E)-1
    str_disp{j} = num2str(j+1);
end
set(handles.pop_components,'String',str_disp);
set(handles.pop_components,'Value',length(str_disp));
% update plots
update_plot(handles,0)
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_compsel_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

% --- Executes on button press in button_eigen.
function button_eigen_Callback(hObject, eventdata, handles)
view_eigen(handles.res_compsel.settings.E,handles.res_compsel.settings.exp_var,handles.res_compsel.settings.cum_var);

% --- Executes on button press in button_export.
function button_export_Callback(hObject, eventdata, handles)
update_plot(handles,1)

% --- Executes on selection change in pop_components.
function pop_components_Callback(hObject, eventdata, handles)
update_plot(handles,0)

% --- Executes during object creation, after setting all properties.
function pop_components_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in pop_criterion.
function pop_criterion_Callback(hObject, eventdata, handles)
update_plot(handles,0)

% --- Executes during object creation, after setting all properties.
function pop_criterion_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --------------------------------------------
function update_plot(handles,external)
maxcomp = get(handles.pop_components,'Value') + 1;
whattoplot = get(handles.pop_criterion,'String');
whattoplot = whattoplot(get(handles.pop_criterion,'Value'));
if strcmp(whattoplot,'IND')
    plot_this = handles.res_compsel.IND(1:maxcomp);
    y_label = 'Malinowski Indicator Function';
elseif strcmp(whattoplot,'explained var')
    plot_this = handles.res_compsel.settings.exp_var(1:maxcomp);
    y_label = 'explained variance %';
elseif strcmp(whattoplot,'cumulative var')    
    plot_this = handles.res_compsel.settings.cum_var(1:maxcomp);
    y_label = 'cumulative variance %';
elseif strcmp(whattoplot,'RMSECV')
    if maxcomp <= length(handles.res_compsel.rmsecv)
        plot_this = handles.res_compsel.rmsecv(1:maxcomp);
    else
        plot_this = handles.res_compsel.rmsecv(1:length(handles.res_compsel.rmsecv));
    end
    y_label = ['RMSECV - ' num2str(handles.res_compsel.settings.cv_groups) ' cv groups'];
elseif strcmp(whattoplot,'IE')    
    plot_this = handles.res_compsel.IE(1:maxcomp);
    y_label = 'Imbedded Error';
else
    plot_this = handles.res_compsel.settings.E(1:maxcomp);
    y_label = 'eigenvalues';
end

if external; figure; set(gcf,'color','white'); else; axes(handles.plot_area); end
cla;
hold on
box on
xmin = 0.5; xmax = (maxcomp + 0.5);
if strcmp(whattoplot,'eigenvalues')
    plot(plot_this,'k')
    plot(plot_this,'o','MarkerSize',5,'MarkerFaceColor','r','MarkerEdgeColor','k')
    % AEC e CAEC lines
    if strcmp(handles.res_compsel.settings.scal,'auto')
        yline = 1;
    else
        yline = mean(handles.res_compsel.settings.E);
    end
    line([xmin xmax],[yline yline],'Color','r','LineStyle',':')
    line([xmin xmax],[yline*0.7 yline*0.7],'Color','b','LineStyle',':')
    set(gca,'YGrid','on','GridLineStyle',':')
    ymin = 0; ymax = max(plot_this)+0.1*max(plot_this);
    % AEC, CAEC, KP, KL labels
    line([handles.res_compsel.AEC handles.res_compsel.AEC],[ymin ymax],'Color','k','LineStyle',':')
    text(handles.res_compsel.AEC + 0.1,ymax - ymax/20,'AEC')
    line([handles.res_compsel.CAEC handles.res_compsel.CAEC],[ymin ymax],'Color','k','LineStyle',':')
    text(handles.res_compsel.CAEC + 0.1,ymax - 2*ymax/20,'CAEC')
    line([handles.res_compsel.KP handles.res_compsel.KP],[ymin ymax],'Color','k','LineStyle',':')
    text(handles.res_compsel.KP + 0.1,ymax - 3*ymax/20,'KP')
    line([handles.res_compsel.KL handles.res_compsel.KL],[ymin ymax],'Color','k','LineStyle',':')
    text(handles.res_compsel.KL + 0.1,ymax - 4*ymax/20,'KL')
elseif strcmp(whattoplot,'explained var') || strcmp(whattoplot,'cumulative var')
    bar(plot_this*100,'k')
    ymin = 0; ymax = 100;
    set(gca,'YGrid','on','GridLineStyle',':')
else
    plot(plot_this,'k')
    plot(plot_this,'o','MarkerSize',5,'MarkerFaceColor','r','MarkerEdgeColor','k')    
    set(gca,'YGrid','on','GridLineStyle',':')
    ymin = min(plot_this)-0.1*min(plot_this); ymax = max(plot_this)+0.1*max(plot_this);
end
set(gca,'xtick',[1:maxcomp]);
xlabel('Principal Components')
ylabel(y_label)
axis([xmin xmax ymin ymax])
hold off
