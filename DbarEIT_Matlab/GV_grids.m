% Routine related to G Vainikko's fast method for the solution of the 
% Lippmann-Schwinger equation. Computes the collocation points in a domain 
% containing the square [-s,s]^2 for coarse and fine grid. 
% 
% Arguments
% Mc		integer giving the size of the coarse grid: [2^Mc,2^Mc]
% Mf		integer giving the size of the fine grid: [2^Mf,2^Mf]
% s         (optional, default s=1) lower left corner of both grids is [-s,-s]
%           
% Returns
% x1c		matrix of horizontal coordinates for coarse grid, size [2^Mc,2^Mc]
% x2c		matrix of vertical coordinates for coarse grid, size [2^Mc,2^Mc]
% hc		length of panel boundary of coarse grid
% x1f		matrix of horizontal coordinates for fine grid, size [2^Mf,2^Mf]
% x2f		matrix of vertical coordinates for fine grid, size [2^Mf,2^Mf]
% hf		length of cell boundary of fine grid
% 
% Samuli Siltanen March 2012

function [x1c,x2c,hc,x1f,x2f,hf] = GV_grids(Mc,Mf,s)

if ~(Mf > Mc)
    error('GV_grids.m: fine grid must have more points than coarse grid')
end

% The fine grid will essentially fill the square with corners (-s,s),(-s,-s),(s,-s),(s,s)
if nargin < 3
    s = 1;
end

% Define fine grid parameters. 
Nf = 2^(Mf-1);
hf = s/Nf;

% Define coarse grid parameters. 
Nc = 2^(Mc-1);
hc = s/Nc;

% Construct fine grid points.
jj      = -Nf : (Nf-1);
[J1,J2] = meshgrid(jj);
x1f     = hf*J1;
x2f     = hf*J2;

% Construct coarse grid points. 
x1c = GV_project(x1f, Mc, Mf);
x2c = GV_project(x2f, Mc, Mf);
