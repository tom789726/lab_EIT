clc;close all;
% run C:\Users\Tom\Documents\MATLAB\eidors-v3.10-ng\eidors\startup.m

% Part 1: create simple fwd_model structure

n_elecs = 16;
% stim =  mk_stim_patterns(n_elecs,1,[0,1],[0,1],{'no_meas_current'},1);


imdl= mk_common_model('c2c2',n_elecs);
imdl.fwd_model.stimulation = mk_stim_patterns(n_elecs,1,'{ad}','{ad}',{},1);
disp(num_elems(imdl));

%% Create homogeneous background image
% img= calc_jacobian_bkgnd( imdl );
img = mk_image(imdl,1);
vh= fwd_solve(img);

%% Get inhomogeneous data
img.elem_data([232,240])= 1.1;
img.elem_data([225,249])= 0.9;
vi= fwd_solve(img);

img0 = inv_solve(imdl,vh,vi);

%% Display
subplot(121); show_fem(img,[0,1,0]); axis square

subplot(122); show_fem(img0,[0,1,0]); axis square
title('GN');

% imdl=mk_common_gridmdl('backproj');
% img1 = inv_solve(imdl,vh,vi);
% subplot(133); show_fem(img1,[0,1,0]); axis off
% title('Back projection');

figure
plot([vh.meas,100*(vh.meas-vi.meas)]); 
legend('Homogeneous','vh-vi'); xlim([0,208]);

figure
show_current(img); 
