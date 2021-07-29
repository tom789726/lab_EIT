clc; clear; close all;

% 2D Model
imdl_2d= mk_common_model('c2C',8);

% Create an homogeneous image
img_1 = mk_image(imdl_2d);
figure
h1= subplot(231);
show_fem(img_1);

% Calculate element membership in object
img_2 = img_1;
select_fcn = inline('(x-0).^2+(y-0).^2< (0.2)^2','x','y','z');
img_2.elem_data = 1 + elem_select(img_2.fwd_model, select_fcn);

h2= subplot(232);
show_fem(img_2);

img_3 = img_1;
select_fcn = inline('(x-0).^2+(y-0.5).^2< (0.2)^2','x','y','z');
img_3.elem_data = 1 + elem_select(img_3.fwd_model, select_fcn);

h3= subplot(233);
show_fem(img_3);

% img_3.calc_colours.cb_shrink_move = [.3,.8,-0.02];
% common_colourbar([h1,h2,h3],img_3);

pause(1);
figure

% Calculate a stimulation pattern
% stim = mk_stim_patterns(8,1,[0,1],[0,1],{'meas_current'},1);
%%
% Trigo pattern
Nel = 8;
curr = 1;
th = linspace(0,2*pi,Nel+1)'; th(1)=[];
for i = 1:Nel-1;
    if i<=Nel/2
        stim(i).stim_pattern = curr*cos(th*i);
    else
      stim(i).stim_pattern = curr*sin(th*( i - Nel/2 ));
   end
   stim(i).meas_pattern= eye(Nel)-ones(Nel)/Nel;
   stim(i).stimulation = 'Amp';
end

%%    
% Solve all voltage patterns
img_1.fwd_model.stimulation = stim;
img_1.fwd_solve.get_all_meas = 1;
vh1= fwd_solve(img_1);

img_2.fwd_model.stimulation = stim;
img_2.fwd_solve.get_all_meas = 1;
vh2= fwd_solve(img_2);

img_v = rmfield(img_2, 'elem_data');

img_3.fwd_model.stimulation = stim;
img_3.fwd_solve.get_all_meas = 1;
vh3= fwd_solve(img_3);

% Show homoeneous image
h1= subplot(231);
img_v.node_data = vh1.volt(:,1);
show_fem(img_v); axis equal

% Show inhomoeneous image
h2= subplot(232);
img_v.node_data = vh2.volt(:,1);
show_fem(img_v); axis equal

% Show difference image
h3= subplot(233);
img_v.node_data = vh1.volt(:,1) - vh2.volt(:,1);
show_fem(img_v); axis equal

img_v.calc_colours.cb_shrink_move = [0.3,0.8,-0.05];
common_colourbar([h1,h2,h3],img_v);

pause(1);
figure


% grey background
calc_colours('greylev',-.1);

% Get a 2D image reconstruction model
imdl= imdl_2d;
imdl.fwd_model.stimulation = stim;
% Remove meas_select field because all 16x16 patterns are used
imdl.fwd_model = rmfield( imdl.fwd_model, 'meas_select');

% vi= real(v_rotate(:,9))/1e4; vh= real(v_reference)/1e4;

for idx= 1:3
   if     idx==1
      imdl.hyperparameter.value= .03;
   elseif idx==2
      imdl.hyperparameter.value= .05;
   elseif idx==3
      imdl.hyperparameter.value= .10;
   end
   img= inv_solve(imdl, vh1, vh3);
   img.calc_colours.greylev = -.3;

   subplot(2,3,idx);
   show_slices(img);

   subplot(2,3,idx+3);
   z=calc_slices(img);
   c=calc_colours(z,img);
   h=mesh(z,c); view(-11,44);
   set(h,'CDataMapping','Direct');
   set(gca,{'XLim','YLim','ZLim','XTickLabel','YTickLabel'}, ...
        {[1 64],[1 64],[-3.3,0.5],[],[]})
end



% Show simulation pattern
figure
plot(stim(1).stim_pattern);
xlabel('Electrode No. (N)');
ylabel('Current(mA)');
