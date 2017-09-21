function varargout = visualize_pca(varargin)

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
                   'gui_OpeningFcn', @visualize_pca_OpeningFcn, ...
                   'gui_OutputFcn',  @visualize_pca_OutputFcn, ...
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


% --- Executes just before visualize_pca is made visible.
function visualize_pca_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(hObject,'Position',[103.8571 9.6471 134.5714 49.8235]);
set(handles.visualize_pca,'Position',[103.8571 9.6471 134.5714 49.8235]);
set(handles.legend_chk,'Position',[3 33.6923 20.2 1.1538]);
set(handles.view_sample_button,'Position',[3.4 31.3077 21.8 1.7692]);
set(handles.scal_load_chk,'Position',[3 35.4615 20.2 1.1538]);
set(handles.export_text,'Position',[3.8 26.2308 8.4 1.1538]);
set(handles.pca_title_text,'Position',[3 48.0769 13 1.1538]);
set(handles.score_lab_chk,'Position',[3 38.8462 16.6 1.1538]);
set(handles.loading_title_text,'Position',[39.8 23.5385 90.2 1.1538]);
set(handles.score_title_text,'Position',[40.2 48.0769 90.4 1.1538]);
set(handles.open_loading_button,'Position',[3.4 20.2308 21.8 1.9231]);
set(handles.open_score_button,'Position',[3.4 23.2308 22 1.8462]);
set(handles.y_pop,'Position',[3 41.1538 20.6 1.7692]);
set(handles.x_pop,'Position',[3 44.8462 20.6 1.6923]);
set(handles.var_lab_chk,'Position',[3 37 19.6 1.3846]);
set(handles.frame5,'Position',[1.4 18.3846 26 8.2308]);
set(handles.text3,'Position',[3 46.3846 10 1.2308]);
set(handles.text4,'Position',[3 42.7692 10.2 1.2308]);
set(handles.frame_pca,'Position',[1.4 30.3846 26.6 18]);
set(handles.loading_plot,'Position',[39.8 3.3846 91.2 20]);
set(handles.score_plot,'Position',[39.8 27.9231 91.2 20]);
set(handles.output,'Position',[103.8571 9.6471 134.5714 49.8235]);
movegui(handles.visualize_pca,'center');
handles.model = varargin{1};
handles.datapred_to_plot = varargin{2};

% set x and y combo
str_disp = {};
str_disp{1} = 'samples/variables';
for k = 1:handles.model.set.num_comp;
    str_disp{k + 1} = (['PC ' num2str(k)]);
end
str_disp{k + 2} = 'Q residuals';
str_disp{k + 3} = 'Hotelling T^2';
set(handles.x_pop,'String',str_disp);
str_disp = {};
for k = 1:handles.model.set.num_comp;
    str_disp{k} = (['PC ' num2str(k)]);
end
str_disp{k + 1} = 'Q residuals';
str_disp{k + 2} = 'Hotelling T^2';
set(handles.y_pop,'String',str_disp);

if handles.model.set.num_comp > 1
    set(handles.x_pop,'Value',2);
    set(handles.y_pop,'Value',2);    
else
    set(handles.x_pop,'Value',1);
    set(handles.y_pop,'Value',1);
end

if length(handles.model.set.class) == 0 && length(handles.model.set.response) == 0
    set(handles.legend_chk,'Enable','off');
    set(handles.legend_chk,'Value',0);
else
    set(handles.legend_chk,'Enable','on');
    set(handles.legend_chk,'Value',1);
end
    
update_plot(handles,[1 1],0);
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = visualize_pca_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% --- Executes during object creation, after setting all properties.
function x_pop_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in x_pop.
function x_pop_Callback(hObject, eventdata, handles)
update_plot(handles,[1 1],0)

% --- Executes during object creation, after setting all properties.
function y_pop_CreateFcn(hObject, eventdata, handles)
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on selection change in y_pop.
function y_pop_Callback(hObject, eventdata, handles)
update_plot(handles,[1 1],0)

% --- Executes on button press in open_score_button.
function open_score_button_Callback(hObject, eventdata, handles)
update_plot(handles,[1 0],1)

% --- Executes on button press in open_loading_button.
function open_loading_button_Callback(hObject, eventdata, handles)
update_plot(handles,[0 1],1)

% --- Executes on button press in score_lab_chk.
function score_lab_chk_Callback(hObject, eventdata, handles)
update_plot(handles,[1 0],0)

