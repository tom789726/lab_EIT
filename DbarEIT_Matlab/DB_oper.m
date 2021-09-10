% Implements the real-linear operator
%
% w |->  w-(1/(pi k))*(TR.conj(w)),
%
% where * denotes convolution and . denotes pointwise multiplication.
%
% Samuli Siltanen June 2012

function result = DB_oper(w, fundfft, TR, k1, k2, M, h, k, R, Rind, Nind)


% Reshape w to square 
N          = 2^M;
wtmp       = zeros(N, N);
wtmp(Rind) = w(1:Nind) + i*w((Nind+1):end);

% Apply real-linear operator
result = wtmp - h^2*ifft2(fundfft .* fft2(TR.*conj(wtmp)));

% Construct result as a vector with real and imaginary parts separate
result = [real(result(Rind));imag(result(Rind))];













