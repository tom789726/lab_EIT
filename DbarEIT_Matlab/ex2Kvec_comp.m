% Construct grid in the k-plane for evaluation of the scattering transform
%
% Samuli Siltanen June 2012

% Collection of complex generalized nonzero wave numbers k 
R       = 7;
h       = .2;
N       = round(R/h);
K       = h/2 + [0:N]*h;
K       = [-fliplr(K),K];
tt      = K;
[K1,K2] = meshgrid(K);
Kvec    = K1+i*K2;
Kvec    = Kvec(abs(Kvec)<R);

% Save result to file
tMAX = R;
save data/ex2Kvec Kvec R h K1 K2 tt tMAX

