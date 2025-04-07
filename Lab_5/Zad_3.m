clear all; close all;

fs = 256*10^3;
f0 = fs/2;
f3dB = f0/2;
w0 = 2*pi*f0;
w3dB = 2*pi*f3dB;

f = 0:1:300*10^3;
w = 2*pi*f;

% Filtr Butterworth

N=7;
[bm,an] = butter(N, w3dB, 's');
H1 = polyval(bm,j*w)./ polyval(an,j*w);
H1 = H1/max(H1);
H1log = 20*log10(abs(H1));

figure('Name','Filtr Butterworths');
hold on;
plot(f,H1log,'b'); 
plot([0 300]*10^3, [-3 -3],  'k'); 
plot([0 300]*10^3, [-40 -40],'k');
plot([64 64]*10^3, [20 -180],'k');
title('Skala decybelowa 20*log_{10}|H(j\omega)|');
legend('butterwoth');
xlabel('Częstotliwość [Hz]');  
ylabel('H [j\omega]');
grid;
hold off;

figure('Name','Bieguny filtru Butterworths');
plot(roots(an),'bx');
title('Bieguny filtru Butterworths');
xlim([-5*10^5,5*10^5])
ylim([-5*10^5,5*10^5])

% Filtr Czebyszewa I

N=5;
[bm,an] = cheby1(N, 3, w3dB, 's'); % drugi argument -> max tłumienie w paśmie przepustowym
H2 = polyval(bm,j*w)./ polyval(an,j*w);
H2 = H2/max(H2);
H2log = 20*log10(abs(H2));

figure('Name','Filtr Czebyszewa I');
hold on;
plot(f,H2log,'b');
plot([0 300]*10^3, [-3 -3],  'k'); 
plot([0 300]*10^3, [-40 -40],'k');
plot([64 64]*10^3, [20 -180],'k');
title('Skala decybelowa 20*log_{10}|H(j\omega)|');
legend('czebyszew I');
xlabel('Częstotliwość [Hz]');  
ylabel('H [j\omega]');
grid;
hold off;

figure('Name','Rozkład biegunów filtru Czebyszewa I');
plot(roots(an),'bx');
xlim([-8*10^4 8*10^4]);
ylim([-8*10^4 8*10^4])
title('Rozkład biegunów filtru Czebyszewa I');

% Filtr Czebyszewa II

N=5;
[bm,an] = cheby2(N, 40, w0, 's'); % drugi argument -> minimalne tłumienie w paśmie zaporowym
H3 = polyval(bm,j*w)./ polyval(an,j*w);
H3 = H3/max(H3);
H3log = 20*log10(abs(H3));

figure('Name','Filtr Czebyszewa II');
hold on;
plot(f,H3log,'b');
plot([0 300]*10^3, [-3 -3],  'k'); 
plot([0 300]*10^3, [-40 -40],'k');
plot([128 128]*10^3, [20 -180],'k');
title('Skala decybelowa 20*log_{10}|H(j\omega)|');
legend('czebyszew II');
xlabel('Częstotliwość [Hz]');  
ylabel('H [j\omega]');
grid;
hold off;

figure('Name','Bieguny filtru Czebyszewa II');
hold on;
plot(roots(an),'bx');
plot(roots(bm),'bo')
xlim([-10*10^5 10*10^5]);
ylim([-10*10^5 10*10^5]);
title('Bieguny filtru Czebyszewa II');

% Filtr eliptyczny

N=10;
[bm,an] = ellip(N, 3, 40, w3dB, 's');
H4      = polyval(bm,j*w)./ polyval(an,j*w);
H4      = H4/max(H4);
H4log   = 20*log10(abs(H4));

figure('Name','Filtr eliptyczny');
hold on;
plot(f,H4log,'b');
plot([0 300]*10^3, [-3 -3],  'k'); 
plot([0 300]*10^3, [-40 -40],'k');
plot([64 64]*10^3, [20 -180],'k');
title('Skala decybelowa 20*log_{10}|H(j\omega)|');
legend('eliptyczny');
xlabel('Częstotliwość [Hz]');  
ylabel('H [j\omega]');
grid;
hold off;

figure('Name','Wysokie tłumienie filtru eliptycznego');
plot(roots(an),'bx');
title('Rozkład biegunów filtru eliptycznego');

