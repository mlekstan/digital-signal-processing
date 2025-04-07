close all; clear all;

x = [2,3,4,5,6,7]
h = [1,2,3]

y = conv(h,x)

yp = y(length(h):length(x))
xp = x(((length(h)-1)/2)+1:length(x)-((length(h)-1)/2))