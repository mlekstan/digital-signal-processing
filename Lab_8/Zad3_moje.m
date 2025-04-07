close all; clear all;

%% Dane trzech sygnałów sinusoidalnych
f1 = 1001.2;
f2 = 303.1;
f3 = 2110.4;

fs1 = 8e3;
fs2 = 32e3;
fs3 = 48e3;

t1 = 0:1/fs1:1-1/fs1;
t2 = 0:1/fs2:1-1/fs2;
t3 = 0:1/fs3:1-1/fs3;

%% Tworzenie i plotowanie sygnałów sinusoidalnych
x1 = sin(2*pi*f1*t1);
x2 = sin(2*pi*f2*t2);
x3 = sin(2*pi*f3*t3);

figure('Name','Fragmenty składowych sygnałow sinusoidalnych');
hold on;
plot(t1,x1,'r');
plot(t2,x2,'b');
plot(t3,x3,'g');
title('Fragmenty składowych sygnałow sinusoidalnych');
legend('1001.2Hz','303.1Hz','2110.4Hz');
xlabel('Czas [s]');
ylabel('Amplituda');
hold off;

xlim([0 1/f1]);

%% Suma trzech sygnalow sinusoidalnych analitycznie
x4 = sin(2*pi*f1*t3) + sin(2*pi*f2*t3) + sin(2*pi*f3*t3);

%% Interpolacja

K1 = 6; K2 = 3; 
M = 50; 
N = 2*M+1;
Nx1 = length(x1); Nx2 = length(x2);

x1z = zeros(1,K1*Nx1);
x1z(1:K1:end) = x1;
Nx1z = length(x1z);

h1 = K1*fir1(N, 1/K1);
x1i = filter(h1,1,x1z);
%x1i = conv(x1z,h1);
%x1i = x1i(N:Nx1z);


Nx1i = length(x1i);


x2z = zeros(1,K2*Nx2);
x2z(1:K2:end) = x2;
Nx2z = length(x2z);

h2 = K2*fir1(N, 1/K2);
x2i = filter(h2,1,x2z);
%x2i = conv(x2z,h2);
%x2i = x2i(N:Nx2z);

Nx2i = length(x2i);

%% Decymacja

L = 2; M = 50;
N = 2*M+1;

h = fir1(N,1/L-0.1*(1/L));
x2d = filter(h,1,x2i);
%x2d = conv(x2i,h);
%x2d = x2d(N:Nx2i);
x2d = x2d(1:L:end);



%% Wykrsy w dziedzinie czasu

%% Zrepróbkowany sygnał

x4r = x1i + x2d + x3(1:Nx1i);




figure; set(figure(2),'units','points','position',[720,0,720,750]);
hold on;
plot(0:1/fs1:Nx1*(1/fs1)-(1/fs1), x1, 'r');
plot(0:1/fs3:Nx1*(1/fs3)-(1/fs3), x1i(1:Nx1), 'b');
title('Sygnal x1 i x1 po resamplingu');
legend('x1',' x1 resampling');
xlim([0 1/f1]);

figure; set(figure(3),'units','points','position',[720,0,720,750]);
hold on;
plot(0:1/fs2:Nx2*(1/fs2)-(1/fs2), x2,'r');
plot(0:1/fs3:Nx2*(1/fs3)-(1/fs3), x2d(1:Nx2), 'b');
title('Sygnal x2 i x2 po resamplingu');
legend('x2',' x2 resampling');
xlim([0 1/f2]);

figure; set(figure(4),'units','points','position',[720,0,720,750]);
hold on;
plot(0:1/fs3:Nx1i*(1/fs3)-(1/fs3), x4(1:Nx1i),'r');
plot(0:1/fs3:Nx1i*(1/fs3)-(1/fs3), x4r, 'b');
title('Sygnal x4 i x4 po resamplingu');
legend('x4',' x4 resampling');
xlim([0 1/f3]);

figure; set(figure(5),'units','points','position',[720,0,720,750]);
hold on;
plot(0:1/fs3:Nx1i*(1/fs3)-(1/fs3), x1i,'r');
plot(0:1/fs3:Nx1i*(1/fs3)-(1/fs3), x2d, 'b');
plot(0:1/fs3:Nx1i*(1/fs3)-(1/fs3), x3, 'g');
xlim([0 4/f3]);

pause;
sound(x4, fs3);
pause;
sound(x4r, fs3);


%% Sygnały z plików

fs_wav = 48e3;

[x1wav, fs1wav] = audioread('x1.wav'); % 32 kHZ
[x2wav, fs2wav] = audioread('x2.wav'); % 8 kHz

pause;
sound(x1wav(:,1), fs1wav);
pause;
sound(x1wav(:,2), fs1wav);

x1wavA = x1wav(:,1)';
x1wavB = x1wav(:,2)';
x2wav = x2wav';


Nx1wavA = length(x1wavA);

x1wavAz = zeros(1,K2*Nx1wavA);
x1wavAz(1:K2:end) = x1wavA;
Nx1wavAz = length(x1wavAz);
x1wavAi = filter(h2,1,x1wavAz); % Interpolacja z 32 kHz do 96 kHz

x1wavAd = filter(h,1,x1wavAi);
x1wavAd = x1wavAd(1:L:end); % Decymacja z 96 kHz do 48 kHz



Nx1wavB = length(x1wavB);

x1wavBz = zeros(1,K2*Nx1wavB);
x1wavBz(1:K2:end) = x1wavB;
Nx1wavBz = length(x1wavBz);
x1wavBi = filter(h2,1,x1wavBz); % Interpolacja z 32 kHz do 96 kHz

x1wavBd = filter(h,1,x1wavBi);
x1wavBd = x1wavBd(1:L:end); % Decymacja z 96 kHz do 48 kHz


Nx2wav = length(x2wav);
x2wavz = zeros(1,K1*Nx2wav);
x2wavz(1:K1:end) = x2wav;
Nx2wavz = length(x2wavz);

h1 = K1*fir1(N, 1/K1);
x2wavi = filter(h1,1,x2wavz); % Interpolacja z 8 kHz do 48kHz

mix = x1wavAd(1:length(x2wavi)) + x2wavi;

pause;
sound(mix, fs_wav);