% --- Executes on button press in var_lab_chk.
function var_lab_chk_Callback(hObject, eventdata, handles)
update_plot(handles,[0 1],0)

% --- Executes on button press in scal_load_chk.
function scal_load_chk_Callback(hObject, eventdata, handles)
update_plot(handles,[0 1],0)

% --- Executes on button press in legend_chk.
function legend_chk_Callback(hObject, eventdata, handles)
update_plot(handles,[1 0],0)

% --- Executes on button press in view_sample_button.
function view_sample_button_Callback(hObject, eventdata, handles)
select_sample(handles)

% ---------------------------------------------------------
function update_plot(handles,update_this,external)

% settings
T = handles.model.T;
L = handles.model.L;
exp_var = handles.model.exp_var;
qlim = handles.model.set.qlim;
tlim = handles.model.set.tlim;
plot_pred = 0;
if isfield(handles.model,'Tpred'); 
    plot_pred = 1;
    Tpred = handles.model.Tpred;
end

col_ass = visualize_colors;

if length(handles.model.labels.sample_labels) > 0
    sample_labels = handles.model.labels.sample_labels;
else
    for k=1:size(T,1); sample_labels{k} = num2str(k); end
end
if length(handles.model.labels.variable_labels) > 0
    variable_labels = handles.model.labels.variable_labels;
else
    for k=1:size(L,1); variable_labels{k} = num2str(k); end
end

class_in = handles.model.set.class;
response_in = handles.model.set.response;
if plot_pred
    class_pred = handles.model.set.class_pred;
    response_pred = handles.model.set.response_pred;
end
label_scores   = get(handles.score_lab_chk, 'Value');
label_loadings = get(handles.var_lab_chk, 'Value');
scale_loadings = get(handles.scal_load_chk, 'Value');
show_legend    = get(handles.legend_chk, 'Value');

x = get(handles.x_pop, 'Value');
y = get(handles.y_pop, 'Value');

if x == 1
    Tx = [1:size(T,1)]';
    if plot_pred; Tx_pred = [max(Tx)+1:max(Tx)+size(Tpred,1)]'; end
    Lx = [1:size(L,1)];
    lab_Tx = 'samples';
    lab_Lx = 'variables';
elseif x <= handles.model.set.num_comp + 1;
    Tx = T(:,x - 1);
    if plot_pred; Tx_pred = Tpred(:,x - 1); end
    Lx = L(:,x - 1);
    lab_Tx = (['PC ' num2str(x - 1) ' - EV = ' num2str(round(exp_var(x - 1)*10000)/100) '%']);
    lab_Lx = (['PC ' num2str(x - 1) ' - EV = ' num2str(round(exp_var(x - 1)*10000)/100) '%']);
elseif x == handles.model.set.num_comp + 2;
    Tx = handles.model.Qres';
    if plot_pred; Tx_pred = handles.model.Qres_pred'; end
    Lx = NaN;
    lab_Tx = 'Q residuals';
    lab_Lx = 'none';
else
    Tx = handles.model.Thot';
    if plot_pred; Tx_pred = handles.model.Thot_pred'; end
    Lx = NaN;
    lab_Tx = 'Hotelling T^2';
    lab_Lx = 'none';
end

if y <= handles.model.set.num_comp;
    Ty = T(:,y);
    if plot_pred; Ty_pred = Tpred(:,y); end
    Ly = L(:,y);
    lab_Ty = (['PC ' num2str(y) ' - EV = ' num2str(round(exp_var(y)*10000)/100) '%']);
    lab_Ly = (['PC ' num2str(y) ' - EV = ' num2str(round(exp_var(y)*10000)/100) '%']);
elseif y == handles.model.set.num_comp + 1;
    Ty = handles.model.Qres';
    if plot_pred; Ty_pred = handles.model.Qres_pred'; end
    Ly = NaN;
    lab_Ty = 'Q residuals';
    lab_Ly = 'none';
else
    Ty = handles.model.Thot';
    if plot_pred; Ty_pred = handles.model.Thot_pred'; end
    Ly = NaN;
    lab_Ty = 'Hotelling T^2';
    lab_Ly = 'none';
end

