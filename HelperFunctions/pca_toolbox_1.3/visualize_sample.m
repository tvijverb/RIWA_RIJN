function varargout = visualize_sample(varargin)

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
                   'gui_OpeningFcn', @visualize_sample_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_sample_OutputFcn, ...
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

% --- Executes just before visualize_sample is made visible.
function visualize_sample_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
set(hObject,'Position',[130 26.13 158.2 60]);
set(handles.visualize_sample,'Position',[130 26.13 158.2 60]);
set(handles.text1,'Position',[2.8 57.615 31 1.077]);
set(handles.text2,'Position',[2.8 53.923 33 1.077]);
set(handles.pop_normalisation,'Position',[2.8 51.692 27.8 2.1176]);
set(handles.pop_variables,'Position',[2.8 55.385 28 2.154]);
set(handles.plot_T2,'Position',[39.8 23 115 15]);
set(handles.plot_variables,'Position',[39.8 42.8 115 15]);
set(handles.plot_Qres,'Position',[39.8 3.692 115 15]);
set(handles.button_export,'Position',[2.8 49 20.8 2]);
set(handles.output,'Position',[130 26.13 158.2 60]);
movegui(handles.visualize_sample,'center')

%init data
handles.data.datain = varargin{1};
handles.data.datain_scal = varargin{2};
handles.data.variable_labels = varargin{3};
handles.data.sample_label = varargin{4};
handles.data.T2 = varargin{5};
handles.data.Qres = varargin{6};
handles.data.Tcont = varargin{7};
handles.data.Qcont = varargin{8};

% calculate T2 and Q res normnalised
[handles.data.T2_norm] = T2_Qres_normalised(handles.data.Tcont,handles.data.T2);
[handles.data.Qres_norm] = T2_Qres_normalised(handles.data.Qcont,handles.data.Qres);

% init T2 and Qres combo
str_disp={};
str_disp{1} = 'raw';
str_disp{2} = 'normalised';
set(handles.pop_normalisation,'String',str_disp);
set(handles.pop_normalisation,'Value',2);

% init variable profiles combo
str_disp={};
str_disp{1} = 'raw data';
str_disp{2} = 'scaled data';
set(handles.pop_variables,'String',str_disp);
set(handles.pop_variables,'Value',2);

update_plot(handles,0);
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_sample_OutputFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function pop_variables_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_variables.
function pop_variables_Callback(hObject, eventdata, handles)
update_plot(handles,0)

% --- Executes during object creation, after setting all properties.
function pop_normalisation_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in pop_normalisation.
function pop_normalisation_Callback(hObject, eventdata, handles)
update_plot(handles,0)

% --- Executes on button press in button_export.
function button_export_Callback(hObject, eventdata, handles)
update_plot(handles,1)

% -------------------------------------------------------------------------
function contrnorm = T2_Qres_normalised(tr,test)
[o,v]=size(tr);
p=o*.95;
[a,b]=sort(abs(tr));
if p==floor(p)
    cl=a(p,:);
else
    cl=a(floor(p),:).*(ceil(p)-p)+a(ceil(p),:).*(p-floor(p));
end
contrnorm = test./cl;

% -------------------------------------------------------------------------
function update_plot(handles,external)
% plot variable profiles
if get(handles.pop_variables,'Value') == 1
    inplot_variables = handles.data.datain;
    title_list{1} = ['variable profile of sample ' handles.data.sample_label ' - raw data'];
else
    inplot_variables = handles.data.datain_scal;
    title_list{1} = ['variable profile of sample ' handles.data.sample_label ' - scaled data'];
end
% plot T2 and Qres
if get(handles.pop_normalisation,'Value') == 1
    inplot_T2 = handles.data.T2;
    inplot_Qres = handles.data.Qres;
    title_list{2} = ['Hotelling T^2 contributions of sample ' handles.data.sample_label];
    title_list{3} = ['Q contributions (residuals of scaled - calc) of sample ' handles.data.sample_label];
else
    inplot_T2 = handles.data.T2_norm;
    inplot_Qres = handles.data.Qres_norm;
    title_list{2} = ['normalised Hotelling T^2 contributions of sample ' handles.data.sample_label];
    title_list{3} = ['normalised Q contributions (residuals of scaled - calc) of sample ' handles.data.sample_label];
end
if external; figure; set(gcf,'color','white'); end
% plot variables
if external; subplot(3,1,1); else; axes(handles.plot_variables); end
cla;
hold on
box on
plot(inplot_variables,'k')
if length(inplot_variables) < 20
    plot(inplot_variables,'o','MarkerEdgeColor','k','MarkerSize',6,'MarkerFaceColor','r')
end
range_y = max(max(inplot_variables)) - min(min(inplot_variables)); 
add_space_y = range_y/20;
y_lim = [min(min(inplot_variables))-add_space_y max(max(inplot_variables))+add_space_y];
axis([0.5 length(inplot_variables)+0.5 y_lim(1) y_lim(2)])
if length(inplot_variables) < 20
    set(gca,'XTick',[1:length(inplot_variables)])
    set(gca,'XTickLabel',handles.data.variable_labels)
end
title(title_list{1})
hold off
% plot T2
if external; subplot(3,1,2); else; axes(handles.plot_T2); end
cla;
hold on
box on
bar(inplot_T2,'k')
if length(inplot_T2) < 20
    set(gca,'XTick',[1:length(inplot_T2)])
    set(gca,'XTickLabel',handles.data.variable_labels)
end
mmT2 = min(min(inplot_T2));
MMT2 = max(max(inplot_T2));
range_y = max(inplot_T2) - min(inplot_T2);
add_space_y = range_y/20;
if get(handles.pop_normalisation,'Value') == 2
    if mmT2 > -1; mmT2 = -1; end
    if MMT2 < 1; MMT2 = 1; end
    if add_space_y < 0.1; add_space_y = 0.1; end
end
y_lim = [mmT2 - add_space_y MMT2 + add_space_y];
axis([0.5 length(inplot_T2)+0.5 y_lim(1) y_lim(2)])
if get(handles.pop_normalisation,'Value') == 2
    line([0.5 length(inplot_T2)+0.5],[-1 -1],'Color','r','LineStyle',':')
    line([0.5 length(inplot_T2)+0.5],[1 1],'Color','r','LineStyle',':')
end
title(title_list{2})
box on
hold off
% plot Qres
if external; subplot(3,1,3); else; axes(handles.plot_Qres); end
cla;
hold on
box on
bar(inplot_Qres,'k')
if length(inplot_Qres) < 20
    set(gca,'XTick',[1:length(inplot_Qres)])
    set(gca,'XTickLabel',handles.data.variable_labels)
end
xlabel('variables')
mmQres = min(min(inplot_Qres));
MMQres = max(max(inplot_Qres));
range_y = max(inplot_Qres) - min(inplot_Qres);
add_space_y = range_y/20;
if get(handles.pop_normalisation,'Value') == 2
    if mmQres > -1; mmQres = -1; end
    if MMQres < 1; MMQres = 1; end
    if add_space_y < 0.1; add_space_y = 0.1; end 
end
y_lim = [mmQres - add_space_y MMQres + add_space_y];
axis([0.5 length(inplot_Qres) + 0.5 y_lim(1) y_lim(2)])
if get(handles.pop_normalisation,'Value') == 2
    line([0.5 length(inplot_Qres)+0.5],[-1 -1],'Color','r','LineStyle',':')
    line([0.5 length(inplot_Qres)+0.5],[1 1],'Color','r','LineStyle',':')
end
title(title_list{3})
box on
hold off
