% Moving from fine grid to coarse grid in G Vainikko's fast solver.
% The projection method is simply restriction; this is possible since the 
% coarse grid points always belong to the fine grid.
%
% Arguments
% uf		matrix of (complex) function values on the fine grid, size [2^Mf, 2^Mf]
% Mc		integer giving the size of the coarse grid
% Mf		integer giving the size of the fine grid, Mf > Mc
%
% Returns
% uc		matrix of (complex) function values on the coarse grid, size [2^Mc, 2^Mc]
% 
% Samuli Siltanen March 2012

function uc = GV_project(uf,Mc,Mf)

% Test validity of arguments
if ~(Mf > Mc)
    error('GV_project.m: fine grid must have more points than coarse grid')
end
[row,col] = size(uf);
if ~(row == 2^Mf) | ~(col == 2^Mf)
    error('GV_project.m: arguments uf and Mf incompatible.')
end

% Restrict the finely defined function to be given only on the points that belong to both grids.
vec = 1 : 2^(Mf-Mc) : 2^Mf;
uc  = uf(vec,vec);

