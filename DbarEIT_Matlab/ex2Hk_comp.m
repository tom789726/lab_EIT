% Computes and saves the operator H_k acting on the Fourier basis 
% for a collection of grid points in the k-plane. 
% H_k is the following integral operator:
%
%   (H_k f)(x) = \int_{unitcircle} Htilde(k*(x-y))*f(y) dsigma(y), 
%
% where x is a point on the unit circle, 
% Htilde(x) = H1(x)-H1(0) = G1(x)-G0(x)-H1(0),
% and G1 is Faddeev's Green function for the Laplacian.
% The function Htilde can be evaluated using routine Htilde.m.
% 
% Dimension of trigonometric approximation is taken from file ex2DN_comp.m.
% Collection of grid points in the k-plane is created by ex2Kvec_comp.m.
%
% Samuli Siltanen June 2012

% Order of trigonometric approximation is loaded from file. 
% Basis will be exp(i*n*theta) for n = [-Ntrig : Ntrig].
load data/ND Ntrig

% Construct integration points (angles) on the circle
Ntheta = 128;
theta  = 2*pi*[0:(Ntheta-1)]/Ntheta;
theta  = theta(:);
Dtheta = theta(2)-theta(1);
save data/theta theta Ntheta Dtheta

% Loop over points in the k-grid
load data/ex2Kvec Kvec 
for kkk = 1:length(Kvec)
    k = Kvec(kkk);
    
    tic
    % Initialization of the result
    Nvec = [-Ntrig : Ntrig];
    Hk   = zeros(length(Nvec));
    
    % Loop over Fourier basis functions and apply the operator to each of them.
    % Then compute inner procucts of the result with basis functions.
    % This way we build a matrix for the operator H_k.
    for nnn = 1:length(Nvec)
        % Trigonometric basis function
        n    = Nvec(nnn); 
        bfun = exp(i*n*theta); 
        
        % Compute result of operator H_k applied to the basis function
        Hk_bfun = zeros(Ntheta,1);
        for iii = 1:Ntheta
            HH = H1tilde(k*(exp(i*theta(iii)) - exp(i*theta)));
            Hk_bfun(iii) = Dtheta*sum(HH .* bfun);
        end
        % Expand the result in trigonometric basis. 
        for jjj = 1:length(Nvec)
            Hk(jjj,nnn) = 1/(2*pi)*Dtheta*exp(i*Nvec(jjj)*theta)'*Hk_bfun;
        end 
        disp(['Done ', num2str(nnn), ' out of ', num2str(length(Nvec))])
    end
    
    % Save the Hk matrix to file
    savecommand = ['save data/ex2Hk_', num2str(kkk), ' Hk'];
    eval(savecommand)
    disp(['Computation ', num2str(kkk), ' of ', num2str(length(Kvec)), ' took ', num2str(toc), ' seconds'])
end


