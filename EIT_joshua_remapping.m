clc; clear; close all;

sz = 500;
img_bw = ones(sz);

%% Data Format Definition
L_max = 32; % no. of electrodes
N_max = L_max*(L_max-1)/2; % no. of elements, 496 for 32-electrode

L = 16; %re-mapping
space = 32/L; %re-mapping
N = N_max/space;

mid = sz/2; % Center
mesh = zeros(4,N_max); % element matrix, NULL = 0
node = zeros(5,N_max); % Node matrix, (theta/ring/r) --> (x,y)
ax = figure();

%% Test: level 1
sz_ring = 8; % L, no. of elements at that level
R = 220;
r = sqrt(sz_ring/N_max)*R;

sz_ring_mesh = sz_ring/space;

% element matrix (node assign)
mesh(1,1:sz_ring_mesh) = 1;
mesh(2,1:sz_ring_mesh) = (1:space:sz_ring)+1;
mesh(3,1:sz_ring_mesh) = (1:space:sz_ring)+1+space;
mesh(4,1:sz_ring_mesh) = 0;
% fine tune element #8
mesh(3,sz_ring_mesh) = 2;

mesh = sort(mesh);

% node matrix (coordinate assign)
node(:,1) = 0; 
node(4:5,1) = mid; % node #1: center point

idx_node = 2:sz_ring+1;
node(1,idx_node) = (0:sz_ring-1)*360/sz_ring; % theta (in degree)
node(2,idx_node) = 1; % level 1
node(3,idx_node) = r;
node(4,idx_node) = mid+ round( node(3,idx_node).*cosd( node(1,idx_node) ) ); % rcos()
node(5,idx_node) = mid+ round( node(3,idx_node).*sind( node(1,idx_node) ) ); % rsin()

disp('Level 1 complete.');

%% Plot points on screen (level1)
% for i = 1:sz_ring+1
%    img_bw( node(4,i) , node(5,i) ) = 0;
%    pause(0.1);
%    imshow(img_bw,[]);
%    disp( num2str(mid + node(4,i)) );
%    disp( num2str(mid + node(5,i)) );
% end

%% Draw circle (level1)
% for row = 1:sz
%     for col = 1:sz
%         flag = round( sqrt((row-mid)^2+(col-mid)^2 ));
%         if ( abs(flag - round(r)) <= 1 )
%            img_bw(row,col) = 0; 
%         end
%     end
% end
% imshow(img_bw,[]);


%% Draw lines (level1)
% for i = 1:sz_ring
%     hold on 
%     plot([mid,node(4,i+1)], [mid,node(5,i+1)],'k','LineWidth',2);
%     pause(0.1);
% end

%% Test: level 2 & so-on
map_ring = [8,8,8,8,16,16,16,16,24,24,24,24,24,24,32,32,32,32,32,32,32,32];
map_radius = zeros(size(map_ring));
map_radius(1) = r;

for j = 2:22
    
    sz_ring = map_ring(j);
    r2 = sqrt( sz_ring* (R^2/N_max) + r^2 );
    map_radius(j) = r2; % store radius
    % r = r2;
    
    % element matrix (node assign)
    idx_mesh_loc = sum(map_ring(1:j-1) );  % shift to local co-ordinate
    idx_node_loc = 9 + sum( map_ring(2:j-1) )*2; % shift to local co-ordinate
    
    idx_mesh = idx_mesh_loc+1 : sum(map_ring(1:j) );
    mesh(1,idx_mesh) = idx_node_loc + (1:sz_ring);
    mesh(2,idx_mesh) = idx_node_loc + (1:sz_ring) + 1;
    mesh(3,idx_mesh) = idx_node_loc + (1:sz_ring) + sz_ring;
    mesh(4,idx_mesh) = idx_node_loc + (1:sz_ring) + sz_ring + 1;
    
    % fine tune element #8
    mesh(2,idx_mesh(end)) = idx_node_loc + 1;
    mesh(4,idx_mesh(end)) = idx_node_loc + sz_ring + 1;
    
    mesh = sort(mesh);
    
    % node matrix (coordinate assign)
    idx_node_r1 = idx_node_loc + (1:sz_ring);
    idx_node_r2 = idx_node_loc + (1:sz_ring) + sz_ring;
    
    % theta (in degree)
    node(1,idx_node_r1) = (1:sz_ring)*360/sz_ring - (360/sz_ring)/2 * mod(j-1,2); % level 1
    node(1,idx_node_r2) = (1:sz_ring)*360/sz_ring - (360/sz_ring)/2 * mod(j-1,2); % level 2
    % ring
    node(2,idx_node_r1) = j-1;
    node(2,idx_node_r2) = j;
    % radius
    node(3,idx_node_r1) = r;
    node(3,idx_node_r2) = r2;
    % Coordinates
    idx_node = idx_node_r1(1):idx_node_r2(end);
    node(4,idx_node) = mid + round( node(3,idx_node).*cosd(node(1,idx_node)) );
    node(5,idx_node) = mid + round( node(3,idx_node).*sind(node(1,idx_node)) );
    
        %% Plot points on screen
