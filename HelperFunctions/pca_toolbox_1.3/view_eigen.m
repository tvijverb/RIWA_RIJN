function view_eigen(E,exp_var,cum_var)

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

str{1,1} = 'component';
str{1,2} = 'eigenvalue';
str{1,3} = 'explained variance %';
str{1,4} = 'cumulative variance %';
for k=1:length(E)
    str{k+1,1} = ['PC' num2str(k)];
    str{k+1,2} = num2str(E(k));
    str{k+1,3} = num2str((exp_var(k)*100*100)/100);
    str{k+1,4} = num2str((cum_var(k)*100*100)/100);
end
assignin('base','tmp_view',str);
openvar('tmp_view');