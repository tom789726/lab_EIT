% Plot the result of ex2Kvec_comp.m
%
% Samuli Siltanen June 2012

% Load precomputed results
% load data/ex2Kvec Kvec R
load lab_EIT/DbarEIT_Matlab/data/ex2Kvec Kvec R

% Plot the points
figure(1)
clf
plot(real(Kvec),imag(Kvec),'r.','markersize',6)
axis equal
axis([-R R -R R])

%print -depsc ex2Kvec.eps

