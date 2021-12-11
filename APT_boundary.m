%%%simulation model
% $Id: mk_GREIT_mat_ellip01.m 2799 2011-07-14 23:41:48Z bgrychtol $
% compare and superposition the boundary data (mixed, lungs, heart)
clc
close all
clear all
cd('C:/Users/user/Documents/MATLAB/EIDORSm/eidors-v3.8/eidors');
startup
n_elecs = 16;
stim =  mk_stim_patterns(n_elecs,1,[0,1],[0,1],{'no_meas_current'},1);

%%generate the training data_mixed
for i = 1:1 
lungs ='solid obj1 = sphere(1,0.1,1;0.6) or sphere(-1,0.1,1;0.6);'; %0.3-0.6, original phantom
heart ='solid obj2 = sphere(0,0.1,1;0.3);'; %0.2-0.3, original phantom
extra={'obj1','obj2',[lungs heart]};
[fmdl,midx] = ng_mk_cyl_models([2,2,0.2],[16,1],[0.1],extra);
fmdl.stimulation = stim;
img = mk_image(fmdl,1); %Homogeneous background
% vh(i) = fwd_solve(img); %voltage data, reference. key!!
vh = fwd_solve(img); %voltage data, reference
img.elem_data(midx{2}) = 0.5; %Lung regions
img.elem_data(midx{3}) = 2; %1.2 recommend; %heart regions
vi_mixed = fwd_solve(img); %voltage  data
X(:,1) = vi_mixed.meas;
figure;show_fem(img);
figure;show_fem(img);view(2)
end
figure; plot([vh.meas, 100*(vh.meas-vi_mixed.meas)]);legend('vh','mixed')
atp_mixed = 100*(vh.meas-vi_mixed.meas);

%%Gold stand, pure lungs
for i = 1:1
lungs ='solid obj1 = sphere(1,0.1,1;0.6) or sphere(-1,0.1,1;0.6);';
extra={'obj1',[lungs]}; %lungs only時使用
[fmdl,midx] = ng_mk_cyl_models([2,2,0.2],[16,1],[0.1],extra);
fmdl.stimulation = stim;
img = mk_image(fmdl,1); %Homogeneous background
vh(i) = fwd_solve(img); %voltage data, reference. key!!
% vh= fwd_solve(img); %voltage data, reference
img.elem_data(midx{2}) = 0.5; %Lung regions
% img.elem_data(midx{3}) = 2; %1.2 recommend; %heart regions
vi_lungs = fwd_solve(img); %voltage  data
X(:,2) = vi_lungs.meas;
figure;show_fem(img);
figure;show_fem(img);view(2)
end
figure; plot([vh.meas, 100*(vh.meas - vi_lungs.meas)]);legend('vh','lungs')
atp_l = 100*(vh.meas - vi_lungs.meas);

%%Gold stand, pure heart
heart ='solid obj1 = sphere(0,0.1,1;0.3);'; %0.2-0.3
extra={'obj1',[heart]};
% [fmdl,midx] = ng_mk_ellip_models([2,2,1.4,0.2],[n_elecs,1],[0.1],extra); %不能用,改成下一行, ng_mk_cyl_models
% [fmdl,midx] = ng_mk_cyl_models([2,2,1.4,0.2],[n_elecs,1],[0.1],extra);
[fmdl,midx] = ng_mk_cyl_models([2,2,0.2],[16,1],[0.1],extra);
fmdl.stimulation = stim;
img = mk_image(fmdl,1); %Homogeneous background
vh = fwd_solve(img); %voltage data, reference
img.elem_data(midx{2}) = 2; %1.2 recommend; %heart regions; *midx{2}為2(因為只有ref和心臟兩個元件)
vi_heart = fwd_solve(img); %voltage data
X(:,3) = vi_heart.meas
figure;show_fem(img);
figure;show_fem(img);view(2)
figure; plot([vh.meas, 100*(vh.meas - vi_heart.meas)]);legend('vh','heart')
atp_h = 100*(vh.meas - vi_heart.meas);
figure; plot([atp_l, atp_h, atp_mixed]);legend('lungs','heart','mixed')
figure; plot([atp_l+atp_h, atp_mixed]);legend('lungs + heart','mixed')
