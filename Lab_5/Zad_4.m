clear all; close all;


f = 90*10^6:100:102*10^6;
w = 2*pi*f;
fn = 96*10^6; % Częstotliwość bazowa-nośna 96MHz
fm1 = 10^6;
fm2 = 100*10^3;




% Filtr 96 MHz +- 1MHz

N = 7;
[bm, an] = ellip(N, 0.1, 70, [2*pi*(fn-fm1) 2*pi*(fn+fm1)], 's'); % [bm, an] = ellip(rząd filtru, zafalowania, tłummenie, skrajne czestliwości)
H1 = polyval(bm, j*w)./polyval(an, j*w); % polyval - oblicza wartości na podstawie współczynników wielomianu
H1 = H1/max(H1);
H1log = 20*log10(abs(H1));

figure('Name','Filtr testowy');
plot(f,H1log,'r'); 
title('Skala logarytmiczna 20*log_{10}|H(j\omega)|');
legend('1MHz');
xlabel('Częstotliwość [Hz]');  
ylabel('H [j\omega]');
ylim([-180, 20]);
grid;


% Filtr 96 MHz +- 100kHz

N=3;
[bm, an] = ellip(N, 3, 40, [2*pi*(fn-fm2) 2*pi*(fn+fm2)], 's');
H2 = polyval(bm, j*w)./polyval(an, j*w);
H2 = H2/max(H2);
H2log = 20*log10(abs(H2));

figure('Name','Filtr docelowy');
plot(f,H2log,'r'); 
title('Skala logarytmiczna 20*log_{10}|H(j\omega)|');
legend('100kHz');
xlabel('Częstotliwość [Hz]'); 
ylabel('H [j\omega]'); 
ylim([-180, 20]);
grid;

% Porównanie

figure('Name','Porównanie transmitancji filtrów');
plot(f,H1log,'b'); 
hold on;
plot(f,H2log,'r');
title('Skala logarytmiczna 20*log_{10}|H(j\omega)|');
legend('1MHz','100kHz');
xlabel('Częstotliwość [Hz]'); 
ylabel('H [j\omega]'); 
ylim([-180, 20]);
grid;
hold off;


figure('Name','Charakterystyka amplitudowo-częstotliwościowa')
subplot(2,1,1); 
plot(f,abs(H1),'b'); title('Skala liniowa |H1(j\omega)|');
xlabel('Częstotliwość [Hz]');
ylabel('H [j\omega]');

subplot(2,1,2); 
plot(f,abs(H2),'r');
xlabel('Częstotliwość [Hz]'); title('Skala liniowa |H2(j\omega)|');
ylabel('H [j\omega]')



figure('Name','Granice pasma zaporowego i przepustowego');
hold on;
plot(f,H1log,'b'); 
plot(f,H2log,'r');
plot([95900000 95900000], [-180 2.5], 'k'); 
plot([96100000 96100000], [-180 2.5], 'k');
plot([95000000 95000000], [-180 2.5], 'k'); 
plot([97000000 97000000], [-180 2.5], 'k');
plot([90000000 102000000], [-3 -3],  'k'); 
plot([90000000 102000000], [-40 -40],'k'); 
title('Skala logarytmiczna 20*log_{10}|H(j\omega)|');
legend('1MHz','100kHz');
xlabel('Częstotliwość [Hz]'); 
ylabel('H [j\omega]'); 
grid;
hold off;

20*log10(abs(polyval(bm, j*2*pi*95900000)./polyval(an, j*2*pi*95900000)))
20*log10(abs(polyval(bm, j*2*pi*96100000)./polyval(an, j*2*pi*96100000)))