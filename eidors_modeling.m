% clear all;
close all; clc;

%% Launch
username = "Tom"
pathname = fullfile("C:\Users\",username,"\Documents\MATLAB\eidors-v3.10-ng\eidors\startup.m");

run(pathname)

% imdl = mk_common_model('b2C',8);
% show_fem(imdl.fwd_model,[0,1,0]); axis off;

load iirc_data_2006

% Make FEM model
imdl = mk_common_model('c2c');
% Set stimulation patterns. Use meas_current
% Stimulation of [1,0] (not [0,1]) is needed for this device (IIRC)
imdl.fwd_model.stimulation = mk_stim_patterns(16,1,[1,0],[0,1],{'meas_current'},1);
% Remove meas_select field because all 16x16 patterns are used
imdl.fwd_model = rmfield( imdl.fwd_model, 'meas_select');

% Use loaded data (reference + inhomogeneous data)
vi= real(v_rotate(:,9))/1e4;
vh= real(v_reference)/1e4;


for idx= 1:3
   % By default, hyperparameter.value = 0.03
   if     idx==1
      imdl.hyperparameter.value= .03;
   elseif idx==2
      imdl.hyperparameter.value= .05;
   elseif idx==3
      imdl.hyperparameter.value= .10;
   end
   img= inv_solve(imdl, vh, vi);

   subplot(1,3,idx); 
   show_slices(img); title(string(imdl.hyperparameter.value));
end

