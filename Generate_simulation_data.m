function [ X1,X2,X3,X4,X5,X6,X7,X8,X9,X10,X11,Y1,Y2,Y3,Y4,Y5,Y6,Y7,Y8,Y9,Y10,Y11 ] = Generate_simulation_data()
%% Created by Thomas Vijverberg on 14-04-2016 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 19-04-2016

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% Start of the script

%% Generate N normally distributed random numbers (sigma = 1)
N = 1e6; 
z = -sqrt(2) * erfcinv(2 * rand(N, 1));   %Inverse Transformation Method z is randn pool
z2 = z + 10;                                %Shift mean
z3 = z + (pi/6);                            %Shift mean

%% X1 Linear
% Sample random number matrix 60x10 out of randn pool
% X is causal matrix
tic;
sigmaa = 0.1;
X1 = randi([1 1e6],60,10);
[rows,columns] = size(X1);
for i = 1 : rows
    for j = 1 : columns
        X1(i,j) = z2(X1(i,j));
    end
end

% Sample random number matrix 1x10 out of randn pool
% a is needed to calculate effect matrix
a = randi([1 1e6],60,1);
[rows,columns] = size(a);
for j = 1 : rows
    a(j) = z(a(j));
end

% Calculate effect matrix Y
for i = 1 : 60
    Y1(i) = sum( X1(i,:)  + sigmaa * a(i));
end

%% X2 Non-Linear 1/X
% Sample random number matrix 60x10 out of randn pool
% X is causal matrix
sigmaa = 0.01;
X2 = randi([1 1e6],60,10);
[rows,columns] = size(X2);
for i = 1 : rows
    for j = 1 : columns
        X2(i,j) = z2(X2(i,j))^-1;
    end
end

% Sample random number matrix 1x10 out of randn pool
% a is needed to calculate effect matrix
a = randi([1 1e6],60,1);
[rows,columns] = size(a);
for j = 1 : rows
    a(j) = z(a(j));
end

% Calculate effect matrix Y
for i = 1 : 60
    Y2(i) = sum( X2(i,:)  + sigmaa * a(i));
end

%% X3 Non-linear X^3
% Sample random number matrix 60x10 out of randn pool
% X is causal matrix
sigmaa = 2;
X3 = randi([1 1e6],60,10);
[rows,columns] = size(X3);
for i = 1 : rows
    for j = 1 : columns
        X3(i,j) = z2(X3(i,j))^3;
    end
end

% Sample random number matrix 1x10 out of randn pool
% a is needed to calculate effect matrix
a = randi([1 1e6],60,1);
[rows,columns] = size(a);
for j = 1 : rows
    a(j) = z(a(j));
end

% Calculate effect matrix Y
for i = 1 : 60
    Y3(i) = sum( X3(i,:)  + sigmaa * a(i));
end

%% X4 Non-linear sqrt(X)
% Sample random number matrix 60x10 out of randn pool
% X is causal matrix
sigmaa = 2;
X4 = randi([1 1e6],60,10);
[rows,columns] = size(X4);
for i = 1 : rows
    for j = 1 : columns
        X4(i,j) = sqrt(z2(X4(i,j)));
    end
end

% Sample random number matrix 1x10 out of randn pool
% a is needed to calculate effect matrix
a = randi([1 1e6],60,1);
[rows,columns] = size(a);
for j = 1 : rows
    a(j) = z(a(j));
end

% Calculate effect matrix Y
for i = 1 : 60
    Y4(i) = sum( X4(i,:)  + sigmaa * a(i));
end

%% X5 Non-linear X with autocorrelation
% Sample random number matrix 60x10 out of randn pool
% X is causal matrix

a = randi([1 1e6],60,1);
[rows,columns] = size(a);
for j = 1 : rows
    a(j) = z(a(j));
end

N = 0;

sigmaa = 0.1;
X5 = randi([1 1e6],60,10);
[rows,columns] = size(X5);
for i = 1 : rows
    for j = 1 : columns
        X5(i,j) = z2(X5(i,j));
    end
end

% Sample random number matrix 1x10 out of randn pool
% a is needed to calculate effect matrix


% Calculate effect matrix Y
for i = 1 : 60
    Y5(i) = sum( X5(i,:)  + sigmaa * N);
    N = 0.5 * N + a(i);
end

%% X6 Non-linear X with autocorrelation lognormal noise
% Sample random number matrix 60x10 out of randn pool
% X is causal matrix

a = randi([1 1e6],60,1);
[rows,columns] = size(a);
for j = 1 : rows
    a(j) = z(a(j));
end

N = 0;

sigmaa = 0.5;
X6 = randi([1 1e6],60,10);
[rows,columns] = size(X6);
for i = 1 : rows
    for j = 1 : columns
        X6(i,j) = z2(X6(i,j));
    end
end

% Sample random number matrix 1x10 out of randn pool
% a is needed to calculate effect matrix


% Calculate effect matrix Y
for i = 1 : 60
    Y6(i) = sum( X6(i,:)  + sigmaa * (exp(N)/5.8784));
    N = 0.5 * N + a(i);
end

%% X7 Non-linear X with autocorrelation uniform noise
% Sample random number matrix 60x10 out of randn pool
% X is causal matrix

N = 0;
sigmaa = 0.5;
X7 = randi([1 1e6],60,10);
[rows,columns] = size(X7);
for i = 1 : rows
    for j = 1 : columns
        X7(i,j) = z2(X7(i,j));
    end
end

% Sample random number matrix 1x10 out of randn pool
% a is needed to calculate effect matrix


