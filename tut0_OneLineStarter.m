% 主要用到的functions位置:
% eidors/models
% eidors/solvers

clear % *若果用clear就每次都要run下面呢行，若不用clear就只run一次就OK
run C:\Users\Tom\Documents\MATLAB\eidors-v3.10-ng\eidors\startup.m

load montreal_data_1995

%% mk_common_model
imdl = mk_common_model('c2c2',16);
% c: mesh density
% 2c: 2d circular, point electrode models
% 2: rotated by 45 degrees

%% mk_circ_tank
n_rings = 12;
n_electrodes = 16;
three_d_layers = []; % no 3D
fmdl = mk_circ_tank( n_rings , three_d_layers, n_electrodes);
% n_rings: no. of horizontal plane rings (divisible by 4)
% three_d_layers: for 2D mesh, levels = []
% n_electrodes:
%   scalar (divisible by 4)
%   put a single plane of electrodes in centre of cylinder


%% mk_stim_patterns
options = {'no_meas_current','no_rotate_meas'};
[stim, meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}',options,1);
imdl.fwd_model.stimulation = stim;
imdl.fwd_model.meas_select = meas_select;

%% inv_solve
data_homg = zc_h_demo4;
data_objs = zc_demo4; % from your file
img = inv_solve(imdl, data_homg, data_objs);

%% Display
show_slices(img);
