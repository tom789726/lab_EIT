% clear all;
close all; clc;

%% Launch
username = "tom78"
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


%% 1224: EIT Modeling & Dice Index
imdl= mk_common_model('c2c2',16);
% Create homogeneous background image
img= calc_jacobian_bkgnd( imdl );
vh= fwd_solve(img);
% Get inhomogeneous data
img.elem_data([232,240])= 1.1;
img.elem_data([225,249])= 0.9;
vi= fwd_solve(img);
subplot(131); show_fem(img,[0,1,0]); axis square

img0 = inv_solve(imdl,vh,vi);
subplot(132); show_fem(img0,[0,1,0]); axis square
title('GN');

imdl=mk_common_gridmdl('backproj');
img1 = inv_solve(imdl,vh,vi);
subplot(133); show_fem(img1,[0,1,0]); axis off
title('Back projection');


% Convert into image matrix
rimg = calc_slices(img);
% rimg = calc_colours(rimg,img);

rimg0 = calc_slices(img0);
% rimg0 = calc_colours(rimg0,img0);

figure
subplot(121); imshow(rimg,[]);
subplot(122); imshow(rimg0,[]);


% dice = (2*rimg&rimg0)/(rimg+rimg0);
% figure
% imshow(dice,[]);


