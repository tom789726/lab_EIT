% Plot the results of DbarEIT07_tBIErecon_comp.m
%
% Samuli Siltanen November 2017

% Load precomputed reconstruction and its evaluation points
load data/recon x1 x2 recon
recon = reshape(real(recon),size(x1));

% Evaluate the original conductivity on the finer grid
orig = heartNlungs(x1+1i*x2);

% Set minimum and maximum for the plots
MIN = 0.5;
MAX = 2.5;
% MIN = min(min(orig(:)),min(recon(:)));
% MAX = max(max(orig(:)),max(recon(:)));

% Create customized colormap for white background 
colormap jet
MAP = colormap;
M = size(MAP,1); % Number of rows in the colormap
bckgrnd = [1 1 1]; % Pure white color
MAP = [bckgrnd;MAP];

% Find index vectors for points inside the unit disc
discind = (abs(x1+1i*x2)<1);

% Modify the functions for constructing white background
cstep = (MAX-MIN)/(M-1); % Step size in the colorscale from min to max
recon(~discind) = MIN-cstep;
orig(~discind)  = MIN-cstep;

% Plot the original conductivity and the reconstruction
figure
clf
imagesc([orig,recon])
axis equal
axis off
colormap(MAP)

% Write image to file
%print -dpng recon.png