% display scores
if update_this(1)
    if external; figure; title('score plot'); set(gcf,'color','white'); box on; else; axes(handles.score_plot); end
    cla;
    hold on
    if length(class_in) > 0  
        for g=1:max(class_in)
            in_c = find(class_in==g);
            c = col_ass(g + 1,:);
            plot(Tx(in_c),Ty(in_c),'o','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor',c)
            legend_label{g} = ['class ' num2str(g)];
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
    % plot predicted scores
    if plot_pred 
        if length(class_pred) > 0
            for g=1:max(class_pred)
                in_c = find(class_pred==g);
                c = col_ass(g + 1,:);
                plot(Tx_pred(in_c),Ty_pred(in_c),'d','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor',c)
            end
        elseif length(response_pred) > 0
            if length(response_in) > 0
                [My,wheremax] = max(response_in);
                [my,wheremin] = min(response_in);
            else
                [My,wheremax] = max(response_pred);
                [my,wheremin] = min(response_pred);                
            end
            for g=1:length(response_pred)
                color_here = 1 - (response_pred(g) - my)/(My - my);
                color_in = [color_here color_here color_here];
                color_in(find(color_in > 1)) = 1;
                color_in(find(color_in < 0)) = 0;
                plot(Tx_pred(g),Ty_pred(g),'d','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor',color_in)
            end
        else
            plot(Tx_pred,Ty_pred,'*','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor','k')
        end
    end
    
    % set max and min for axis
    if plot_pred
        range_x = max([Tx;Tx_pred]) - min([Tx;Tx_pred]); add_space_x = range_x/20;      
        x_lim = [min([Tx;Tx_pred])-add_space_x max([Tx;Tx_pred])+add_space_x];
        range_y = max([Ty;Ty_pred]) - min([Ty;Ty_pred]); add_space_y = range_y/20;
        y_lim = [min([Ty;Ty_pred])-add_space_y max([Ty;Ty_pred])+add_space_y];
    else
        range_x = max(Tx) - min(Tx); add_space_x = range_x/20;      
        x_lim = [min(Tx)-add_space_x max(Tx)+add_space_x];
        range_y = max(Ty) - min(Ty); add_space_y = range_y/20;
        y_lim = [min(Ty)-add_space_y max(Ty)+add_space_y];
    end
    
    if x < handles.model.set.num_comp + 2 && x > 1
        if x_lim(1) < 0 && x_lim(2) > 0; line([0 0],y_lim,'Color','k','LineStyle',':'); end
    elseif x == handles.model.set.num_comp + 2
        line([qlim qlim],y_lim,'Color','r','LineStyle',':')
    elseif x == handles.model.set.num_comp + 3
        line([tlim tlim],y_lim,'Color','r','LineStyle',':')
    end
    
    if y < handles.model.set.num_comp + 1
        if y_lim(1) < 0 && y_lim(2) > 0; line(x_lim,[0 0],'Color','k','LineStyle',':'); end
    elseif y == handles.model.set.num_comp + 1
        line(x_lim,[qlim qlim],'Color','r','LineStyle',':')
    elseif y == handles.model.set.num_comp + 2
        line(x_lim,[tlim tlim],'Color','r','LineStyle',':')
    end
    
    % add labels
    if label_scores
        plot_string_label(Tx,Ty,'k',sample_labels,range_x);
    end
    if plot_pred
        if label_scores
            plot_string_label(Tx_pred,Ty_pred,'k',handles.model.labels.sample_labels_pred,range_x);
        end
    end
    
    axis([x_lim(1) x_lim(2) y_lim(1) y_lim(2)])
    xlabel(lab_Tx)
    ylabel(lab_Ty)
    if (length(class_in) > 0 || length(response_in)) & show_legend == 1
        legend(legend_label)
    else
        legend off
    end
    hold off
end

