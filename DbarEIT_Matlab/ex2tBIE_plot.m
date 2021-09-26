% Plot the result of tBIE_comp.m
%
% Samuli Siltanen June 2012

% Load precomputed results 
load lab_EIT/DbarEIT_Matlab/data/ex2tBIE tBIE 
load lab_EIT/DbarEIT_Matlab/data/ex2Kvec Kvec R h K1 K2
tmp = zeros(size(K1));
tmp(abs(K1+i*K2)<R) = tBIE;
tBIE_plot1 = real(tmp);
tBIE_plot2 = imag(tmp);

% Find index vector for points inside a disc
discind = (abs(K1+i*K2)<7);

% Create customized colormap for white background 
colormap jet
MAP = colormap;
M = size(MAP,1); % Number of rows in the colormap
bckgrnd = [1 1 1]; % Pure white color
MAP = [bckgrnd;MAP];

% Modify the function for constructing white background
MIN = min(min([tBIE_plot1,tBIE_plot2]));
MAX = max(max([tBIE_plot1,tBIE_plot2]));
cstep = (MAX-MIN)/(M-1); % Step size in the colorscale from min to max
tBIE_plot1(~discind) = MIN-cstep;
tBIE_plot2(~discind) = MIN-cstep;

% Plot real and imaginary part of the scattering transform
figure(2)
clf
imagesc([tBIE_plot1,tBIE_plot2])
axis equal
axis off
colormap(MAP)

% Save image to file
%print -dpng ex2scatLSBIE.png

