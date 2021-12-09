% clear all;
close all; clc;

%% Launch
username = "tom78"
pathname = fullfile("C:\Users\",username,"\Documents\MATLAB\eidors-v3.10-ng\eidors\startup.m");

run(pathname)

% imdl = mk_common_model('b2C',8);
% show_fem(imdl.fwd_model,[0,1,0]); axis off;

load iirc_data_2006

calc_colours('greylev',-.1);

imdl = mk_common_model('c2c');
imdl.fwd_model.stimulation = mk_stim_patterns(16,1,[1,0],[0,1],{'meas_current'},1);
imdl.fwd_model = rmfield( imdl.fwd_model, 'meas_select');

vi= real(v_rotate(:,9))/1e4; 
vh= real(v_reference)/1e4;


for idx= 1:3
   if     idx==1
      imdl.hyperparameter.value= .03;
   elseif idx==2
      imdl.hyperparameter.value= .05;
   elseif idx==3
      imdl.hyperparameter.value= .10;
   end
   img= inv_solve(imdl, vh, vi);
   img.calc_colours.greylev = -.3;

   subplot(2,3,idx);
   show_slices(img);

   subplot(2,3,idx+3);
   z=calc_slices(img);
   c=calc_colours(z,img);
   h=mesh(z,c); 
   view(-11,44);
   set(h,'CDataMapping','Direct');
   set(gca,{'XLim','YLim','ZLim','XTickLabel','YTickLabel'}, ...
        {[1 64],[1 64],[-3.3,0.5],[],[]})
end

%% Playground
imdl = mk_common_model('c2c',16);
vi= vi(1:208);
vh = vh(1:208);

img0 = inv_solve(imdl,vh,vi);
