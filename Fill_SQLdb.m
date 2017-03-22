function [ output_args ] = Fill_SQLdb( S )
%% Created by Thomas Vijverberg on 29-04-2016 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 29-04-2016

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIALIZE JDBC database connection to PostgreSQL server
%Toolbox check
tic
disp('Verifying presence of the Database Toolbox');
license checkout Control_Toolbox;
disp('Database Toolbox is available!');
disp(' ');

%% Connect to PostgreSQL server
disp('Establishing connection');

conn = database('test','riwa','slaapies','Vendor','PostgreSQL','Server','127.0.0.1');
if(~isempty(conn.Message))
    error('Database connection to SQL server unsuccesful. Doublecheck your connection parameters.');
end
disp('Connection established!');

% Check read privileges
if(isstruct(exec(conn,'select * from concentrationdata.data')))
    error('Could not gain read acces to SCHEMA concentrationdata TABLE data');
end
disp('Read access to SCHEMA concentrationdata TABLE data secured');

% Check existance of previous database
disp('Testing previous database existance');
columnlist = columnnames(fetch(exec(conn,'select * from concentrationdata.lobithr860')));
% Clear database option
if(~isempty(columnlist))
    prompt = 'Database is already filled. Clear it? Y/N [N]: ';
    str = input(prompt,'s');
    if isempty(str)
        str = 'N';
    end
    switch str
        case 'y'
            exec(conn,'DROP TABLE concentrationdata.andijkr1100');
            exec(conn,'DROP TABLE concentrationdata.eijsdenm615');
            exec(conn,'DROP TABLE concentrationdata.heelm690');
            exec(conn,'DROP TABLE concentrationdata.keizersveerm865');
            exec(conn,'DROP TABLE concentrationdata.lobithr860');
            disp('Removed existing databases');
        case 'Y'
            exec(conn,'DROP TABLE concentrationdata.andijkr1100');
            exec(conn,'DROP TABLE concentrationdata.eijsdenm615');
            exec(conn,'DROP TABLE concentrationdata.heelm690');
            exec(conn,'DROP TABLE concentrationdata.keizersveerm865');
            exec(conn,'DROP TABLE concentrationdata.lobithr860');
            disp('Removed existing databases');
        otherwise
    end
end

%% Create databases
[meas, var] = size(S(5).Xcleaned);
S(5).X = S(5).X(~isnan(cell2mat(S(5).X(:,4))),:);
rownotnan = zeros(meas,1);
for i = 1:meas
    rownotnan(i) = sum(isnan(S(5).Xcleaned(i,:)));
end
S(5).Xcleaned = S(5).Xcleaned(~(rownotnan == var),:);

prompt = 'Fill measurement DB [M] / Fill: variable DB [D]';
str = input(prompt,'s');
    if isempty(str)
        str = 'Y';
    end
    switch str
        case 'M'
            for place_index = 1 : 5
            disp(['Creating database ' ,num2str(place_index), ' of 5']);
            %Determining number of measurements and number of variables,
            %Preallocate dates and variables
            %Copy dates and variables to struct S
            [meas, var] = size(S(place_index).Xcleaned);
            S(place_index).metadata_date = cell(meas,2);
            S(place_index).metadata_var = cell(var,1);
            S(place_index).metadata_date(:,1) = unique(cellstr(vertcat(S(place_index).X{:,3})),'stable');
            S(place_index).metadata_date(:,2) = num2cell(datenum(vertcat(S(place_index).metadata_date{:,1})));
            S(place_index).metadata_var(:,1) = unique(vertcat(S(place_index).X(:,5)),'stable');

            %Build SQL query for PostgreSQL database
            SQL_query_base  = 'CREATE TABLE concentrationdata.';
            SQL_query_place_index_temp = S(place_index).name((S(place_index).name ~= ' '));
            SQL_query_place_index_temp = SQL_query_place_index_temp(SQL_query_place_index_temp ~= '(');
            SQL_query_place_index = SQL_query_place_index_temp(SQL_query_place_index_temp ~= ')');
            SQL_query_vars = '(date date, datenum numeric,';

            for varlen = 1 : var
                newcolumn = strcat('var',S(place_index).metadata_var(varlen),' numeric,');
                SQL_query_vars = strcat(SQL_query_vars,newcolumn);
            end
            SQL_query_vars = SQL_query_vars{1}(1:end-1);
            SQL_query_vars = strcat(SQL_query_vars,');');
            SQL_query = strcat(SQL_query_base,SQL_query_place_index,SQL_query_vars);

            %Execute SQL query
            exec(conn,SQL_query);
            end

            for place_index = 1 : 5
                disp(['Inserting measurements into database: ' ,num2str(place_index), ' of 5']);
                %Determining number of measurements and number of variables,
                %Preallocate dates and variables
                %Copy dates and variables to struct S
                [meas, var] = size(S(place_index).Xcleaned);
                for meas_len = 1 : meas
                    S(place_index).metadata_date(meas_len,1) = cellstr(S(place_index).metadata_date{meas_len,1}(1:11));
                end

            %Build SQL query for PostgreSQL database
            SQL_query_base  = 'INSERT INTO concentrationdata.';
            SQL_query_place_index_temp = S(place_index).name((S(place_index).name ~= ' '));
            SQL_query_place_index_temp = SQL_query_place_index_temp(SQL_query_place_index_temp ~= '(');
            SQL_query_place_index = SQL_query_place_index_temp(SQL_query_place_index_temp ~= ')');
            SQL_query_vars = '(date,datenum,';

            for varlen = 1 : var
                newcolumn = strcat('var',S(place_index).metadata_var(varlen),',');
                SQL_query_vars = strcat(SQL_query_vars,newcolumn);
            end
            SQL_query_vars = SQL_query_vars{1}(1:end-1);
            SQL_query_vars = strcat(SQL_query_vars,')');
            q = char(39);
            for meas_len = 1 : meas
                SQL_query_meas = strcat(' VALUES(',q,S(place_index).metadata_date(meas_len,1),q,',',num2str(S(place_index).metadata_date{meas_len,2}),',');
                for var_len = 1 : var
                    newmeas = strcat(q,num2str(S(place_index).Xcleaned(meas_len,var_len)),q,',');
                    SQL_query_meas = strcat(SQL_query_meas,newmeas);
                end
                SQL_query_meas = SQL_query_meas{1}(1:end-1);
                SQL_query_meas = strcat(SQL_query_meas,');');
                SQL_query = strcat(SQL_query_base,SQL_query_place_index,SQL_query_vars,SQL_query_meas);
                %Execute SQL query
                exec(conn,SQL_query);
            end
            end
        case 'D'
            exec(conn,'CREATE TABLE concentrationdata.variables(varname text,varid text,unit text);');
            SQL_query_base  = 'INSERT INTO concentrationdata.variables(varname,varid,unit) VALUES(';
            Scat = [];
            varid = [];
            for Slen = 1 : length(S)
                Scat = vertcat(Scat,S(Slen).X);
            end
            [varid,varidindex] = unique(Scat(:,5),'stable');
            varname = Scat(varidindex,6);
            unit = Scat(varidindex,9);
            quote = sprintf( '\''' );
            
            for varidlen = 1 : length(varid)
                SQL_query_data = strcat(varname(varidlen),quote,',',quote,varid(varidlen),quote,',',quote,unit(varidlen));
                SQL_query = strcat(SQL_query_base,quote,SQL_query_data,quote,');');
                exec(conn,SQL_query{1,1});
            end
                
    disp('SQL database updated. Runtime:');
    toc
    end
end

