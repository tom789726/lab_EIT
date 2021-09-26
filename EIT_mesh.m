clc; clear all; close all;

%% Import Domain (?)
sz = 256;

img = imread('phantom_circle.png');
img_bw = double(img(:,:,1)); % Take 1 dimension
img_bw = imresize(img_bw,[sz sz]); % resize 
img1 = (img_bw > max(img_bw(:))/2); % binarize
img2 = edge(img1,'canny'); % edge detection (boundary extraction)
se = offsetstrel('ball',5,5);
img3 = imdilate(double(img2),se); % dilation (opt.)

% figure
% subplot(1,2,1);
% imshow(img1,[]); 
% subplot(1,2,2);
% imshow(img2,[]);

%% mesh generation
L = 32; % no. of electrodes
N = L*(L-1)/2; % no. of elements


mid = sz/2; % center point
node = zeros(2,N); % coordinate of nodes
mesh = zeros(3,N); % node of meshes

im_mesh = zeros(sz);
im_mesh(mid,mid) = 1;
r_max = round(225/2); % radius of outer circle
flag = 0; % for alternating angles in each ring
count = 0; % node record
for r = 0:(r_max/5):r_max % create 5 rings of nodes
    for i = 0:L % create L nodes each ring
        if (r == 0)
            break;
        end
        ang = (2*pi/L)*i;
        if (flag)
            ang = (2*pi/L)*i - (2*pi/L)/2;
        end        
        next_x = round( r*cos(ang) );
        next_y = round( r*sin(ang) );
        row = mid + next_y;
        col = mid + next_x;
        
        count = count+1;
        node(1,count) = row;
        node(2,count) = col;
        
        im_mesh(row,col) = 1;
    end
    flag = rem(flag+1,2);
end

figure
% subplot(1,2,1);
% imshow(im_mesh,[]);
% subplot(1,2,2);
for r = 0:4
    for i = 1:L
        p = r*L+i;
        plot(node(1,p:p+1),node(2,p:p+1),'-k'); hold on % connect same ring
        % connect prev ring
        if (r == 0)
            plot([node(1,p:p+1),mid],[node(2,p:p+1),mid],'-k'); hold on
        else
            plot([node(1,p:p+1), node(1,(r-1)*L+i)],[node(2,p:p+1), node(2,(r-1)*L+i)],'-k'); hold on
        end
        
        pause(0.1);
    end
end

% 3.記得入番落mesh matrix記低

%% phantom test

phantom = imread('phantom.png');

% figure
% imshow(phantom);



