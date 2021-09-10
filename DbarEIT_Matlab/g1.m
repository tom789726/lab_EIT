% Compute Faddeev's solution g_1(z) using expint. 
%
% Allan Peramaki 2011.

function g = g1(z)

g = exp(-1i*z).*real(expint(-1i*z))/(2*pi);
