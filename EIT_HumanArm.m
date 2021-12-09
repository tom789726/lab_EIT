% clear all; 
clc; close all;

%% Load Data
pathname = 'Rods_arm_1981.xls';
raw = importdata(pathname);
rawData = getfield(raw,'data','Sheet1');

vh = rawData(:,3); vh_rep = repmat(vh,[2,1]);
vi = rawData(:,6); vi_rep = repmat(vi,[2,1]);

ph = phantom(512);

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

subplot(313); plot(A); title('fwd\_model.meas\_select'); xlabel('electrode'); 
xticks([1:2:64]); xlim([1,64]);



