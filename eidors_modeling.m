close all;

%% Launch
% username = "tom78"
% pathname = fullfile("C:\Users\",username,"\Documents\MATLAB\eidors-v3.10-ng\eidors\startup.m");
% run(pathname)

%% Testing

% fem = mk_common_model('b2C',8);
% show_fem(fem.fwd_model,[0,1,0]); axis off;

mdl = mk_common_model('c2d0c',8);
mdl.fwd_model.jacobian = 'np_calc_jacobian';
mdl.fwd_model.system_mat = 'np_calc_system_mat';
mdl.fwd_model.solve = 'np_fwd_solve';

% 
n_elems = size(mdl.fwd_model.elems,1);
img_sim = eidors_obj('image','name:demo');
img_sim.elem_data = ones(n_elems,1);
img_sim.fwd_model = mdl.fwd_model;
meas_h = fwd_solve(img_sim);

show_fem(img_sim.fwd_model,[0,1,0]);

% 
target_A = 1:10;
target_B = 20:30;
% 
img_sim.elem_data(target_A) = 1.2;
img_sim.elem_data(target_B) = 0.8;
meas_i = fwd_solve(img_sim);

% 
n_meas = size(meas_h.meas,1);
noise = 0.1*std(meas_h.meas-meas_i.meas)*randn(n_meas,1);
meas_i.meas = meas_i.meas+noise;

% 
mdl.solve = 'np_inv_solve';
mdl.hyperparameter.value = 1e-2;
% mdl.RtR_prior = 'np_calc_image_prior';
img = inv_solve(mdl,meas_h,meas_i);

% show_fem(img,[0,0,1]);