function [X1,X2,X3,X4,X5,X6,Y1,Y2,Y3,Y4,Y5,Y6 ] = Generate_simulation_data2( data_len );
%% Created by Thomas Vijverberg on 05-10-2017 at Radboud University Nijmegen
% Last edited by Thomas Vijverberg on 05-10-2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%OUTPUT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%% Start of the script

%% Generate N normally distributed random numbers (sigma = 1)
N = 1e6; 
z = (rand(N, 1)-0.5) * 10;   %Inverse Transformation Method z is rand pool

N = 1e6; 
z2 = randn(N, 1);   %Inverse Transformation Method z is randn pool
    
%% Linear X1 normal noise
figure(1);
a = randi(1e6,10,1);
noise_ind = randi(1e6,10*data_len,1);
noise = z2(noise_ind);
noise = reshape(noise,10,data_len)';

slope = z2(a);
offset = z(a);

for i = 1 : 10
    for j = 1 : data_len
        X1(j,i) = slope(i) * j + offset(i);
    end
end

Y1 = sum(X1');

X1 = X1 + noise*2;

Y1 = sum(X1');

plot(X1);
%fig2plotly(gcf);
close(gcf);

%% Nonlinear X2 1/X normal noise
figure(1);
a = randi(1e6,10,1);
noise_ind = randi(1e6,10*data_len,1);
noise = z2(noise_ind);
noise = reshape(noise,10,data_len)';

slope = z2(a);
offset = z(a);

for i = 1 : 10
    for j = 1 : data_len
        X2(j,i) = (40/j) + offset(i);
    end
end

Y2 = sum(X2');

X2 = X2 + noise*0.7;

plot(X2);
%fig2plotly(gcf);
close(gcf);

%% Nonlinear X3 X^3 uniform noise
figure(1);
a = randi(1e6,10,1);
noise_ind = randi(1e6,10*data_len,1);
noise = z(noise_ind);
noise = reshape(noise,10,data_len)';

slope = z2(a);
offset = z(a);

for i = 1 : 10
    for j = 1 : data_len
        X3(j,i) = slope(i) * 1.03^(j) + offset(i);
    end
end

Y3 = sum(X3');

X3 = X3 + noise*0.7;

plot(X3);
%fig2plotly(gcf);
close(gcf);

%% Nonlinear X4 sqrt uniform noise
figure(1);
a = randi(1e6,10,1);
noise_ind = randi(1e6,10*data_len,1);
noise = z2(noise_ind);
noise = reshape(noise,10,data_len)';

slope = z2(a);
offset = z(a);

for i = 1 : 10
    for j = 1 : data_len
        X4(j,i) = slope(i) * sqrt(j) + offset(i);
    end
end

Y4 = sum(X4');

X4 = X4 + noise*0.5;

plot(X4);
%fig2plotly(gcf);
close(gcf);

%% Nonlinear X5 seasonal effects normal noise
figure(1);
a = randi([1 1e6],data_len,1);
[rows,columns] = size(a);
for j = 1 : rows
    a(j) = z(a(j));
end

w = randi([1 1e6],10,1);
[rows,columns] = size(w);
for j = 1 : rows
    w(j) = z2(w(j));
end

X5(:,1) = sin([1:data_len]*w(1));
X5(:,2) = sin(2*[1:data_len]*w(2));
X5(:,3) = cos([1:data_len]*w(3));
X5(:,4) = cos(2*[1:data_len]*w(4));
X5(:,5) = sin(3*[1:data_len]*w(5));
X5(:,6) = sin(4*[1:data_len]*w(6));
X5(:,7) = cos(3*[1:data_len]*w(7));
X5(:,8) = cos(4*[1:data_len]*w(8));
X5(:,9) = sin([1:data_len]*w(9))+sin(2*[1:data_len]*w(9));
X5(:,10) = cos([1:data_len]*w(10))+cos(2*[1:data_len]*w(10));

Y5 = sum(X5');

X5 = X5 + noise*0.04;

plot(X5);
%fig2plotly(gcf);
close(gcf);

%% Nonlinear X6 seasonal effects uniform noise
figure(1);
a = randi([1 1e6],data_len,1);
[rows,columns] = size(a);
for j = 1 : rows
    a(j) = z(a(j));
end

w = randi([1 1e6],10,1);
[rows,columns] = size(w);
for j = 1 : rows
    w(j) = z2(w(j));
end

noise_ind = randi(1e6,10*data_len,1);
noise = z(noise_ind);
noise = reshape(noise,10,data_len)';

X6(:,1) = sin([1:data_len]*w(1));
X6(:,2) = sin(2*[1:data_len]*w(2));
X6(:,3) = cos([1:data_len]*w(3));
X6(:,4) = cos(2*[1:data_len]*w(4));
X6(:,5) = sin(3*[1:data_len]*w(5));
X6(:,6) = sin(4*[1:data_len]*w(6));
X6(:,7) = cos(3*[1:data_len]*w(7));
X6(:,8) = cos(4*[1:data_len]*w(8));
X6(:,9) = sin([1:data_len]*w(9))+sin(2*[1:data_len]*w(9));
X6(:,10) = cos([1:data_len]*w(10))+cos(2*[1:data_len]*w(10));

Y6 = sum(X6');

X6 = X6 + noise*0.04;

plot(X6);
%fig2plotly(gcf);
close(gcf);
end

