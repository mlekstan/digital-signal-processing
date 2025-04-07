% Lab15_ex_aac.m
% Principles of AAC coding using sliding MDCT transform
clear all; close all;

Nmany = 100; % number of frames
N = 2048; % window length
M = N/2; % window shift
Nx = N+M*(Nmany-1); % number of signal samples

% Input signal
%x = 0.3*randn(Nx,1); fs=44100;
[ x, fs ] = audioread('DontWorryBeHappy.wav'); size(x), pause
x = x(1:Nx,1); x=x.';
soundsc(x,fs);
figure; plot(x); pause

% MDCT and IMDCT transformation matrices
[n,k] = meshgrid(0:(N-1),0:(N/2-1)); % indexes
win = sin(pi*(n+0.5)/N); % window
C = sqrt(2/M)*win.*cos(pi/M*(k+1/2).*(n+1/2+M/2)); % MDCT matrix with window
D = C'; % IMDCT matrix with window

% Bit allocation for sub-bands
b = [ 8*ones(M/4,1); 6*ones(M/4,1); 4*ones(M/4,1); 0*ones(M/4,1) ]; sc = 2.^b;
%b = 6*ones(M,1); sc = 2.^b;

% AAC analysis-synthesis with quantization in sub-bands
y = zeros(1,Nx); figure; % output signal
for k=1:Nmany
    n1st = 1+(k-1)*M; nlast = N + (k-1)*M; % next indexes
    n = n1st : nlast; % samples from-to
    bx = x( n ); % without window
    BX = C*bx'; % MDCT
    % plot(BX); title(’Samples in bands’); pause % plot of sub-band samples
    BX = fix( sc .* BX) ./ sc; % quantization
    % BX(N/4+1:N/2,1) = zeros(N/4,1); % some processing
    by = D*BX; % IMDCT
    y( n ) = y( n ) + by'; % without window 
end

n=1:Nx;
soundsc(y,fs);
figure; plot(n,x,'ro',n,y,'bx'); title('Input (o), Output (x)'); pause

m=M+1:Nx-M;
max_abs_error = max(abs(y(m)-x(m))), pause

% Quantization of the original signal
b = 6; xq = fix( 2^b * x ) / 2^b;

% Comparison
xqs = y;
[X, f]=periodogram(x, [],512,fs, 'power','onesided'); X=10*log10(X);
[Xq,f]=periodogram(xq,[],512,fs, 'power','onesided'); Xq=10*log10(Xq);
[Xqs,f]=periodogram(xqs,[],512,fs,'power','onesided'); Xqs=10*log10(Xqs);
figure; plot(f,X,'r-',f,Xq,'b-',f,Xqs,'g-');
xlabel('f (Hz)'); title('Power/frequency (dB/Hz)'); grid; pause

SNR1 = 10*log10( sum(x(m).^2) / sum( (x(m)-xq(m)).^2 ) ),
SNR2 = 10*log10( sum(x(m).^2) / sum( (x(m)-xqs(m)).^2 ) ),