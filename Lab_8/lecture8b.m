clc; close all; clear all;

fpr = 8000;
Nx = 1000;

dt = 1/fpr; t = dt*(0:Nx-1)
%x = cos(2*pi*50*t);

AM = 10*()
FM = 

x = 

figure;
plot(t, x); 

%% Filtr hilberta w częstotliwości

X = fft(x);
Hh = [0,ones(1,Nx/2-1), 0, j*ones(1,Nx/2-1)]; % hilberta
Hr = [j*2*pi*fpr/Nx*(0:Nx-1)]; % różniczkówjący
Y = Hh.*X;
y = ifft(Y);

figure;
plot(t, x, '-r', t, y, '-b'); grid; pause;

AM_est = abs(y);
dfi =angle( y(2:end) .* conj(y(1:end-1))) ); 
FM_est = (1/(2*pi)) * dfi/dt;

figure;
subplot(211); plot(t, AM, '-r', t, AM_est, '-b');
subplot(212); plot(t, FM, '-r', t, FM_est, '-b');