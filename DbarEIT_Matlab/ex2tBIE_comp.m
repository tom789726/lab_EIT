% This routine is for computing the scattering transform at the k-grid
% created by routine ex2Kvec_comp.m (and saved to file data/ex2Kvec.mat).
%
% We load from file the Fourier coefficients of the traces of Faddeev 
% exponentially growing solutions created by routine ex2psi_BIE_comp.m 
% (and saved to file data/ex2psi_BIE.mat).
% The traces are evaluated at the following points on the unit circle:
% exp(i\theta), where vector \theta is previously saved to file data/theta.mat.
%
% Then we integrate according to the definition 
%
%  tBIE(k) = \int_{boundary} e^{i*conj(kx)} (Lg-L1) psi(x,k) d\sigma(x)
%
% using a loop over all k values in the vector Kvec.
% The result is saved to file data/ex2tBIE.mat.
%
% Samuli Siltanen June 2012

% Load vectors of k and theta values
load data/ex2Kvec Kvec
load data/theta theta Ntheta Dtheta

% Initialize the result
tBIE = zeros(size(Kvec));

% Load precomputed Fourier coefficients of the traces of psi
load  data/ex2psi_BIE Fpsi_BIE Nvec 

% Load precomputed DN maps
load data/ex2DN DN DN1 Ntrig
Nvec = [-Ntrig : Ntrig];

% Loop over k values
for iii = 1:length(Kvec)
    k = Kvec(iii);
    
    % Fourier representation of trace of psi
    Fpsi = Fpsi_BIE(:,iii);
    
    % Apply DN maps to evaluate (Lg-L1) psi(x,k)
    FLLpsi = (DN - DN1)*Fpsi;
    LLpsi  = zeros(size(theta));
    for jjj = 1:length(Nvec)
        LLpsi = LLpsi + FLLpsi(jjj)*exp(i*Nvec(jjj)*theta);
    end 

    % Integrate 
    tBIE(iii) = Dtheta*exp(i*conj(k)*exp(-i*theta.'))*LLpsi;
    
    % Monitor the run
    if mod(iii,100)==0
        disp(['Done ', num2str(iii), ' out of ', num2str(length(Kvec))])
    end
end

% Save the result to file.
load data/ex2Kvec Kvec tt tMAX
save data/ex2tBIE tBIE Kvec tt tMAX

