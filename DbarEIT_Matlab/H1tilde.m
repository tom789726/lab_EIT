function result = H1tilde(x)

% Computes the harmonic function 
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

% Initialize the result
result=zeros(size(x));

% Divide the plane R^2 into two disjoint domains: disc of radius .7 and its complement.
R1 = .7;
ind = (abs(x) <= R1);

%-------------- Computation of H1 in the disc. -----------------------------------------

if max(max(ind))
    % Construct evaluation points (angles) on unit circle for Poisson kernel integration
    n = 60;
    fii = [0 : (n - 1)] .' / n * 2*pi;
    % Values of harmonic function H_1 on unit circle at points exp(i*fii)
    h1 = [  -0.05369950214829  -0.04039896548073  -0.02849751037301  -0.01791033566402  -0.00854518077172...
            -0.00030965253840   0.00688396000103   0.01311580120809   0.01845695616548   0.02296889779838...
            0.02670352070580   0.02970350118018   0.03200280045023   0.03362718835390   0.03459470862586...
            0.03491603759400   0.03459470862586   0.03362718835390   0.03200280045023   0.02970350118018...
            0.02670352070580   0.02296889779838   0.01845695616548   0.01311580120809   0.00688396000103...
            -0.00030965253840  -0.00854518077172  -0.01791033566402  -0.02849751037301  -0.04039896548073...
            -0.05369950214829  -0.06846608776055  -0.08473409157748  -0.10249018599993  -0.12165261190450...
            -0.14205038539788  -0.16340404810072  -0.18531153795448  -0.20724338480414  -0.22855136424934...
            -0.24849367327200  -0.26627750731526  -0.28111681976869  -0.29229959535716  -0.29925601771532...
            -0.30161736821465  -0.29925601771532  -0.29229959535716  -0.28111681976869  -0.26627750731526...
            -0.24849367327200  -0.22855136424934  -0.20724338480414  -0.18531153795448  -0.16340404810072...
            -0.14205038539788  -0.12165261190450  -0.10249018599993  -0.08473409157748  -0.06846608776055].';
    
    % Prepare integration quadrature points for each argument point x in the disc
    [Z, Fii] = meshgrid(x(ind), fii);
    
    % Integrate Poisson kernel to find harmonic function H1 in the disc with radius .7
    kernel = (1 - abs(Z).^2) ./ (1 - 2*abs(Z) .* cos(angle(Z) - Fii) + abs(Z).^2);
    result(ind) = (1/n * h1.' * kernel).';
end

%-------------- Computation of H1 in the complement of the disc -------------------------

if max(max(~ind))
    result(~ind) = exp(i * x(~ind)) .* g1(x(~ind)) + log(abs(x(~ind))) / (2*pi);
end

%-------------- Subtract H1(0) (known explicitly) ---------------------------------------

result = real(result - (-0.577215665 / (2*pi)));
