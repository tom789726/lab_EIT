run C:\Users\Tom\Documents\MATLAB\eidors-v3.10-ng\eidors\startup.m
close all;
% Forward solvers $Id: forward_solvers01.m 3790 2013-04-04 15:41:27Z aadler $

n_elecs = 8;
precision = 5/pow2(12);

% 2D Model
imdl= mk_common_model('d2d1c',n_elecs);

% Create an homogeneous image
img_1 = mk_image(imdl);
h1= subplot(221);
show_fem(img_1);

% Add a circular object at 0.2, 0.5
% Calculate element membership in object
% img_2 = img_1;
% select_fcn = inline('(x-0.2).^2+(y-0.5).^2<0.1^2','x','y','z');
% img_2.elem_data = 1 + elem_select(img_2.fwd_model, select_fcn);

% TESTING
skin = 1;
muscle = 5;
bone = 10;

% Skin
img_2 = img_1;
select_fcn = '(x-0).^2+(y-0).^2<0.9^2';
region1 = elem_select( img_2.fwd_model, select_fcn);
img_2.elem_data = 1;
img_2.elem_data = img_2.elem_data + region1*skin;

% Muscle
select_fcn2 = '(x-0).^2+(y-0).^2<0.7^2';
region2 = elem_select( img_2.fwd_model, select_fcn2);
img_2.elem_data = img_2.elem_data + region2*muscle;

% Bone
select_fcn3 = '(x--0.2).^2+(y-0.2).^2<0.15^2';
region3 = elem_select( img_2.fwd_model, select_fcn3);
img_2.elem_data = img_2.elem_data + region3*bone;

img_0 = img_1;
select_fcn = '(x--0.2).^2+(y-0.2).^2<0.15^2';
region = elem_select( img_0.fwd_model, select_fcn);
img_0.elem_data= 1+region*0.1;

% -----Averaging area---
% r_skin = 0.9;
% r_muscle = 0.7;
% r_bone = 0.15;
% % e.g. ratio of skin:whole region
% % = area of skin / area of whole region
% % = pi*r1^2 / pi*r2^2
% % or simply r1^2/r2^2
% % Take 0.9(skin) as reference / outer circle
% ratio_m = (r_muscle^2-r_bone^2)/r_skin^2;
% ratio_b = (r_bone^2)/r_skin^2;
% ratio_sk = (r_skin^2-r_muscle^2)/r_skin^2; % or 1-muscle-bone
% 
% avg = ratio_m*muscle+ratio_b*bone+ratio_sk*skin;
% 
% img_2 = img_1;
% img_2.elem_data = img_2.elem_data + avg;
% -------------------------

% TESTING END

h2= subplot(222);
show_fem(img_2);

img_2.calc_colours.cb_shrink_move = [.3,.8,-0.02];
common_colourbar([h1,h2],img_2);

print_convert forward_solvers01a.png


% Forward solvers $Id: forward_solvers02.m 3790 2013-04-04 15:41:27Z aadler $

% Calculate a stimulation pattern
stim = mk_stim_patterns(n_elecs,1,[0,1],[0,1],{},1);

% TESTING
Nel= 8; %Number of elecs
Zc = .0001; % Contact impedance
curr = 5; % applied current mA


% Trig stim patterns
A = stim(1).stim_pattern;
stim(1).stim_pattern = A*curr;

% for i = (Nel-2):Nel % 6,7,8
% for i = 1:Nel-3
for i = 1:Nel
    s_new = zeros(1,8);
    s_new(i) = 1;
    stim(1).meas_pattern(i,:) = s_new;
end


% th= linspace(0,2*pi,Nel+1)';th(1)=[];
% for i=1:Nel-1;
%     
%    if i<=Nel/2;
%       stim(i).stim_pattern = curr*cos(th*i);
%    else;
%       stim(i).stim_pattern = curr*sin(th*( i - Nel/2 ));
%    end
%    stim(i).meas_pattern= eye(Nel)-ones(Nel)/Nel;
%    stim(i).stimulation = 'Amp';
% end


% TESTING END


% Solve all voltage patterns
img_2.fwd_model.stimulation = stim;
img_2.fwd_solve.get_all_meas = 1;
vh = fwd_solve(img_2);



% Show first stim pattern
% figure
% h1 = gca;
% % h1= subplot(221);
% img_v = rmfield(img_2, 'elem_data');
% img_v.node_data = vh.volt(:,1);
% show_fem(img_v);

% Show 7th stim pattern
% h2= subplot(222);
% img_v = rmfield(img_2, 'elem_data');
% img_v.node_data = vh.volt(:,7);
% show_fem(img_v);

img_v.calc_colours.cb_shrink_move = [0.3,0.8,-0.02];
% common_colourbar([h1,h2],img_v);
% common_colourbar(h1,img_v);
print_convert forward_solvers02a.png

%% Display

% figure
% plot([vh.volt(:,1)]);
% legend(['1st stimulation']);

v1 = vh.meas(1:n_elecs);
v2 = v1-sum(v1)/8;
v2 = (v2/max(v2))*5;
J = stim(1).stim_pattern;
D = sum(v2-J)^2;

figure
subplot(311);
plot(J);
xlabel('electrode'); ylabel('current(amp)');
subplot(312);
plot(v1); xlim([1,n_elecs]); 
xlabel('measurement'); ylabel('voltage(volt)');
subplot(313);
plot(v2); xlim([1,n_elecs]); 
xlabel('measurement'); ylabel('voltage(volt)');

% TESTING

count = 1;
JJ(:,1) = J;
while(1)
    count = count+1;
    JJ(:,count) = (v2);
    stim = mk_stim_patterns(n_elecs,1,[0,1],[0,1],{},1);
    stim(1).stim_pattern = v2;

    % Set meas_pattern
    for i = 1:Nel
        s_new = zeros(1,8);
        s_new(i) = 1;
        stim(1).meas_pattern(i,:) = s_new;
    end
    
    % Solve Forward Model
    img_2.fwd_model.stimulation = stim;
    img_2.fwd_solve.get_all_meas = 1;
    vh = fwd_solve(img_2);
    
    v1 = vh.meas(1:n_elecs);
    
    % Normalise to current amp
    v2 = v1-sum(v1)/8;
    v2 = (v2/max(v2))*5;
    
    J = stim(1).stim_pattern;
    D = sum(v2-J)^2;
    
    
    figure
    subplot(311);
    plot(J);
    xlabel('electrode'); ylabel('current(amp)');
    subplot(312);
    plot(v1); xlim([1,n_elecs]);
    xlabel('measurement'); ylabel('voltage(volt)');
    subplot(313);
    plot(v2); xlim([1,n_elecs]);
    xlabel('measurement'); ylabel('voltage(volt)');
    disp(D);
    
    if (abs(D)<=precision)
        break
    end
end

disp('OK');

figure
plot(JJ);
legend('iteration 1','iteration 2');
xlabel('electrode');
ylabel('current (amp)');


% TESTING
