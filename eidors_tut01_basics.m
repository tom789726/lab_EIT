clc;close all;

% Function Track
% 1. mk_common_model
%   --> create fw model
% 2. mk_image
% 3. mk_stim_patterns

% run C:\Users\tom78\Documents\MATLAB\eidors-v3.10-ng\eidors\startup.m

% Part 1: create simple fwd_model structure

% 2D Model
figure
subplot(1,2,1); 
% imdl_2d = mk_common_model('e2d1t3',16);
% imdl_2d = mk_common_model('b2c',16);
show_fem(imdl_2d.fwd_model);
axis square

% 3D Model
subplot(1,2,2); 
% imdl_3d = mk_common_model('n3r2',[16,2]);
show_fem(imdl_3d.fwd_model);
axis square; view(-35,14);

% Part 2: simulate data

sim_img = mk_image(imdl_3d.fwd_model,1);




