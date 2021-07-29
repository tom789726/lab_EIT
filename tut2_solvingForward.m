% Forward solvers $Id: forward_solvers06.m 5758 2018-05-19 20:37:04Z aadler $

% Simulation Image
imgs= mk_image(mk_common_model('d2d1c',21));
imgs.fwd_model.electrode = imgs.fwd_model.electrode([15:21,1:8]);
nel = num_elecs(imgs);
imgs.fwd_solve.get_all_meas = 1;

% Output Image
imgo = rmfield(imgs,'elem_data');
imgo.calc_colours.ref_level = 0;

% Regular "current" stimulation between electrodes 6 and 10
clear stim;
stim.stim_pattern = zeros(nel,1);
stim.stim_pattern([6,10]) =  [10,-10];
stim.meas_pattern = speye(nel);
imgs.fwd_model.stimulation = stim;

vh = fwd_solve( imgs ); imgo.node_data = vh.volt(:,1);

subplot(221); show_fem(imgo,[0,1]); axis off;
 


% Forward solvers $Id: forward_solvers07.m 5645 2017-09-10 20:33:02Z aadler $

% current stimulation between electrodes 6 and 10
stim.stim_pattern = zeros(nel,1);
stim.stim_pattern([6,10]) =  [10,-10];
% Voltage stimulation between electrodes 1,2 and 14,15
stim.volt_pattern = zeros(nel,1);
stim.volt_pattern([1,2,14,15]) =  [1,1,-1,-1]*5;
% Need to put NaN in the corresponding elements of stim_pattern
stim.stim_pattern([1,2,14,15]) =  NaN*ones(1,4);

imgs.fwd_model.stimulation = stim;
vh = fwd_solve( imgs ); imgo.node_data = vh.volt(:,1);

subplot(222); show_fem(imgo,[0,1]); axis off

print_convert forward_solvers07a.png
