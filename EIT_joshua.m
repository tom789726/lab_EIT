clc; clear; close all;

sz = 500;
img_bw = ones(sz);
img = cat(3,img_bw,img_bw,img_bw);

%% Data Format Definition
L_max = 32; % no. of electrodes
N = L_max*(L_max-1)/2; % no. of elements


mid = sz/2; % Center
mesh = zeros(4,N); % element matrix, NULL = 0
node = zeros(5,N); % Node matrix, (theta/ring/r) --> (x,y)

%% Test: level 1
sz_ring = 8; % L, no. of elements at that level
R = 150;
r = sqrt(sz_ring/N)*R;

% element matrix (node assign)
mesh(1,1:sz_ring) = 1;
mesh(2,1:sz_ring) = (1:sz_ring)+1;
mesh(3,1:sz_ring) = (1:sz_ring)+2;
mesh(4,1:sz_ring) = 0;
% fine tune element #8
mesh(3,sz_ring) = 2;

mesh = sort(mesh);

% node matrix (coordinate assign)
node(:,1) = 0; 
node(4:5,1) = mid; % node #1: center point

idx_node = 2:sz_ring+1;
node(1,idx_node) = (0:sz_ring-1)*360/8; % theta (in degree)
node(2,idx_node) = 1; % level 1
node(3,idx_node) = r;
node(4,idx_node) = mid+ round( node(3,idx_node).*cosd( node(1,idx_node) ) ); % rcos()
node(5,idx_node) = mid+ round( node(3,idx_node).*sind( node(1,idx_node) ) ); % rsin()

disp('Level 1 complete.');

%% Plot points on screen
for i = 1:sz_ring+1
   img_bw( node(4,i) , node(5,i) ) = 0;
%    pause(0.1);
   imshow(img_bw,[]);
%    disp( num2str(mid + node(4,i)) );
%    disp( num2str(mid + node(5,i)) );
end

%% Draw circle
for row = 1:sz
    for col = 1:sz
        flag = round( sqrt((row-mid)^2+(col-mid)^2 ));
        if ( abs(flag - round(r)) <= 1 )
           img_bw(row,col) = 0; 
        end
    end
end
imshow(img_bw,[]);


%% Draw lines
for i = 1:sz_ring
    hold on 
    plot([mid,node(4,i+1)], [mid,node(5,i+1)],'k','LineWidth',2);
    pause(0.1);
end

%% Test: level 2 
r2 = r*sqrt(2);


% element matrix (node assign)
idx_mesh = sz_ring+1:sz_ring*2;
mesh(1,idx_mesh) = (1:sz_ring)+sz_ring+1;
mesh(2,idx_mesh) = (1:sz_ring)+sz_ring+2;
mesh(3,idx_mesh) = (1:sz_ring)+sz_ring*2+1;
mesh(4,idx_mesh) = (1:sz_ring)+sz_ring*2+2;
% fine tune element #8
mesh(2,sz_ring*2) = sz_ring+2;
mesh(4,sz_ring*2) = sz_ring*2+2;

mesh = sort(mesh);

% node matrix (coordinate assign)
idx_node_r1 = sz_ring+2:sz_ring*2+1;
idx_node_r2 = sz_ring*2+2 : sz_ring*3+1;

% theta (in degree)
node(1,idx_node_r1) = (1:sz_ring)*360/8 - (360/8)/2; % level 1
node(1,idx_node_r2) = (1:sz_ring)*360/8 - (360/8)/2; % level 2
% ring
node(2,idx_node_r1) = 1;
node(2,idx_node_r2) = 2;
% radius
node(3,idx_node_r1) = r;
node(3,idx_node_r2) = r2;
% Coordinates
idx_node = idx_node_r1(1):idx_node_r2(end);
node(4,idx_node) = mid+ round( node(3,idx_node).*cosd(node(1,idx_node)) );
node(5,idx_node) = mid+ round( node(3,idx_node).*sind(node(1,idx_node)) );

%% Plot points on screen
% for i = idx_node
%    img_bw( mid + node(4,i) , mid + node(5,i) ) = 0;
%    pause(0.1);
%    imshow(img_bw,[]);
% %    disp( num2str(mid + node(4,i)) );
% %    disp( num2str(mid + node(5,i)) );
% end

%% Draw lines
idx_mesh = sz_ring+1:sz_ring*2;
for i = idx_mesh
    hold on 
    idx_line = mesh(1:2,i);
    plot(node(4,idx_line), node(5,idx_line),'k','LineWidth',2);
    idx_line = mesh(3:4,i);
    plot(node(4,idx_line), node(5,idx_line),'k','LineWidth',2);
    idx_line = mesh([1,3],i);
    plot(node(4,idx_line), node(5,idx_line),'k','LineWidth',2);
    idx_line = mesh([2,4],i);
    plot(node(4,idx_line), node(5,idx_line),'k','LineWidth',2);
    pause(0.1);
end

disp('Level 2 complete.');

