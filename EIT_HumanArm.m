% clear all; 
clc; close all;

%% Load Data
pathname = 'Rods_arm_1981.xls';
raw = importdata(pathname);
rawData = getfield(raw,'data','Sheet1');

vh = rawData(:,3); vh = repmat(vh,[2,1]);
vi = rawData(:,6); vi = repmat(vi,[2,1]);

ph = phantom(512);
%% Reconstruction
imdl=mk_common_gridmdl('backproj');
img0 = inv_solve(imdl,vh,vi);
imdl=mk_common_model('c2c2',16);
img1 = inv_solve(imdl,vh,vi);


%% EIDORS
% run C:\Users\Tom\Documents\MATLAB\eidors-v3.10-ng\eidors\startup.m

%% Display
subplot(121); show_fem(img0,[0,1,0]); title('Back projection');
subplot(122); show_fem(img1,[0,1,0]); title('G-N (GREIT)');

%% Radon
img = phantom(512);
img2 = radon(img,0:179);
img3 = iradon(img2,0:179,'None');
img4 = iradon(img2,0:179);

figure
for idx = 1:4
    subplot(2,2,idx);
    if idx==1
        imshow(img,[]); title('Original image');
    elseif idx==2
        imagesc(img2); colormap gray; axis off; title('Sinogram');
    elseif idx==3
        imshow(img3,[]); title('Back-projection');
    elseif idx==4
        imshow(img4,[]); title('Filtered back-projection');
    end
end


