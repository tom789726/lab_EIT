% Moving from coarse grid to fine grid in G Vainikko's fast solver.
% We use nearest neighbor interpolation.
% 
% All points of the fine grid are centerpoints of square cells with side 
% length the same than vertical distance between vertically adjacent 
% neighbour grid points. Due to the requirements that 
% (1) grid points on the coarse grid are also grid points on the fine grid,
% (2) panels must be unions if fine grid cells, the points on the coarse 
% grid are not exact centerpoints of their cells. 
% 
% Arguments
% uc		matrix of (complex) function values on the fine grid, size [2^Mc,2^Mc]
% Mc		integer giving the size of the coarse grid
% Mf		integer giving the size of the fine grid, Mf > Mc
% Returns
% uf		matrix of (complex) function values on the fine grid, size [2^Mf,2^Mf]
% 
% Samuli Siltanen March 2012

function uf = GV_prolong(uc,Mc,Mf)

% Test validity of arguments
if ~(Mf > Mc)
    error('GV_prolong.m: fine grid must have more points than coarse grid')
end
[row,col] = size(uc);
if ~(row == 2^Mc) | ~(col == 2^Mc)
    error('GV_prolong.m: arguments uc and Mc incompatible.')
end

% The aim is to copy values on the coarse grid points to all those fine grid points that have 
% their cell as subset of the coarse cell corresponding to a coarse grid point. We proceed
% as follows.

% Ignoring boundary effects, each panel of the coarse grid contains N*N fine grid cells:
N = 2^(Mf-Mc);

% We start by manufacturing a matrix containing N x N constant submatrices with values picked
% from the coarse grid function we got as argument.
uf    = zeros(2^Mf,2^Mf);
uftmp = zeros(2^Mf,2^Mf);
for jjj = 1:2^Mc
    tmp = repmat(uc(jjj,:), N, 1);
    tmp = tmp(:).';
    tmp = repmat(tmp, N, 1);
    uftmp((jjj-1)*N + [1:N], :) = tmp;
end
    
% Remove useless rows and copy other rows from uftmp to make uf complete
offset = N/2-1;
uf(offset+1 : 2^Mf, 1 : 2^Mf-offset) = uftmp(1 : 2^Mf-offset, offset+1 : 2^Mf);
uf(1:offset, :) = repmat(uf(offset+1, :), offset, 1);
uf(:, (2^Mf-offset+1):2^Mf) = repmat(uf(:, 2^Mf-offset), 1, offset);