% display loadings
if update_this(2) & x < handles.model.set.num_comp + 2 & y < handles.model.set.num_comp + 1
    if external; figure; title('loading plot'); set(gcf,'color','white'); box on; else; axes(handles.loading_plot); end
    cla;
    hold on
    if x == 1
        plot(Lx,Ly,'k')
    end
    plot(Lx,Ly,'o','MarkerEdgeColor','k','MarkerSize',5,'MarkerFaceColor',[1 0.4 0.4])
    if label_loadings
        range_span = (max(Lx) - min(Lx));
        plot_string_label(Lx,Ly,'k',variable_labels,range_span); 
    end
    xlabel(lab_Lx)
    ylabel(lab_Ly)
    
    if scale_loadings
        x_lim = [-1.1 1.1];
        y_lim = [-1.1 1.1];
    else
        range_x = max(Lx) - min(Lx); add_space_x = range_x/20;
        range_y = max(Ly) - min(Ly); add_space_y = range_y/20;
        x_lim = [min(Lx)-add_space_x max(Lx)+add_space_x];
        y_lim = [min(Ly)-add_space_y max(Ly)+add_space_y];
    end
    
    if x == 1
        axis([0.5 size(L,1)+0.5 y_lim(1) y_lim(2)])
        line([0.5 size(L,1)+0.5],[0 0],'Color','k','LineStyle',':')
        set(gca,'XTick',[1:size(L,1)])
        if scale_loadings
            set(gca,'YTick',[-1 -0.5 0 0.5 1])
        end
    else      
        axis([x_lim(1) x_lim(2) y_lim(1) y_lim(2)])
        line([x_lim(1) x_lim(2)],[0 0],'Color','k','LineStyle',':')
        line([0 0],[y_lim(1) y_lim(2)],'Color','k','LineStyle',':')
        if scale_loadings
            set(gca,'XTick',[-1 -0.5 0 0.5 1])
            set(gca,'YTick',[-1 -0.5 0 0.5 1])
        end
    end
    hold off
elseif update_this(2) & (x >= handles.model.set.num_comp + 2 | y >= handles.model.set.num_comp + 1);
    if external; figure; title('loading plot'); set(gcf,'color','white'); box on; else; axes(handles.loading_plot); end
    cla;
    hold on
    text(-0.25,0,'loadings not available')
    axis([-1 1 -1 1])
    xlabel('')
    ylabel('')
    set(gca,'XTick',[])
    set(gca,'YTick',[])
    hold off
end

% ---------------------------------------------------------
function plot_string_label(X,Y,col,lab,range_span)
add_span = range_span/100;
for j=1:length(X); text(X(j)+add_span,Y(j),lab{j},'Color',col); end;

% ---------------------------------------------------------
function select_sample(handles)

T = handles.model.T;
plot_pred = 0;
if isfield(handles.model,'Tpred'); 
    plot_pred = 1;
    Tpred = handles.model.Tpred;
end
x = get(handles.x_pop, 'Value');
y = get(handles.y_pop, 'Value');
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

if x == 1
    Tx = [1:size(T,1)];
    Tx = Tx';
    if plot_pred; Tx = [Tx;[max(Tx) + 1:max(Tx) + size(Tpred,1)]']; end
elseif x <= handles.model.set.num_comp + 1;
    Tx = T(:,x - 1);
    if plot_pred; Tx = [Tx;Tpred(:,x - 1)]; end
elseif x == handles.model.set.num_comp + 2;
    Tx = handles.model.Qres;
    Tx = Tx';
    if plot_pred; Tx = [Tx;handles.model.Qres_pred']; end
else
    Tx = handles.model.Thot;
    Tx = Tx';
    if plot_pred; Tx = [Tx;handles.model.Thot_pred']; end
end

if y <= handles.model.set.num_comp;
    Ty = T(:,y);
    if plot_pred; Ty = [Ty;Tpred(:,y)]; end
elseif y == handles.model.set.num_comp + 1;
    Ty = handles.model.Qres;
    Ty= Ty';
    if plot_pred; Ty = [Ty;handles.model.Qres_pred']; end
else
    Ty = handles.model.Thot;
    Ty = Ty';
    if plot_pred; Ty = [Ty;handles.model.Thot_pred']; end
end

if plot_pred
    for k=1:size(Tpred,1); sample_labels{k + size(T,1)} = handles.model.labels.sample_labels_pred{k}; end
    raw_data = [raw_data;handles.datapred_to_plot];
end

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
[datain_scal] = test_pretreatment(datain,handles.model.set.param);
if plot_pred
    Tcont_all = [handles.model.Tcont; handles.model.Tcont_pred];
    Qcont_all = [handles.model.Qcont; handles.model.Qcont_pred];
    inplotT2 = Tcont_all(closest,:);
    inplotQres = Qcont_all(closest,:);
else
    inplotT2 = handles.model.Tcont(closest,:);
    inplotQres = handles.model.Qcont(closest,:);
end
visualize_sample(datain,datain_scal,variable_labels,sample_labels{closest},inplotT2,inplotQres,handles.model.Tcont,handles.model.Qcont);
