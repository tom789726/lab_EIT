clc; clear; close all;

sz = 500;
img_bw = ones(sz);

%% Data Format Definition
L_max = 32; % no. of electrodes
N_max = L_max*(L_max-1)/2; % no. of elements, 496 for 32-electrode

L = 16; %re-mapping
space = 32/L; %re-mapping
N = N_max/space;

mid = sz/2; % Center
mesh = zeros(4,N_max); % element matrix, NULL = 0
node = zeros(5,N_max); % Node matrix, (theta/ring/r) --> (x,y)
ax = figure();


function [] = setNode( )


end

function [] = setMesh()

end

function [] = showMesh()

end

