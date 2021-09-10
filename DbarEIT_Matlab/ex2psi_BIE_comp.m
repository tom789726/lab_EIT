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
% that have been precomputed in routine DN_comp.m.
% The operator H_k has been precomputed in routine ex2Hk_comp.m
% for a collection of k values, which are specified in ex2Kvec_comp.m.
%
% Samuli Siltanen June 2012

% Load evaluation angles on the unit circle
load data/theta theta Ntheta Dtheta

% Load precomputed DN maps
load data/ex2DN DN DN1 Ntrig
Nvec = [-Ntrig : Ntrig];

% Construct single layer operator. In the erratum of [Siltanen-Mueller-Isaacson 2000]
% it is shown that the restriction of S_0 to functions with zero integral
% is given by inv(DN1)/2. Moreover, we can represent S_0 in this context by a matrix
% mapping constant functions to zero. This follows from the fact that S_0
% appears only in combination with DN maps (S_0 L_gamma and S_0 L_1), so
% only functions integrating to zero are given as argument to S_0.
S0 = 1/2*diag([1./[Ntrig:-1:1], 0, 1./[1:Ntrig]]);

% Loop over points in the k-grid
load data/ex2Kvec Kvec
Fpsi_BIE = zeros(2*Ntrig+1,length(Kvec));
for kkk = 1:length(Kvec)
    k = Kvec(kkk);
    
    % Compute Fourier representation of Calderon's exponential function 
    cald  = exp(i*k*exp(i*theta));
    Fcald = zeros(length(Nvec),1);
    for jjj = 1:length(Nvec)
        Fcald(jjj) = 1/(2*pi)*Dtheta*exp(i*Nvec(jjj)*theta)'*cald;
    end 
    
    % Construct the operator to be inverted
    eval(['load data/ex2Hk_', num2str(kkk), ' Hk']);
    Oper = eye(length(Nvec)) + (S0 + Hk)*(DN - DN1);
    
    % Compute Fourier coefficients of the solution psi
    Fpsi_BIE(:,kkk) = inv(Oper)*Fcald;
    
    % Monitor the run
    if mod(kkk,100)==0
        disp(['Done ', num2str(kkk), ' out of ', num2str(length(Kvec))])
    end
end

% Save the final psi function to file
save data/ex2psi_BIE Fpsi_BIE Nvec 
