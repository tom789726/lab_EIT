% Compute traces of Faddeev solutions psi by solving Nachman's boundary
% integral equation
%
%    [I + S_k(L_gamma - L_1)]psi(x,k) = exp(ikx).
%
% We can write
%
%    I + S_k(L_gamma - L_1) = I + (S_0 + H_k)(L_gamma - L_1),
%
% where S_0 is the standard single layer operator.
%
% We solve the integral equation in the Fourier basis.
% The operators L_gamma and L_1 are Dirichlet-to_Neumann maps
% that can be computed from the ND-map and analytically.
%
% Samuli Siltanen and Janne P. Tamminen November 2017

% Load precomputed ND map
load data/ND NtoD Ntrig

% Loop over points in the k-grid
load data/Kvec Kvec

DNpsi    = zeros(2*Ntrig,length(Kvec));
Fpsi_BIE = zeros(2*Ntrig+1,length(Kvec)); % to compare with earlier versions
for kkk = 1:length(Kvec)
    k = Kvec(kkk);
    
    % Given k and the ND-map, solve the CGO solution psi and the function 
    % (DN-DN1)psi as vectors
    [psivec,DNpsivec] = solveBIE(NtoD,k);
    DNpsi(:,kkk)      = DNpsivec;
    
    % Put the psi-vector to a container and include the "zero"-component
    % (put zero there, as good as any)
    Fpsi_BIE(:,kkk) = [psivec(1:Ntrig);0;psivec(Ntrig+1:end)];

    % Monitor the run
    if mod(kkk,100)==0
        disp(['Done ', num2str(kkk), ' out of ', num2str(length(Kvec))])
    end
end

% Save the final psi function to file
save data/psi_BIE Fpsi_BIE DNpsi
