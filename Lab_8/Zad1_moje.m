close all; clear all;

% m(t) = 1 + A1*cos(2*π*f1*t)+ A2 cos(2*π*f2*t)+ A3*cos(2*π*f3*t)

%% Pobranie próbek syganału "x" z pliku

load('lab08_am.mat');
x = s8;
Nx = length(x);

%% Wyznaczenie odpowiedzi impulsowej h(n)

fs = 1000;
fc = 200;
t = 1;

M = 200;  
N = 2*M+1;      % szerokość filtra

h = @(n) 2*(sin(pi*n/2)).^2 .* (1./(pi*n));   % wzór na odpowiedź impulsową filtra Hilberta

n = -M:M;   % zakres próbek dla filtra nieprzyczynowego 
h = h(n);
h(M+1) = 0;    % wyliczona odpowiedź impulsowa filtra Hilberta

%% Mnożenie odpowiedzi impulsowej filtra Hilberta przed okno Blackmana

w = blackman(N);
w = w';
hw = h .* w;    % odpowiedź impulsowa hw filtra nieprzyczynowego

%% Widmo fouriera odpowiedzi impulsowej hw filtra Hilberta

f1 = -fs/2:fs/2;
% n = 0:N-1 % dla filtra przyczynowego

for k = 1:length(f1)
    omega(k) = 2*pi*f1(k)/fs;
    H(k) = sum(h .* exp(-j*omega(k)*n));
    Hw(k) = sum(hw .* exp(-j*omega(k)*n));
    
end

omega_n = omega/(2*pi);     % znormalizowana omega

figure(1);
set(figure(1),'units','points','position',[0,0,1440,750]);
subplot(2,2,1);
stem(n,h); grid; title('h(n)'); xlabel('n');
subplot(2,2,2);
stem(n,hw); grid; title('hw(n)'); xlabel('n'); 
subplot(2,2,3);
plot(omega_n,abs(H)); grid; title('|H(fn)|'); xlabel('omega/(2pi)'); 
subplot(2,2,4);
plot(omega_n,abs(Hw)); grid; title('|Hw(fn)|'); xlabel('omega/(2pi)');

%% Filtracja z pomocą odpowiedzi impulsowej filtra Hilberta hw

y = conv(x,hw);
yp = y(N:Nx);   % odcięcie stanów przejściowych (po N-1 próbek) z przodu sygnału y(n), sygnał przefiltorwany filtrem hilberta
xp = x(M+1:Nx-M);   % odcięcie tych próbek z x(n), dla których nie ma poprawnych odpowiedników w y(n), sygnał wchodzacy na filtr hilberta
m = sqrt(xp.^2 + yp.^2);  % obwiednia to pierwiastek z sumy kwadratów sygnałów xp i jego transformacji Hilberta yp

z = xp + j*yp;  % syganł analityczny
Nxp = length(xp);


figure('Name','Sygnał xp i jego transformata Hilberta yp oraz obwiednia m');
set(figure(2),'units','points','position',[0,0,1440,750]);
hold on;
plot(xp,'b'); 
plot(yp,'r');
plot(m,'k','LineWidth', 3); 
title('Sygnał x, jego transformata yp i obwiedna m')
legend('xp','HT(x)','obwiednia m');
hold off;


%% Transformacja Fouriera obwiedni m

FFT_m = fft(m)/length(m);    % transformata fouriera obwiedni
f2 = (0:length(m)-1)*fs/length(m);  % skalownie częstoliwości na podstawie wiedzy w jaki sposób jest liczone fft(m) (lab_3)

figure('Name','FFT obwiedni m')
set(figure(3),'units','points','position',[0,0,1440,750]);;
plot(f2,abs(FFT_m(1:length(m))),'b');
title('FFT obwiedni m');

%% Analiza widma obwiedni m

[pks, locs] = findpeaks(abs(FFT_m(1:length(m)/2)), f2(1:length(m)/2), 'SortStr','descend');

f_1 = locs(1); f_2=locs(2); f_3=locs(3);
A1 = pks(1);  A2=pks(2);  A3=pks(3);
A = abs(z);

%% Próba odtworzenia sygnału modulującego (obwiedni m) na podstawie wyników analizy widma obwiedni m

t_samples = 0:1/fs:t;
m_recreate = 1 + A1*cos(2*pi*f_1*t_samples) + A2*cos(2*pi*f_2*t_samples) + A3*cos(2*pi*f_3*t_samples);     % odtworzony sygnał modulujący 
m_recreate = m_recreate(M+1:Nx-M);   % odcinamy próbki ponieważ obwiedni m też posrednio zostały odcięte próbki poprzez obcięcie próbek w xp i yp

m_recreateA = A;

figure('Name','Sygnał m(t) z pliku po filtrze Hilberta oraz sygnał mrecreate(t)');
set(figure(4),'units','points','position',[0,0,1440,750]);
hold on;
plot(m,'b');
plot(m_recreate,'r');
plot(m_recreateA,'g');
%plot(abs(HT(M:end)),'k');
title('Porównanie sygnałów modulujących m, mrecreate, mrecreateA');
legend('m','mrecreate', 'mrecreateA'); 
hold off;

%% Sygnał x z pliku zmodulowany vs Sygnał xr rekonstruowany i zmodulowany
x_carrier = sin(2*pi*fc*t_samples);          % nośna z treści
x_carrier = x_carrier(M+1:Nx-M);          % odcięcie próbek
x_recreate = x_carrier.*m_recreate;                  % sygnał zmodulowany po odtworzeniu
x_recreateA = x_carrier.*m_recreateA;

figure('Name','Sygnał x wczytany z pliku oraz sygnał xrecreate');
set(figure(5),'units','points','position',[0,0,1440,750]);
hold on;
plot(xp,'r');
plot(x_recreate,'b');
plot(x_recreateA, 'g');

title('Porównanie sygnałów x i xrecreate');
legend('x  - sygnał zmodulowany, wczytany ','xrecreate - sygnał zmodulowany, rekonstr.', 'xrecreateA');
hold off;







