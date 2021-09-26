% This routine is for computing the scattering transform at the k-grid
% created by routine Kvec_comp.m
%
% We integrate according to the definition 
%
%  tBIE(k) = \int_{boundary} e^{i*conj(kx)} (Lg-L1) psi(x,k) d\sigma(x)
%
% using a loop over all k values in the vector Kvec.
% The result is saved to file data/tBIE.mat.
%
% Samuli Siltanen and Janne P. Tamminen November 2017

% Load vectors of k and theta values
load data/Kvec Kvec

% Integration points on the boundary
Ntheta = 128;
theta  = 2*pi*[0:(Ntheta-1)]/Ntheta;
theta  = theta(:);
Dtheta = theta(2)-theta(1);
save data/theta theta Ntheta Dtheta

% Initialize the result
tBIE  = zeros(size(Kvec));
tBIE2 = zeros(size(Kvec));

% Load precomputed vectors (DN-DN1)psi
load  data/psi_BIE DNpsi
Ntrig = size(DNpsi,1)/2;

% Basis functions as a matrix
nvec = [-Ntrig:-1,1:Ntrig];
BFs  = 1/sqrt(2*pi)*repmat(exp(1i*theta),1,length(nvec)).^repmat(nvec,Ntheta,1);

% Loop over k values
for iii = 1:length(Kvec)
    k = Kvec(iii);
    
    % Compute function (DN-DN1)psi(x,k) from its vector-form
    DNpsivec = DNpsi(:,iii);
    LLpsi    = BFs*DNpsivec;
    
    % Integrate over the boundary to get the scattering function
    tBIE(iii) = Dtheta*exp(1i*conj(k)*exp(-1i*theta.'))*LLpsi;

    % Monitor the run
    if mod(iii,100)==0
        disp(['Done ', num2str(iii), ' out of ', num2str(length(Kvec))])
    end
end

% Save the result to file.
load data/Kvec Kvec tt tMAX
save data/tBIE tBIE Kvec tt tMAX

% Plot the scattering transform
DbarEIT06_tBIE_plot
