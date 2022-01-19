clc;close all;

% Function Track
% 1. mk_common_model
%   --> create fw model
% 2. mk_image
% 3. mk_stim_patterns
% 4. fwd_solve

% Class member Track 
% 1. *.fwd_model
% 2. *.fwd_model.stimulation
% 3. *.elem_data
% 4. *.meas

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
% show_fem(sim_img.fwd_model); 

% voltage & current patterns
stim = mk_stim_patterns(16,2,[0,1],[0,1],{},1);
sim_img.fwd_model.stimulation = stim;

% 2.1 Homogeneous data
homg_data = fwd_solve(sim_img);

% 2.2 Inhomogeneous data
sim_img.elem_data([390,391,393,396,402,478,479,480,484,486, ...
                   664,665,666,667,668,670,671,672,676,677, ...
                   678,755,760,761])= 1.15;
sim_img.elem_data([318,319,321,324,330,439,440,441,445,447, ...
                   592,593,594,595,596,598,599,600,604,605, ...
                   606,716,721,722])= 0.8;
inh_data = fwd_solve(sim_img);

clf; subplot(2,1,1);
xax= 1:length(homg_data.meas);
hh= plotyy(xax,[homg_data.meas, inh_data.meas], ...
           xax, homg_data.meas- inh_data.meas );

set(hh,'Xlim',[1,max(xax)]);

