close all; clear all;

%% Pobranie próbek sygnłałów modulujacych x1 i x2

[x1,fs1] = audioread('mowa8000.wav');
Nx1 = length(x1);
x1_t_samples = 0:1/fs1:Nx1*(1/fs1)-(1/fs1);
x1_t_samples(end)

x1 = x1';
x2 = fliplr(x1);

%% Dane

fs = 400*10^3;      % czestotliwość próbkowania
fc1 = 100*10^3;     % częstotliwosc nośna I stacji
fc2 = 110*10^3;     % czestotliwośc nośna II stacji
dA = 0.25;   % głebokosc modulacji

%% Wyznaczanie odpowiedzi impulsowej h(n)

M = 68;
N = 2*M+1;

h = @(n) 2*(sin(pi*n/2)).^2 .* (1./(pi*n));
n = -M:M;

h = h(n);
h(M+1) = 0;

%% Resampling (zwiekszenie liczby próbek)

x1_resample = resample(x1, fs, fs1);    % resample(data,P,Q) - Ustawienie (Q/P) < 1 prowadzi do interpolacji, czyli zwiększenia częstotliwości próbkowania poprzez dodanie nowych próbek między istniejącymi próbkami.
Nx1_resample = length(x1_resample);

x2_resample = resample(x2, fs, fs1);
Nx2_resample = length(x2_resample);

t_samples = 0:1/fs:Nx1_resample*(1/fs)-(1/fs);
t_samples(end)

%% Mnożenie przez odpowiedzi impulsowej h(n) przez okno Blackmana

w = blackman(N);
w = w';
hw = h .* w;

%% Transformacja Hilberta

x1_resample_h = conv(x1_resample,hw);   % wynik transformacji Hilberta
x1_resample_hp = x1_resample_h(N:Nx1_resample);   % x1_resample_h po synchronizacji
x1_resample_ = x1_resample(M+1:Nx1_resample-M);    % x1_resample po synchronizacji

x1_resample_ + j*x1_resample_hp;    % sygnał analityczny

Nx1_resample_ = length(x1_resample_);
t_samples_1 = 0:1/fs:Nx1_resample_*(1/fs)-(1/fs);


x2_resample_h = conv(x2_resample,hw);   % wynik transformacji Hilberta
x2_resample_hp = x2_resample_h(N:Nx2_resample);   % x2_resample_h po synchronizacji
x2_resample_ = x2_resample(M+1:Nx2_resample-M);    % x2_resample po synchronizacji

x2_resample_ + j*x2_resample_hp;    % sygnał analityczny

Nx2_resample_ = length(x2_resample_);
t_samples_2 = 0:1/fs:Nx2_resample_*(1/fs)-(1/fs);


%% Generowanie sygnałów radiowych DSB-C

y1DSB_C = (1+dA*x1_resample).*cos(2*pi*fc1*t_samples);     % I stacja
y2DSB_C = (1+dA*x1_resample).*cos(2*pi*fc2*t_samples);     % II stacja

yDSB_C = y1DSB_C + y2DSB_C;

%% Generowanie sygnałów radiowych DSB-SC

y1DSB_SC = dA*x1_resample.*cos(2*pi*fc1*t_samples);     % I stacja
y2DSB_SC = dA*x2_resample.*cos(2*pi*fc2*t_samples);     % II stacja

yDSB_SC = y1DSB_SC + y2DSB_SC;

%% Generowanie sygnałów radiowych SSB_SC ze wstęgą po lewej stronie

y1SSB_SC_l = 0.5*(dA*x1_resample_).*cos(2*pi*fc1*t_samples_1) + 0.5*x1_resample_hp.*sin(2*pi*fc1*t_samples_1);
y1SSB_SC_2 = 0.5*(dA*x2_resample_).*cos(2*pi*fc2*t_samples_2) + 0.5*x2_resample_hp.*sin(2*pi*fc2*t_samples_2);
y1SSB_SC = y1SSB_SC_l + y1SSB_SC_2;

%% Generowanie sygnałów radiowych SSB_SC ze wstęgą po prawej stronie

y2SSB_SC_l = 0.5*(dA*x1_resample_).*cos(2*pi*fc1*t_samples_1) - 0.5*x1_resample_hp.*sin(2*pi*fc1*t_samples_1);
y2SSB_SC_2 = 0.5*(dA*x2_resample_).*cos(2*pi*fc2*t_samples_2) - 0.5*x2_resample_hp.*sin(2*pi*fc2*t_samples_2);
y2SSB_SC = y2SSB_SC_l + y2SSB_SC_2;

%% Transformaty

YDSB_C = fft(yDSB_C);
YDSB_SC = fft(yDSB_SC);
Y1SSB_SC = fft(y1SSB_SC);
Y2SSB_SC = fft(y2SSB_SC);

f1 = (0:length(YDSB_C)-1)/length(yDSB_SC)*fs;
f2 = (0:length(Y1SSB_SC)-1)/length(y1SSB_SC)*fs;

figure('Name','Wykresy widm');
set(figure(1),'units','points','position',[0,0,1440,750]);

subplot(1,4,1);
plot(f1, abs(YDSB_C));
title('fft DSB-C');
xlim([80e3 130e3]);

subplot(1,4,2);
plot(f1, abs(YDSB_SC));
title('fft DSB-SC');
xlim([80e3 130e3]);

subplot(1,4,3);
plot(f2, abs(Y1SSB_SC));
title('fft SSB-SC (+)');
xlim([80e3 130e3]);

subplot(1,4,4);
plot(f2, abs(Y2SSB_SC));
title('fft SSB-SC (-)');
xlim([80e3 130e3]);






