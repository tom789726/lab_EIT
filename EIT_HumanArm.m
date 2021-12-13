% clear all; 
clc; close all;

%% Load Data
pathname = 'Rods_arm_1981.xls';
raw = importdata(pathname);
rawData = getfield(raw,'data','Sheet1');

vh = rawData(:,3);
vi = rawData(:,6);

% Try 1
% vh_rep = repmat(vh,[2,1]);
% vi_rep = repmat(vi,[2,1]);

% Try 2
vh_rep = zeros(size(vh,1)*2,1);
vi_rep = zeros(size(vi,1)*2,1);

N = 16-3;

A=[0:16:208];
count = 1;

clc
for idx = 1:N
    if (idx == N)
        count = 104;
    end
    idx_data = [count:count+N-idx];
    idx_rep = [1:size(idx_data,2)]+A(idx);
%     vh_rep(idx_rep) = vh(idx_data);
%     vi_rep(idx_rep) = vi(idx_data);

    count = count+N-idx+1;    
end

figure
subplot(2,1,1); plot(vh); xlim([1;104]);
subplot(2,1,2); plot(vh_rep); xlim([1;104]);
 
%% EIDORS
% run C:\Users\Tom\Documents\MATLAB\eidors-v3.10-ng\eidors\startup.m

imdl=mk_common_gridmdl('backproj');
img0 = inv_solve(imdl,vh_rep,vi_rep);
imdl=mk_common_model('c2c2',16);
img1 = inv_solve(imdl,vh_rep,vi_rep);



%% Display
subplot(121); show_fem(img0,[0,1,0]); title('Back projection');
subplot(122); show_fem(img1,[0,1,0]); title('G-N (GREIT)');

%% Compare measurement values

% EIDORS deafult meas_select
A = getfield(imdl,'fwd_model','meas_select');

% Human Arm data
vh_norm = vh/1e3;
pkpk = max(vh_norm(:));
[pks,locs] = findpeaks(abs(vh_norm-pkpk));

% Korean EIT iirc_data_2006
load iirc_data_2006
vh2 = real(v_reference)/1e4;
pkpk2 = max(vh2(:));
[pks2,locs2] = findpeaks(abs(vh2-pkpk2));

% Optimum current pattern
v_opt = ones(size(vh2));
v_opt = v_opt.*cos((1:256)'*2*pi/16);

figure
subplot(311); plot(vh_norm); 
title('Measurements (Human Arm, 1981)'); xlabel('pt'); ylabel('Potential(V)'); hold on;
plot(locs,vh_norm(locs),'rx');
xticks([1:3:104]); legend('Measurement','Transition point');

subplot(312); plot(vh2); 
title('Measurements (iirc data, 2006)'); xlabel('pt'); ylabel('Potential(V)'); hold on;
plot(locs2,vh2(locs2),'rx');
xticks([1:3:256]); legend('Measurement','Transition point');
xlim([1,128]);

subplot(313); plot(v_opt); 
xlim([1,128]);

figure 
plot(vh2); hold on
plot(v_opt);
xlim([1,128]);

%%
imdl = mk_common_model('c2c',16);
imdl.fwd_model.stimulation = mk_stim_patterns(16,1,[1,0],[0,1],{'meas_current'},1);
imdl.fwd_model = rmfield( imdl.fwd_model, 'meas_select');

img = inv_solve(imdl,real(v_reference)/1e4,v_opt);
figure
show_fem(img);
