clc;
% Zadanie 1 - Projektowanie metodą zer i biegunów
clear all; close all;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Zera i bieguny transmitancji

z = [-j*5 j*5 -j*15 j*15];
p = [-0.5-j*9.5 -0.5+j*9.5 -1+j*10 -1-j*10 -0.5+j*10.5 -0.5-j*10.5];

xdd=exp(-j*5)

% Zespolona zmienna transformacji Laplace'a
% dla s=jw przechodzi w transformację Fouriera:

w = 0.1:0.1:20;

% Zapisz transmitancję (1) wykorzystując powyższe parametry.
bm = poly(z);
an = poly(p);

% Przedstaw zera i bieguny na płaszczyźnie zespolonej.
figure('Name', 'Zera i bieguny');
set(figure(2),'units','points','position',[0,400,400,350])
plot(real(z),imag(z),'ro',real(p),imag(p),'b*');
title('Zera i bieguny transmitancji');
legend('Zera transmitancji','Bieguny transmitancji');
xlabel('Re');
ylabel('Img');
grid;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Narysuj charakterystykę amplitudowo-częstotliwościową 
% układu opisanego powyższymi parametrami
% w skali liniowej i w skali decybelowej:

H    = polyval(bm, j*w)./polyval(an, j*w);
Hlog = 20*log10(abs(H));

% W skali liniowej
figure('Name', 'Charakterystyka amplitudowo-częstotliwościowa');
set(figure(3),'units','points','position',[400,400,1040,350]);
subplot(1,2,1);
plot(w, abs(H),'b');
title('Skala liniowa |H(j\omega)|');
xlabel('\omega [rad/s]');
ylabel('H [j\omega]');
grid;

% W skali decybelowej
subplot(1,2,2);
plot(w, Hlog,'b');         % skala logarytmiczna
title('Skala decybelowa 20*log_{10}|H(j\omega)|');
xlabel('\omega [rad/s]');
ylabel('H [j\omega]');
grid;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Czy filtr ten jest pasmowo-przepustowy? 
% Jakie jest maksymalne i minimalne tłumienie w paśmiezaporowym? 
% Czy wzmocnienie układu w paśmie przepustowym jest równe 1? 
% Jeśli nie, to zmodyfikuj odpowiednio transmitancję układu.
xd = max(H)
H2    = H./max(H);
Hlog2 = 20*log10(abs(H2));

% W skali liniowej modyfikacja
figure('Name', 'Charakterystyka amplitudowo-częstotliwościowa - modyfikacja');
set(figure(4),'units','points','position',[400,400,1040,350]);
subplot(1,2,1);
plot(w, abs(H2),'b');
title('Skala liniowa |H(j\omega)|');
xlabel('\omega [rad/s]');
ylabel('H [j\omega]');
ylim([0 2.5]);
grid;


% W skali decybelowej modyfikacja
subplot(1,2,2);
hold on;
plot(w, Hlog2,'b');
title('Skala decybelowa 20*log_{10}|H(j\omega)|');
plot([0, 20], [-52.5 -52.5],'k');
xlabel('\omega [rad/s]');
ylabel('H [j\omega]');
grid;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Narysuj charakterystykę fazowo-częstotliwościową. 
% Czy jest ona zgodna z naszymi oczekiwaniami?
% Czyli liniowa w paśmie przepustowym, co gwarantuje, 
% że układ nie zmienia na wyjściu kształtu sygnału 
% zawartego w paśmie przepustowym.

H3 = polyval(bm, j*w)./polyval(an, j*w);
Hp = atan(imag(H3)./real(H3));  % atan - Inverse tangent in radians

figure('Name','Charakterystyka fazowo-częstotliwościowa');
set(figure(5),'units','points','position',[400,31,1040,305]);
stem(w, Hp,'b') 
title('Charakterystyka fazowo-częstotliwościowa');
xlabel('Częstotliwośc znormalizowana [Hz]');
ylabel('Faza [rad]');

figure('Name','Faza H');
set(figure(6),'units','points','position',[0,31,400,305]);
stem(phasez(H),'b');           % phazes - Phase response of digital filter
title('Faza H');
