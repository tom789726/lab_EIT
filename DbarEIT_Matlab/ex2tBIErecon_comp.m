% Approximate reconstruction of conductivity from truncated scattering data
% using the D-bar method.
%
% We optimize the computation by restricting the degrees of freedom to the
% values of the solution at grid points satisfying |k|<R.
%
% The routine ex2tBIE_comp.m must be computed before running this file.
%
% Samuli Siltanen June 2012

% Load precomputed scattering transform and its evaluation points
load lab_EIT/DbarEIT_Matlab/data/ex2Kvec Kvec R h K1 K2 tt tMAX
load lab_EIT/DbarEIT_Matlab/data/ex2tBIE tBIE
scatBIE = zeros(size(K1));
scatBIE(abs(K1+i*K2)<tMAX) = tBIE;

% Choose parameter M for the computational grid
M = 9;
N = 2^M;

% Choose truncation radius R>0
R = 6.8;
if R>tMAX
    error(['N_recon.m: Truncation radius R=', num2str(R), ' too big, must be less than ', num2str(tMAX)])
end

% Construct grid points
[k1,k2,h,tmp,tmp,tmp] = GV_grids(M, M+1, 2.3*R);
k    = k1 + i*k2;
Rind = abs(k)<R;
Nind = round(sum(sum(double(Rind))));

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
fundfft    = fft2(fftshift(fund));

% Construct reconstruction points
Mx = 5;
[x1,x2,h,tmp,tmp,tmp] = GV_grids(Mx, Mx+1, 1);
xvec = x1(:) + i*x2(:);
Nx    = length(xvec);

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
    TR = 1/(4*pi)*scatk.*exp(-i*(k*x+conj(k*x)));
    
    % Solve the real-linear D-bar equation with gmres keeping the real and
    % imaginary parts of the solution separate
    [w,tmp,tmp,tmp,tmp] = gmres('DB_oper', rhs, 50, 1e-5, 500, [], [], iniguess, fundfft, TR, k1, k2, M, h, k, R, Rind, Nind);
    
    % Use the current solution as the next initial guess
    iniguess = w;
    
    % Construct solution mu inside the unit disc
    mu = zeros(size(k1));
    mu(Rind) = w(1:Nind) + i*w((Nind+1):end);
    
    % Pick out the reconstructed conductivity value
    recon(iii) = (mu(ind0))^2;
    
    % Monitor the run
    if mod(iii,20)==0
%         disp(['Dbar equation solved with x = ', num2str(x), ' in ', num2str(toc), ' seconds.'])
%         disp(['Done ', num2str(iii), ' out of ', num2str(Nx)])
%         disp([' '])
        disp([iii Nx])
    end
end

% Write results to file
save data/ex2recon x1 x2 recon


