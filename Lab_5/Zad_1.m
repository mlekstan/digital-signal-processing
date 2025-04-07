clear all; close all;

% Zera i bieguny transmitancji

z = [-j*5 j*5 -j*15 j*15];
p = [-0.5-j*9.5 -0.5+j*9.5 -1+j*10 -1-j*10 -0.5+j*10.5 -0.5-j*10.5];


w = 0.1:0.1:20;

% Zapisz transmitancję wykorzystując powyższe parametry.
bm = poly(z);
an = poly(p);

% Przedstaw zera i bieguny na płaszczyźnie zespolonej.
figure('Name', 'Zera i bieguny');
plot(real(z),imag(z),'ro'); hold on;
plot(real(p),imag(p),'bx')
title('Zera i bieguny transmitancji');
legend('Zera transmitancji','Bieguny transmitancji');
xlabel('Re');
xlim([-2,2])
ylabel('Img');
ylim([-20,20])
grid;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


H    = polyval(bm, j*w)./polyval(an, j*w);
Hlog = 20*log10(abs(H));

% W skali liniowej
figure('Name', 'Charakterystyka amplitudowo-częstotliwościowa');
plot(w, abs(H),'b');
title('Skala liniowa |H(j\omega)|');
xlabel('\omega [rad/s]');
ylabel('H [j\omega]');
grid;

% W skali decybelowej
figure('Name', 'Charakterystyka amplitudowo-częstotliwościowa (logarytmiczna)');
plot(w, Hlog,'b');         % skala logarytmiczna
title('Skala decybelowa 20*log_{10}|H(j\omega)|');
xlabel('\omega [rad/s]');
ylabel('H [j\omega]');
grid;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


H2    = H./max(H);
Hlog2 = 20*log10(abs(H2));

% W skali liniowej modyfikacja
figure('Name', 'Charakterystyka amplitudowo-częstotliwościowa - zmodyfikowana');
plot(w, abs(H2),'b');
title('Skala liniowa |H(j\omega)|');
xlabel('\omega [rad/s]');
ylabel('H [j\omega]');
ylim([0 2.5]);
grid;


% W skali decybelowej modyfikacja
figure('Name', 'Charakterystyka amplitudowo-częstotliwościowa - zmodyfikowana (logarytmiczna)');
hold on;
plot(w, Hlog2,'b');
title('Skala decybelowa 20*log_{10}|H(j\omega)|');
plot([0, 20], [-52.5 -52.5],'k');
xlabel('\omega [rad/s]');
ylabel('H [j\omega]');
grid;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



H3 = polyval(bm, j*w)./polyval(an, j*w);
Hp = atan(imag(H3)./real(H3)); 

figure('Name','Charakterystyka fazowo-częstotliwościowa');
plot(w, unwrap(Hp),'b-o')

title('Charakterystyka fazowo-częstotliwościowa');
xlabel('\omega [Hz]');
ylabel('Faza [rad]');