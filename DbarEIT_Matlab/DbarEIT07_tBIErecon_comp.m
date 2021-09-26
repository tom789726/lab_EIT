% Approximate reconstruction of conductivity from truncated scattering data
% using the D-bar method.
%
% We optimize the computation by restricting the degrees of freedom to the
% values of the solution at grid points satisfying |k|<R.
%
% The routine DbarEIT06_tBIE_comp.m must be computed before running this file.
%
% Samuli Siltanen November 2017

%% Load previous results
% Load precomputed scattering transform and its evaluation points
load data/Kvec Kvec K1 K2 tt tMAX
load data/tBIE tBIE
scatBIE = zeros(size(K1));
scatBIE(abs(K1+1i*K2)<tMAX) = tBIE;

%% Set parameters

% Construct reconstruction points. Here you can choose the x-points on
% which you recover the conductivity. It is one of the strengths of the
% D-bar method that you can reconstruct at any points, even at just one
% point or inside a region of interest. Below, if you take Mx=5, you get
% the reconstruction on a 32x32 grid; if you prefer a finer picture, you
% can take Mx=7 to get the reconstruction on a 128x128 grid.
Mx = 7;
[x1,x2,hx,tmpxa,tmpxb,tmpxc] = GV_grids(Mx, Mx+1, 1);
xvec = x1(:) + 1i*x2(:);
Nx   = length(xvec);

% Choose parameter M for the computational grid
M = 8;
N = 2^M;

% Choose truncation radius R>0. For example, you can take R=4 or R=6.
R = 6;
if R>tMAX
    error(['N_recon.m: Truncation radius R=', num2str(R), ' too big, must be less than ', num2str(tMAX)])
end

% Construct grid points
[k1,k2,h,tmpkb,tmpkc,tmpkd] = GV_grids(M, M+1, 2.3*R);
k    = k1 + 1i*k2;
Rind = abs(k)<R;
Nind = round(sum(sum(double(Rind))));


%% Evaluate scattering transform and Green's function

% Evaluate scattering transform at the grid points using precomputed values
% and two-dimensional interpolation
scatvec = zeros(Nind,1);
k1vec   = k1(Rind);
k2vec   = k2(Rind);
for iii = 1:Nind
    scatvec(iii) = interp2(K1,K2,scatBIE,k1vec(iii),k2vec(iii),'bicubic');
end
scat = zeros(size(k1));
scat(Rind) = scatvec;

% Evaluate scattering transform divided by conj(k). Avoid singularity
% at the origin by setting value there to zero.
ktmp        = k;
ind0        = (abs(k)<1e-14); % Location of the origin in the grid
ktmp(ind0)  = 1;
scatk       = scat./conj(ktmp);
scatk(ind0) = 0;

% Evaluate Green's function 1/(pi*k). Avoid singularity at the origin by
% setting value there to zero.
fund       = 1./(pi*ktmp);
fund(ind0) = 0;

% Smooth truncation of Green's function near the boundary
s  = abs(min(min(k1)));
ep = s/10;
RR = (s-ep)/2;
bigind       = abs(k)>=s;
fund(bigind) = 0;
medind       = (abs(k)<s) & (abs(k)>2*RR);
fund(medind) = fund(medind).*(1-(abs(k(medind))-2*RR)/ep);

% Take FFT of the fundamental solution at this time
fundfft = fft2(fftshift(fund));

%% Solve D-bar equation

% Construct right hand side of the Dbar equation
rhs = [ones(Nind,1);zeros(Nind,1)];

% Initialize reconstruction
recon = ones(Nx,1);
iniguess = [ones(Nind,1);zeros(Nind,1)];

% Loop over points of reconstruction
for iii = 1:Nx
    tic
    
    % Current point of reconstruction
    x = xvec(iii);
    
    % Construct multiplicator function for the Dbar equation
    TR = 1/(4*pi)*scatk.*exp(-1i*(k*x+conj(k*x)));
    
    % Solve the real-linear D-bar equation with gmres keeping the real and
    % imaginary parts of the solution separate
    [w,tmp1,tmp2,tmp3,tmp4] = gmres('DB_oper', rhs, 50, 1e-5, 500, [], [], iniguess, fundfft, TR, k1, k2, M, h, k, R, Rind, Nind);
    
    % Use the current solution as the next initial guess
    iniguess = w;
    
    % Construct solution mu inside the unit disc
    mu = zeros(size(k1));
    mu(Rind) = w(1:Nind) + 1i*w((Nind+1):end);
    
    % Pick out the reconstructed conductivity value
    recon(iii) = (mu(ind0))^2;
    
    % Monitor the run
    if mod(iii,100)==0
        disp([iii Nx])
    end
end

%% Record the results

% Write results to file
save data/recon x1 x2 recon

% Plot the results
DbarEIT07_tBIErecon_plot
