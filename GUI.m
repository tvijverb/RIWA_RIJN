function [] = GUI()
%% Created by Thomas Vijverberg on 26-04-2016 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 26-04-2016

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% Start of the script
% Initialize figure
S.fh = figure('units','pixels',...
    'position',[50 50 1000 600],...
    'menubar','none',...
    'name','Comprehensive Quality Assessment of Dutch Surface Water',...
    'numbertitle','off',...
    'resize','off',...
    'closerequestfcn',{@fh_crfcn});
S.ax = axes;
%set(S.ax, 'Visible','off');
axis([0 10 0 10]);
axis off
% Set background color
 set (S.fh, 'Color', [0.1 0.1 0.1] )
% axes(handles.layoutAxes);
% rectangle('Position', [X_coordinate(i), Y_coordinate(i), 2, hdend(n, 1)]);

%% Initialize objects
S.r_load = rectangle('Position',[3 9 3 1],'Curvature',0.2);
S.r_load.FaceColor = [1 1 1];
S.r_load.EdgeColor = [0 1 1];
S.r_load.LineWidth = 3;

S.r_and = rectangle('Position',[1 7 3 1],'Curvature',0.2);
S.r_and.FaceColor = [1 1 1];
S.r_and.EdgeColor = [0 1 1];
S.r_and.LineWidth = 3;

S.r_lob = rectangle('Position',[5 7 3 1],'Curvature',0.2);
S.r_lob.FaceColor = [1 1 1];
S.r_lob.EdgeColor = [0 1 1];
S.r_lob.LineWidth = 3;

drawnow();
S.r_load.FaceColor = [1 1 0];
drawnow();
SMat = load('S.mat');
S.r_load.FaceColor = [0 1 0];
function [] = fh_crfcn(varargin)
        % Closerequestfcn for figures.
        delete(S.fh) % Delete all figures stored in structure.
end
end