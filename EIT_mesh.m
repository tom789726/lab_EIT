clc; clear all; close all;

%% Import Domain (?)
sz = 256;

img = imread('circle.png');
img_bw = double(img(:,:,1)); % Take 1 dimension
img_bw = imresize(img_bw,[sz sz]); % resize 
img1 = (img_bw > max(img_bw(:))/2); % binarize
img2 = edge(img1,'canny'); % edge detection (boundary extraction)
se = offsetstrel('ball',5,5);
img3 = imdilate(double(img2),se); % dilation (opt.)

figure
subplot(1,2,1);
imshow(img1,[]); 
subplot(1,2,2);
imshow(img2,[]);

%% mesh generation
L_max = 32; % no. of electrodes
N = L_max*(L_max-1)/2; % no. of elements


mid = sz/2; % center point
node = zeros(2,N); % coordinate of nodes
mesh = zeros(3,N); % node of meshes

% Initialise
im_mesh = zeros(sz);
im_mesh(mid,mid) = 1;

r_max = round(225/2); % radius of outer circle
flag = 0; % for alternating angles in each ring
count = 0; % for node record

% Specify Joshua Tree Mesh parameters
ring_max = 22;
ring_map = zeros(1,ring_max);
ring_map(1:4)  = 8;
ring_map(5:8)  = 16;
ring_map(9:14) = 24;
ring_map(15:22)= 32; % (?) L_max = 32 necessary?
idx_ring = 0;
L = L_max;

for r = 0:(r_max/(ring_max)):r_max % create 5 rings of nodes
    if (r ~= 0)
        idx_ring = idx_ring+1;
        L = ring_map(idx_ring);
    end
    for i = 0:(L-1) % create L nodes each ring
        if (r == 0)
            break;
        end
        ang = (2*pi/L)*i;
        if (flag)
            ang = (2*pi/L)*i + (2*pi/L)/2;
        end        
        next_x = round( r*cos(ang) );
        next_y = round( r*sin(ang) );
        row = mid + next_y;
        col = mid + next_x;
        
        % Record node coordinates
        count = count+1;
        node(1,count) = row;
        node(2,count) = col;
        
        im_mesh(row,col) = 1;
        
%         imshow(im_mesh,[]);
%         pause(0.1);
    end
%     imshow(im_mesh,[]);
    flag = rem(flag+1,2);
end

count = 0; % for mesh record
idx_ring = 0;

figure
subplot(1,2,1);
imshow(im_mesh,[]);
subplot(1,2,2);
for r = 0:(4)
    idx_ring = idx_ring+1;
    L = ring_map(idx_ring);
    for i = 1:L
        count = count+1;
        if (i == L) % reach the end, connect head to tail
            disp("TAIL");
%             p = r*L+i;
            p = count;
            plot([node(1,p-L+1),node(1,p)],[node(2,p-L+1),node(2,p)],'-k'); hold on
            % record nodes of each elements
            mesh(1,count) = p;
            mesh(2,count) = p-L+1;
            if (r == 0) % Special case: center
                plot([node(1,p),mid],[node(2,p),mid],'-k'); hold on
                plot([node(1,p-L+1),mid],[node(2,p-L+1),mid],'-k'); hold on
                mesh(3,count) = 0;
            else
                plot([node(1,p),node(1,p-L)],[node(2,p),node(2,p-L)],'-k'); hold on
                plot([node(1,p-L+1),node(1,p-L)],[node(2,p-L+1),node(2,p-L)],'-k'); hold on
                mesh(3,count) = p-L;
            end
        else            
            disp("BODY");
%             p = r*L+i;
            p = count;
            % connect same ring
            plot(node(1,p:p+1),node(2,p:p+1),'-k'); hold on
            % record nodes of each elements
            mesh(1,count) = p;
            mesh(2,count) = p+1;
            % connect prev ring
            if (r == 0)
                plot([node(1,p),mid],[node(2,p),mid],'-k'); hold on
                plot([node(1,p+1),mid],[node(2,p+1),mid],'-k'); hold on
                mesh(3,count) = 0; % *****Note Special Case: node number = 0 (mid)*****
            else
                L_prev = ring_map(idx_ring-1);
                plot([node(1,p), node(1,p-L_prev)],[node(2,p), node(2,p-L_prev)],'-k'); hold on
                plot([node(1,p+1), node(1,p-L_prev)],[node(2,p+1), node(2,p-L_prev)],'-k'); hold on
%                 plot([node(1,p), node(1,(r-1)*L+i)],[node(2,p), node(2,(r-1)*L+i)],'-k'); hold on
%                 plot([node(1,p+1), node(1,(r-1)*L+i)],[node(2,p+1), node(2,(r-1)*L+i)],'-k'); hold on
                mesh(3,count) = (r-1)*L+i;
            end
        end
%         disp(mesh(:,count)');
%         pause(0.5);
    end
end

%% phantom test

phantom = imread('phantom.png');
img_bw2 = double(phantom(:,:,1)); % Take 1 dimension
img_bw2 = imresize(img_bw2,[sz sz]); % resize 
img_ph1 = (img_bw2 > max(img_bw2(:))/2); % binarize
img_ph2 = edge(img_ph1,'canny'); % edge detection (boundary extraction)
se = offsetstrel('ball',5,5);
img_ph3 = imdilate(double(img_ph2),se); % dilation (opt.)

img_phantom = img_ph2+img2;

figure
subplot(1,2,1);
imshow(img2,[]); 
subplot(1,2,2);
imshow(img_phantom,[]);

% figure
% imshow(phantom);



