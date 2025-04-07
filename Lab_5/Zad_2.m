clear all; close all;

w3dB = 2*pi*100; % promień okregu
w = 0.1:0.1:2000;

% poly(A)       - Obliczanie wielomianu charakterystycznego dla A
% polyval(p, x) - Rozwinięcie wielomianu p w każdym punkcie x


N1 = 2;
alpha = pi/N1; % kat kawałka okregu
beta1 = pi/2 + alpha/2 + alpha*(0:N1-1); % katy kolejnych biegunow transmitancji
p1 = w3dB*exp(j*beta1); % bieguny transmitancji lezace na okregu
z = []; wzm = prod(-p1); % LOW-PASS: brak zer tramsitancji, wzmocnienie
%z = zeros(1,N); wzm = 1; % HIGH-PASS: N zer transmitancji, wzmocnienie
b = wzm*poly(z); a=poly(p1); % [z,p] --> [b,a]
b = real(b); a=real(a);

H1    = polyval(b, j*w)./polyval(a, j*w);
H1    = H1./max(H1);
H1log = 20*log10(abs(H1));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N2 = 4;
alpha = pi/N2; % kat kawałka okregu
beta2 = pi/2 + alpha/2 + alpha*(0:N2-1); % katy kolejnych biegunow transmitancji
p2 = w3dB*exp(j*beta2); % bieguny transmitancji lezace na okregu
z = []; wzm = prod(-p2); % LOW-PASS: brak zer tramsitancji, wzmocnienie
%z = zeros(1,N); wzm = 1; % HIGH-PASS: N zer transmitancji, wzmocnienie
b = wzm*poly(z); a=poly(p2); % [z,p] --> [b,a]
b = real(b); a=real(a);

H2    = polyval(b, j*w)./polyval(a, j*w);
H2    = H2./max(H2);
H2log = 20*log10(abs(H2));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N3 = 6;
alpha = pi/N3; % kat kawałka okregu
beta3 = pi/2 + alpha/2 + alpha*(0:N3-1); % katy kolejnych biegunow transmitancji
p3 = w3dB*exp(j*beta3); % bieguny transmitancji lezace na okregu
z = []; wzm = prod(-p3); % LOW-PASS: brak zer tramsitancji, wzmocnienie
%z = zeros(1,N); wzm = 1; % HIGH-PASS: N zer transmitancji, wzmocnienie
b = wzm*poly(z); a=poly(p3); % [z,p] --> [b,a]
b = real(b); a=real(a);

H3    = polyval(b, j*w)./polyval(a, j*w);
H3    = H3./max(H3);
H3log = 20*log10(abs(H3));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N4 = 8;
alpha = pi/N4; % kat kawałka okregu
beta4 = pi/2 + alpha/2 + alpha*(0:N4-1); % katy kolejnych biegunow transmitancji
p4 = w3dB*exp(j*beta4); % bieguny transmitancji lezace na okregu
z = []; wzm = prod(-p4); % LOW-PASS: brak zer tramsitancji, wzmocnienie
%z = zeros(1,N); wzm = 1; % HIGH-PASS: N zer transmitancji, wzmocnienie
b = wzm*poly(z); a=poly(p4); % [z,p] --> [b,a]
b = real(b); a=real(a);

H4    = polyval(b, j*w)./polyval(a, j*w);
H4    = H4./max(H4);
H4log = 20*log10(abs(H4));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wykresy biegunów
figure('Name',"Filtry Butterworth LP");

subplot(2,2,1);
plot(real(p1),imag(p1),'b x');
title('Butterworth LP N=2');
xlim(max(abs(xlim)).*[-1 1]);

subplot(2,2,2);
plot(real(p2),imag(p2),'b x');
title('Butterworth LP N=4');
xlim(max(abs(xlim)).*[-1 1])

subplot(2,2,3);
plot(real(p3),imag(p3),'b x');
title('Butterworth LP N=6');
xlim(max(abs(xlim)).*[-1 1])

subplot(2,2,4);
plot(real(p4),imag(p4),'b x');
title('Butterworth LP N=8');
xlim([-1000,1000])
ylim([-1000,1000])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Narysuj na jednym rysunku ich charakterystyki amplitudowe
f    = w./2*pi;
flog = log10(f);

% W skali liniowej
figure('Name',"Charakterystyki amplitudowe"); 

subplot(1,2,1);
hold all;
plot(f, abs(H1),'k');
plot(f, abs(H2),'b');
plot(f, abs(H3),'r');
plot(f, abs(H4),'g');
title('Skala liniowa |H(j\omega)|');
legend('N=2','N=4','N=6','N=8');
xlabel('f [Hz]');
ylabel('H [j\omega]');
xlim([0 f(end)]);
hold off;

% W skali logarytmicznej
subplot(1,2,2);
hold all; 
semilogx(f,H1log,'k');
semilogx(f,H2log,'b');
semilogx(f,H3log,'r');
semilogx(f,H4log,'g');
title('Skala decybelowa 20*log_{10}|H(j\omega)|');
legend('N=2','N=4','N=6','N=8');
xlabel('log_{10}(f) [Hz]');
ylabel('H [j\omega]');
xlim([0 f(end)]);
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Narysuj charakterystyki fazowe



Hp1 = angle(H1);
Hp2 = angle(H2);  
Hp3 = angle(H3);
Hp4 = angle(H4);


figure('Name','Charakterystyka fazowo-częstotliwościowa');
hold all;
plot(f, Hp1,'k'); 
plot(f, Hp2,'b'); 
plot(f, Hp3,'r'); 
plot(f, Hp4,'g'); 
title('Charakterystyka fazowo-częstotliwościowa');
xlabel('Częstotliwośc znormalizowana [Hz]');
legend('N=2','N=4','N=6','N=8');
ylabel('Faza [rad])');
xlim([0 f(end)]);
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Wyznacz i narysuj odpowiedź impulsową filtru N=4 
% oraz jego odpowiedź na skok jednostkowy.


[bm, an] = zp2tf(z, p2, 1);   

sys = tf(bm, an); % Transmitancja
printsys(bm, an,'s'); % Print filtru analogowego

figure();
impulse(sys);

figure();
step(sys);

% zp2tf - Konwertuje parametry filtra zerowego wzmocnienia 
% z biegunów do wielomianów jw











































% Hp1 = atan(imag(H1)./real(H1));  % atan - Inverse tangent in radians
% Hp2 = atan(imag(H2)./real(H2));  
% Hp3 = atan(imag(H3)./real(H3));
% Hp4 = atan(imag(H4)./real(H4));
