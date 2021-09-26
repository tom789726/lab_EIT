% clc; clear all; close all;
clc; close all;

%% Thigh Image

% img_th = (imread('sample.jpeg'));
% img_contour =(imread('sample_manual.jpg'));
% c_muscle = img_contour(:,:,1);
% c_bone = img_contour(:,:,2);
% 
% figure
% subplot(1,2,1);
% imagesc(img_th);
% subplot(1,2,2);
% imagesc(img_contour);
% 
% img1 = img_th(:,:,1);
% figure
% subplot(1,2,1);
% imshow(c_muscle,[]);
% subplot(1,2,2);
% imshow(c_bone,[]);

%% EIDORS
% fmdl = mk_common_model('e2d1t3',16);
% run C:\Users\Tom\Documents\MATLAB\eidors-v3.10-ng\eidors\startup.m

fmdl = mk_common_model('e2d1t2',16);
img = mk_image(fmdl);

figure
show_fem(img);

% load CT2_pig.mat
% img = imread('pig-thorax.jpg');
% colormap(gray(256));
% imagesc(-67+[1:371],25+[1:371],img);
% 
% hold on;
% % plot(372-trunk(:,1),trunk(:,2),'m*-');
% plot(372-lung(:,1),lung(:,2),'r*-');
% hh=plot(372-elec_pos(:,1),elec_pos(:,2), 'b.'); set(hh,'MarkerSize',20);
% hold off