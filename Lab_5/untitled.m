close all; clear all;

b = [0.5, 2];
a = [0.25,0.5,0.75,1]

f = 0:10:10000;
w = 2*pi*f;
s = j*w;

H = polyval(b,s)./polyval(a,s);

figure
subplot(211);polt(f,20*log(abs(H)),'b-');grid;xlabel('f hz');tiltle('|H(f)| db');
subplot(212);polt(f,);grid;xlabel('f hz');tiltle('|H(f)| db');