%     for i = idx_node
%        img_bw( node(4,i) ,  node(5,i) ) = 0;
%        pause(0.1);
%        imshow(img_bw,[]);
%     %    disp( num2str( node(4,i)) );
%     %    disp( num2str( node(5,i)) );
%     end


    %% Draw lines
%     idx_mesh = idx_mesh_loc+1 : sum(map_ring(1:j) );
%     for i = idx_mesh
%         hold on
%         idx_line = mesh(1:2,i);
%         plot(node(4,idx_line), node(5,idx_line),'k','LineWidth',2);
%         idx_line = mesh(3:4,i);
%         plot(node(4,idx_line), node(5,idx_line),'k','LineWidth',2);
%         idx_line = mesh([1,3],i);
%         plot(node(4,idx_line), node(5,idx_line),'k','LineWidth',2);
%         idx_line = mesh([2,4],i);
%         plot(node(4,idx_line), node(5,idx_line),'k','LineWidth',2);
%         pause(0.1);
%     end

    disp(['Level ',num2str(j),' complete.']);
    
    r = r2;
end


    %% Draw circle
    for row = 1:sz
        for col = 1:sz
            flag = sqrt((row-mid)^2+(col-mid)^2);
            for j = 1:size(map_radius,2)
                r = map_radius(j);
                if ( abs(flag - (r)) <= 1 )
                    img_bw(row,col) = 0;
                end
            end
        end
    end


%% Display (Complete)
tic % timer

imshow(img_bw,[]);

for i = 1:space:8
    hold on 
    plot([mid,node(4,i+1)], [mid,node(5,i+1)],'k','LineWidth',2);
%     pause(0.1);
end

toc

for j = 2:22
    sz_ring = map_ring(j);
    idx_mesh_loc = sum(map_ring(1:j-1) );  % shift to local co-ordinate
        %% Draw lines
    idx_mesh = idx_mesh_loc+1 : sum(map_ring(1:j) );
    for i = idx_mesh
        hold on
%         idx_line = mesh(1:2,i);
%         plot(node(4,idx_line), node(5,idx_line),'k','LineWidth',2);
%         idx_line = mesh(3:4,i);
%         plot(node(4,idx_line), node(5,idx_line),'k','LineWidth',2);

        idx_line = mesh([1,3],i);
        plot(node(4,idx_line), node(5,idx_line),'k','LineWidth',2);
%         idx_line = mesh([2,4],i);
%         plot(node(4,idx_line), node(5,idx_line),'k','LineWidth',2);
        if (i==idx_mesh(end)) %% For speed up
%            disp('Yo'); 
           idx_line = mesh([2,4],i);
           plot(node(4,idx_line), node(5,idx_line),'k','LineWidth',2);
        end
%         pause(0.1);
    end
end

tick1 = toc;

% Burn current figure into an image
F = getframe(ax);
[img,map] = frame2im(F); % ***Dimension of image would be distorted****
img = img(:,:,1);
% img = imresize(img,[sz sz]);

mask = (img>0);
img(mask) = 1;


figure
subplot(1,2,1);
imshow(img,[]);
subplot(1,2,2);
imshow(1-img,[]);