% Calculate effect matrix Y
for i = 1 : 60
    Y7(i) = sum( X7(i,:)  + sigmaa * N);
    N = 0.5 * N + rand(1);
end

%% X8 Non-linear exp(X) with autocorrelation lognormal noise
% Sample random number matrix 60x10 out of randn pool
% X is causal matrix

a = randi([1 1e6],60,1);
[rows,columns] = size(a);
for j = 1 : rows
    a(j) = z(a(j));
end

N = 0;

sigmaa = 2;
X8 = randi([1 1e6],60,10);
[rows,columns] = size(X8);
for i = 1 : rows
    for j = 1 : columns
        X8(i,j) = exp(z2(X8(i,j)));
    end
end

% Sample random number matrix 1x10 out of randn pool
% a is needed to calculate effect matrix


% Calculate effect matrix Y
for i = 1 : 60
    Y8(i) = sum( X8(i,:)  + sigmaa * (exp(N)/5.8784));
    N = 0.5 * N + a(i);
end

%% X9 Linear season-effect simulation with normal noise
% Sample random number matrix 60x10 out of randn pool
% X is causal matrix

a = randi([1 1e6],60,1);
[rows,columns] = size(a);
for j = 1 : rows
    a(j) = z(a(j));
end

w = randi([1 1e6],10,1);
[rows,columns] = size(w);
for j = 1 : rows
    w(j) = z3(w(j));
end

X9(:,1) = sin([1:60]*w(1));
X9(:,2) = sin(2*[1:60]*w(2));
X9(:,3) = cos([1:60]*w(3));
X9(:,4) = cos(2*[1:60]*w(4));
X9(:,5) = sin(3*[1:60]*w(5));
X9(:,6) = sin(4*[1:60]*w(6));
X9(:,7) = cos(3*[1:60]*w(7));
X9(:,8) = cos(4*[1:60]*w(8));
X9(:,9) = sin([1:60]*w(9))+sin(2*[1:60]*w(9));
X9(:,10) = cos([1:60]*w(10))+cos(2*[1:60]*w(10));

% Calculate effect matrix Y
for i = 1 : 60
    Y9(i) = 0.6235 * cos(i * pi / 6) - 1.3501 * sin(i * pi / 6) - 1.1622 * cos(i * pi / 3) - 0.9443 * sin(i * pi / 3) + 0.8 * a(i); ;
end

%% X10 Linear season-effect simulation with normal noise
% Sample random number matrix 60x10 out of randn pool
% X is causal matrix

a = randi([1 1e6],60,1);
[rows,columns] = size(a);
for j = 1 : rows
    a(j) = z(a(j));
end

w = randi([1 1e6],10,1);
[rows,columns] = size(w);
for j = 1 : rows
    w(j) = z3(w(j));
end

X10(:,1) = sin([1:60]*w(1));
X10(:,2) = sin(2*[1:60]*w(2));
X10(:,3) = cos([1:60]*w(3));
X10(:,4) = cos(2*[1:60]*w(4));
X10(:,5) = sin(3*[1:60]*w(5));
X10(:,6) = sin(4*[1:60]*w(6));
X10(:,7) = cos(3*[1:60]*w(7));
X10(:,8) = cos(4*[1:60]*w(8));
X10(:,9) = sin([1:60]*w(9))+sin(2*[1:60]*w(9));
X10(:,10) = cos([1:60]*w(10))+cos(2*[1:60]*w(10));

% Calculate effect matrix Y
for i = 1 : 60
    Y10(i) = 0.6235 * cos(i * pi / 6) - 1.3501 * sin(i * pi / 6) - 1.1622 * cos(i * pi / 3) - 0.9443 * sin(i * pi / 3) + 0.08 * a(i); ;
end

%% X11 Linear season-effect simulation with normal noise
% Sample random number matrix 60x10 out of randn pool
% X is causal matrix

a = randi([1 1e6],60,1);
[rows,columns] = size(a);
for j = 1 : rows
    a(j) = z(a(j));
end

w = randi([1 1e6],10,1);
[rows,columns] = size(w);
for j = 1 : rows
    w(j) = z3(w(j));
end

X11(:,1) = sin([1:60]*w(1));
X11(:,2) = sin(2*[1:60]*w(2));
X11(:,3) = cos([1:60]*w(3));
X11(:,4) = cos(2*[1:60]*w(4));
X11(:,5) = sin(3*[1:60]*w(5));
X11(:,6) = sin(4*[1:60]*w(6));
X11(:,7) = cos(3*[1:60]*w(7));
X11(:,8) = cos(4*[1:60]*w(8));
X11(:,9) = sin([1:60]*w(9))+sin(2*[1:60]*w(9));
X11(:,10) = cos([1:60]*w(10))+cos(2*[1:60]*w(10));

% Calculate effect matrix Y
for i = 1 : 60
    Y11(i) = 0.6235 * cos(i * pi / 6) - 1.3501 * sin(i * pi / 6) - 1.1622 * cos(i * pi / 3) - 0.9443 * sin(i * pi / 3) + 0.008 * a(i); ;
end
%%



% Fs = 10;                   % samples per second
%    dt = 1/Fs;                   % seconds per sample
%    StopTime = 6;             % seconds
%    t = (0:dt:StopTime-dt)';     % seconds
%    %% Sine wave:
%    Fc = 0.5;                     % hertz
%    x = sin(2*pi*Fc*t);
%    % Plot the signal versus time:
%    figure;
%     plot(Y10);
%     xlabel('time (in seconds)','Fontsize',24);
%     title('Simulated data Y10','Fontsize',24);
%    title('Signal versus Time');
%    zoom xon;

end

