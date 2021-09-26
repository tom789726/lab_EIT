%% [psiVec,DNpsiVec] = solveBIE(ND,k)
%
% Solves the Boundary Integral Equation
% 
% [I + (S0 + Hk)(DN - DN1)]psi(z,k) = exp(ikz)   on the boundary of D(0,1),
% 
% for the CGO solution psi(.,k) and for (DN-DN1)psi(.,k) on the boundary of
% the unit disk, as finite vectors. 
% 
% Inputs: 
% ND should be complex square matrix computed from EIT boundary
% measurements using the Fourier-basis 1/sqrt(2*pi)exp(i*n*t), 0<=t<2*pi,
% 0<abs(n)<=N for some integer N.
%
% k should be a complex number, larger than 6 should and will cause bad
% results.
%
% Outputs:
% psiVec is the vector representation of the CGO solution in the
% aforementioned basis.
%
% DNpsiVec is the vector (DN-DN1)psi which will be used in the computation
% of the scattering transform.
%
% Janne P. Tamminen
% November 2017

function [psiVec,DNpsiVec] = solveBIE(ND,k)
N    = size(ND,1)/2;

% Sampling points on the circle
Ntheta = max(40,2*N+2);      % This should be enough by the Shannon-Nyquist
theta  = 2*pi*[0:(Ntheta-1)]/Ntheta;
theta  = theta(:);
Dth    = theta(2)-theta(1);
zvec   = exp(1i*theta);  % sampling points on the boundary

% Convert to DN-maps from the input, also compute the analytical matrices
% I,DN1 and S0
nvec = [N:-1:1,1:N];
DN   = inv(ND);  % we do not need "zero"-components of the vectors/matrices
DN1  = diag(nvec);
I    = eye(2*N);
S0   = 1/2*diag(1./nvec);

% Compute the Hk-matrix (see the function itself for more info)
Hk = compute_Hktilde(k,zvec,2*pi,N);

% Compute the exponential function in vector-form.
eikz    = exp(1i*k*zvec);
tmp     = fft(eikz);
eikzVec = Dth/sqrt(2*pi)*[tmp(end-N+1:end);tmp(2:N+1)];

% compute the results in vector-form
psiVec   = (I+(S0+Hk)*(DN-DN1))\eikzVec;

DNpsiVec = (DN-DN1)*psiVec;

end


%% Compute the operator H_k as a matrix.
% This should work whenever the basis
%
% 1/sqrt(B) * exp(i*n*2*pi*s / B), 0<=s<B, 0<abs(n)<=N
%
% is used on the boundary of the domain. Here s is the arc-length parameter
% and bl the boundary length.
%
% Inputs:
% k  - complex spectral parameter
% bz - boundary points
% bl - boundary length
% N  - maximum frequency of the basis
%
% Outputs:
% Hk - complex 2*N times 2*N matrix.
%
% Janne P. Tamminen, November 2017

function Hk = compute_Hktilde(k,bz,bl,N)

% difference in the arc-length parameter
ds     = abs(bz(2)-bz(1));
Ns     = length(bz);

% points on the boundary (vertical vector),arc-length-parameters
z      = bz(:);
% differences z-y, y also in arc-length-parameters
y      = bz(:).';
ZmY    = repmat(z,1,Ns)-repmat(y,Ns,1);

% center-index = zero-frequency component of the FFT, we won't need it
ci = Ns/2+1;

% Kernel of the operator, evaluated at z-y
HK    = H1tilde(k*ZmY);

% What follows will be explained in more detail in some future publication
tmp   = conj(fftshift(fft(HK,[],2),2));      % "action" on the kernel
tmpR  = real(tmp(:,[ci-N:ci-1,ci+1:ci+N]));  % separate imag and real-parts
tmpI  = imag(tmp(:,[ci-N:ci-1,ci+1:ci+N]));  
tmpR2 = fftshift(fft(tmpR,[],1),1);          % Fourier-coefficients
tmpI2 = fftshift(fft(tmpI,[],1),1);
Hk    = ds^2/bl*(tmpR2([ci-N:ci-1,ci+1:ci+N],:) + 1i*tmpI2([ci-N:ci-1,ci+1:ci+N],:));
end


%% Computes the harmonic function 
%
%   Htilde(x) = H1(x) - H1(0) 
%             = G1(x) - G0(x) - H1(0)
%
% for planar points x given as complex numbers. Here G1 is Faddeev's Green's function and 
% G0(x) = -1 / (2*pi) log |x| is the standard Green's function for the negative Laplacian.
% Related to joint papers with Jennifer Mueller, Matti Lassas and Gunther Uhlmann.
%
% Arguments:
% x       planar evaluation points for Htilde(x), given as complex numbers
%
% Returns:
% result  values of H1tilde at evaluation points x
%
% Calls to: g1.m
%
% Samuli Siltanen Jan 2001
% Modified by Allan Peramaki 2011

function result = H1tilde(x)

% Copy-paste the code from g1_mod.m, because it's unnecessary to
% multiply by exp(1i*x).*exp(-1i*x).

result = real(expint(-1i*x)) + log(abs(x));

%-------------- Subtract H1(0) (known explicitly) -----------------------------
result = (result + 0.5772156649015328606)/(2*pi);

% Fix the value at zero.
result(x == 0) = 0;
end
