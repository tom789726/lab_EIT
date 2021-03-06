%% Setup
clear all; close all; 
run C:\Users\Tom\Documents\MATLAB\eidors-v3.10-ng\eidors\startup.m
clc;

%% Create phantom
n_elecs = 8;
imdl= mk_common_model('d2d1c',n_elecs);
% Create an homogeneous image
img_h = mk_image(imdl);

% Add a circular object at 0.2, 0.5 (edge), r=0.2
img_edg = img_h;
select_fcn = inline('(x-0.2).^2+(y-0.5).^2<0.2^2','x','y','z');
img_edg.elem_data = 1 + elem_select(img_edg.fwd_model, select_fcn)*0.5;

% Add a circular object at center, r=0.2
img_cen = img_h;
select_fcn = inline('(x-0).^2+(y-0).^2<0.5^2','x','y','z');
img_cen.elem_data = 1 + elem_select(img_cen.fwd_model, select_fcn)*0.5;

figure
h1= subplot(121);
show_fem(img_edg);
h2= subplot(122);
show_fem(img_cen);

%% Stimulation 1 
close all
amp = 5;
stim = mk_stim_patterns(n_elecs,1,'{ad}','{mono}',{'meas_current','balance_meas'},amp);
img_test = img_edg;



% Solve U(sig1,j1)
img_h.fwd_model.stimulation = stim;
img_h.fwd_solve.get_all_meas = 1;
vh = fwd_solve(img_h);

% Solve U(sig2,j1)
img_test.fwd_model.stimulation = stim;
img_test.fwd_solve.get_all_meas = 1;
vi = fwd_solve(img_test);

% *Remember EIDORS solve all combinations of current injection
% *BUT we only need 1 set of injection + meas to obtain opt. pattern

pt = size(vh.meas,1);
tks = 0:n_elecs:pt;

figure
subplot(311); plot(vi.meas); title('vi (inhomogenity)'); 
xlabel('electrode'); ylabel('voltage');
% xlim([1,pt]); xticks(tks);

subplot(312); plot(vh.meas); title('vh');
xlabel('electrode'); ylabel('voltage');
% xlim([1,pt]); xticks(tks);

ax1 = subplot(313); plot(vh.meas-vi.meas); title('vh-vi');
xlabel('electrode'); ylabel('voltage');
% xlim([1,pt]); xticks(tks);
for i = 1:8
    xline(ax1,i*8,'r--');
end

% See only particular pattern
id = 1; 
idx = (1:n_elecs)+n_elecs*id;
%

figure
subplot(311); plot(vi.meas(idx)); title( strcat('vi, pattern',num2str(id)) ); 
xlabel('electrode'); ylabel('voltage');

subplot(312); plot(vh.meas(idx)); title( strcat('vh, pattern',num2str(id)) );
xlabel('electrode'); ylabel('voltage');

ax1 = subplot(313); plot(vh.meas(idx)-vi.meas(idx)); title( strcat('vh-vi, pattern',num2str(id)) );
xlabel('electrode'); ylabel('voltage');

% See current
figure
plot(stim(id).stim_pattern);
xlabel('electrode'); ylabel('current (mA)');


%% Optimal current pattern (Initialise)
it_max = 5;
it = 0;
flag = 1;


precision = (amp*2)/2^8;

% amp = 5;
% img_test = img_cen;
% See only particular pattern
% id = 2;
% idx = (1:n_elecs)+n_elecs*id;



track = [];
track_j = []; % Store current changes
track_j = [track_j,stim(id).stim_pattern]; % **Observe single pattern only**


%% Optimal current pattern (General)
close all

while( it<it_max && flag )
    v_dif = vh.meas-vi.meas;
    stim_new = reshape(v_dif,[n_elecs,n_elecs]);
    
    % Solve new voltage values
    stim_it = mk_stim_patterns(n_elecs,1,'{ad}','{mono}',{'meas_current','balance_meas'},amp);
    for i = 1:n_elecs
        % Normalise
        mx = max( abs(stim_new(:,i)) );
        stim_new(:,i) = stim_new(:,i)/mx * amp;
        
        % Assign new pattern
        stim_it(i).stim_pattern = stim_new(:,i);
    end
    
    % Solve U(sig1,j_i)
    img_h.fwd_model.stimulation = stim_it;
    img_h.fwd_solve.get_all_meas = 1;
    vh = fwd_solve(img_h);

    % Solve U(sig2,j_i)
    img_test.fwd_model.stimulation = stim_it;
    img_test.fwd_solve.get_all_meas = 1;
    vi = fwd_solve(img_test);

    % Display
    pt = size(vi.meas,1);
    
%     figure
%     subplot(311); plot(vi.meas); title( strcat('vi, iteration',num2str(it)) );
%     xlabel('electrode'); ylabel('voltage');
%     xlim([1,pt]); xticks(0:n_elecs:pt);
%     
%     subplot(312); plot(vh.meas); title( strcat('vi, iteration',num2str(it)) );
%     xlim([1,pt]); xticks(0:n_elecs:pt);
%     
%     subplot(313); plot(vh.meas-vi.meas);
%     title('vh-vi'); xlim([1,pt]); xticks(0:n_elecs:pt);
    
%   See only particular pattern
    figure
    subplot(311); plot(vi.meas(idx)); title( strcat('vi, iteration',num2str(it)) );
    xlabel('electrode'); ylabel('voltage');
    
    subplot(312); plot(vh.meas(idx)); title( strcat('vh, iteration',num2str(it)) );
    xlabel('electrode'); ylabel('voltage');
    
    subplot(313); plot(vh.meas(idx)-vi.meas(idx));  title( strcat('vh-vi, iteration',num2str(it)) );
    xlabel('electrode'); ylabel('voltage');

 %  See changes in current pattern
    track_j = [track_j,stim_it(id).stim_pattern];
    
    % Stopping Condition (general)
    it = it+1;
    v_dif = vh.meas-vi.meas; 
    if ( sum( v_dif(idx).^2 < precision ) >= n_elecs )
        flag = 0;
        disp('flag triggered');
    end
    track = [track, sum(v_dif(idx).^2)];
%     disp(track);
end


figure
plot(track);
xlabel('iterations'); ylabel('v\_diff');

%% Display current
close all
lg = [];
n = size(track_j,2); % num of iterations

% distinguishability

% figure
% for i = 2:n
%     plot( track_j(:,i) - track_j(:,i-1) ); hold on
%     lg = [lg; i-1];
% end
% legend(strcat('iteration',num2str(lg)));
% xlabel('electrode');
% ylabel('j\_diff');


dist = [];
for i = 2:n
   dist(i) = sum( (track_j(:,i) - track_j(:,i-1)).^2  );
end
figure
plot(dist);
grid on
xlabel('iterations');
ylabel('distinguishability');

% current 
lg = [];
figure
for i = 1:n
    plot( track_j(:,i) ); hold on
    lg = [lg;i];
end
legend(strcat('iteration',num2str(lg)));
grid on
xlabel('electrode');
ylabel('current');

% current (final)
figure
plot(stim_it(id).stim_pattern);
xlabel('electrode'); ylabel('current (mA)');

%% Note: adj
% ----------define adjacent stimulation pattern by myself-------------
% amp = 5;
% s_new = zeros(n_elecs);
% for i=1:n_elecs
%     s = zeros(n_elecs,1);
%     s(i) = amp*-1;
%     if i==n_elecs
%         s(1) = amp*1;
%     else
%         s(i+1) = amp*1;
%     end
%     s_new(:,i) = s;
%     stim(i).stim_pattern = s;
% end
