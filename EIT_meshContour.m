%% Setup
% http://eidors3d.sourceforge.net/tutorial/netgen/extrusion/thoraxmdl.shtml
clear all; close all; 
run C:\Users\Tom\Documents\MATLAB\eidors-v3.10-ng\eidors\startup.m
clc;


%% Load Image & Import as FEM model
% Phantom
img = imread('C:\Users\Tom\Documents\MATLAB\lab_EIT\phantom_lung.png');
img_bw = double(rgb2gray(img));

% thigh
img_th = imread('C:\Users\Tom\Documents\MATLAB\lab_EIT\thigh\0.jpg');
img_th = double(rgb2gray(img_th));
imshow(img_th,[]); axis on ; axis xy
impixelinfo

close all
% masks
img0 = double(imread('C:\Users\Tom\Documents\MATLAB\data\mask0.jpg'));
img1 = double(imread('C:\Users\Tom\Documents\MATLAB\data\mask1.jpg'));
img2 = double(imread('C:\Users\Tom\Documents\MATLAB\data\mask2.jpg'));

%% Extract Boundary
close all

thigh = edge(img0,'prewitt');
muscle = edge(img1,'prewitt');
bone = edge(img2,'prewitt');



figure
subplot(121); imshow(img2,[]);

% img_test = zeros(size(bone));
% img_test(find(bone>=1)) = 1;
% subplot(122); imshow(img_test,[]); axis on
subplot(122); imshow(bone,[]); axis on
impixelinfo

%% Shift coordinate (N*2 clockwise matrix)
close all

% image array to x-y
[y,x] = find(bone);

% move center to object center
cent = 110; 
x2 = x-cent;
y2 = y-cent;

% Sort by angle
[phi,r] = cart2pol(x2,y2);

dir_show = 'ascend';
pol = [phi,r];
pol = sortrows(pol,1,dir_show);

% back to x-y & shift center back
[x3,y3] = pol2cart(pol(:,1),pol(:,2)); 
bone_xy = [x3,y3];

% shift center (opt: only needed when you mesh 3 objects at once)
% bone_xy = [x3+cent,y3+cent];
% muscle_xy = [x3+cent,y3+cent];
% thigh_xy = [x3+cent,y3+cent];

% scale to -1~1 (opt)

% Display
disp({'Ascend(Anti-clockwise) / Descend (Clockwise)?: ,',dir_show});

figure
subplot(121); plot(x,y,'o-k');
subplot(122); plot(bone_xy(:,1),bone_xy(:,2),'-k');


% Animation
% idx_mx = size(bone_xy,1);
% 
% figure
% for i = 1:idx_mx-1
%    xp = pol(i:i+1,2).*cos(pol(i:i+1,1))+cent;
%    yp = pol(i:i+1,2).*sin(pol(i:i+1,1))+cent;
%    plot(xp,yp,'-k'); hold on
%    xlim([0,250]);
%    ylim([0,250]);
% %    xlim([90-cent,130-cent]);
% %    ylim([90-cent,130-cent]);
%    pause(0.1);
% end

%%
fmdl = ng_mk_2d_model(bone_xy);

figure
show_fem(fmdl);


%% RGB
% close all
figure
% imshow(img_th,[]);

img_th = imread('C:\Users\Tom\Documents\MATLAB\lab_EIT\thigh\0.jpg');

img_disp = img_th;
img_disp(:,:,1) = img_disp(:,:,1) + uint8(thigh).*255;
img_disp(:,:,2) = img_disp(:,:,2) + uint8(muscle).*255;
img_disp(:,:,3) = img_disp(:,:,3) + uint8(bone).*255;
imshow(img_disp,[]);


%% Tutorial
% get contours
thorax = shape_library('get','adult_male','boundary');
rlung  = shape_library('get','adult_male','right_lung');
llung  = shape_library('get','adult_male','left_lung');
% one could also run:
% shape_library('get','adult_male');
% to get all the info at once in a struct

% show the library image
figure
shape_library('show','adult_male');
impixelinfo

%% Netgen
shape = {0,
    {thorax,rlung,llung},
    [1],
    0.04};

elec_pos = [16,1];
elec_shape = [0.05,0,0.04];

fmdl = ng_mk_extruded_model(shape,elec_pos,elec_shape);

%
figure
subplot(211);
show_fem(fmdl);

img=mk_image(fmdl,1);
img.elem_data(fmdl.mat_idx{2})= 0.3; % rlung
img.elem_data(fmdl.mat_idx{3})= 0.3; % llung

subplot(212);
show_fem(img);

