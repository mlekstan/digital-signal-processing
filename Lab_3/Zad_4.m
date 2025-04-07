clc;
% Zadanie 3 -  Analiza częstotliwościowa sygnału ADSL
clear all; close all;

bity = load('lab_03.mat');
index = 416085;
modulo = mod(index, 16) + 1
x = bity.x_6;
ramki=0;

for i = 1:(4353-511-31)
    prefix = x(i:i+31);
    %No bo M = 32
    dane = x(i+511:i+542);
    kor(i) = max(abs(xcorr (prefix,dane,'coeff')));
    if (kor(i)>=0.99)
        ramki=ramki+1
        r(ramki,:)=x(i:i+511);
    end    
end

 figure(2);
 t= 1:length(kor);
 plot(t,kor),grid 
for i = 1:ramki
    X=fft(r(i,:),512);  %fft konkretniej ramki
    figure(3)
    plot(1:512,20*log10(abs(X)));
   
end


for i = 1:ramki
    figure(4)
    stem(1:512,r(i,:))
    pause(0.1);
end