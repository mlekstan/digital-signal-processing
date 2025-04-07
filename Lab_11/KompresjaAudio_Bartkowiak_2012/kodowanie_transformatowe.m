function [y,bps] = kodowanie_transformatowe(x,len,q,sf)
% KODOWANIE_TRANSFORMATOWE jest uproszczon¹ implementacj¹ techniki kompresji
%   wykorzystuj¹cej kwantowanie wspó³czynników transformaty kosinusowej. 
%   Sygna³ jest dzielony na bloki z zak³adk¹ 50%, wykonywane jest 
%   przekszta³cenie MDCT. Wspó³czynniki s¹ statycznie skalowane 
%   i kwantowane skalarnym kwantyzatorem równomiernym.
%                 
%   [y,bps] = kodowanie_transformatowe(x,len,q,sf)
%   
%   x:     wektor próbek sygna³u wejœciowego
%   len:   d³ugoœæ bloku i rozmiar przekszta³cenia MDCT (w próbkach)
%   q:     liczba bitów na wspó³czynnik (sta³a wartoœæ lub
%          wektor o d³ugoœci <= len/2)
%   sf:    wspó³czynniki skaluj¹ce dla ka¿dego wspó³czynnika transformaty; 
%          pominiêcie tego parametru spowoduje automatyczn¹ normalizacjê 
%          ci¹gu wspó³czynników na ca³ej d³ugoœci sygna³u, pojedyncza
%          wartoœæ skalarna a = skalowanie wspó³czynnikiem a^k, k=1..len/2
%   y:     wektor próbek zrekonstrukowanego sygna³u
%   bps:   szacowana œrednia liczba bitów na próbkê


%------------------------------
% (c) M.Bartkowiak

Nx=length(x);
x=x(:)';
if nargin<4 
    sf = [];
end

M = len/2;
x = [zeros(M,1); real(x(:)); zeros(M,1)];
[fx,fpad] = linframe(x,M,len,'pad'); % zak³adka 50% potrzebna do TDAC
fx = winit(fx); % okienkowanie
FX = mdct4(fx);

if isempty(sf)
    sf = 1./max(abs(FX'));
elseif length(sf) == 1
    sf = sf.^(1:M);    
elseif length(sf) < M
    sf(end+1:M) = sf(end);
elseif length(sf) > M
    sf = sf(1:M);
end
sf_1 = 1./sf;
sf = diag(sparse(sf));
sf_1 = diag(sparse(sf_1));
if length(q) == 1
    q = 2^q;
    FB = fix(q * sf * FX);
    bits = ceil(log2(max(FB')-min(FB')));
    bits = sum(max(bits,0))*size(FB,2);    
    FQ = full(sf_1 * FB / q);
else
    q = 2.^q(:);
    if length(q) < M
        q(end+1:M) = q(end);
    elseif length(qq) > M
        q = q(1:M);
    end
    qq = diag(sparse(q));
    qq_1 = diag(sparse(1./q));
    FB = fix(qq * sf * FX);
    bits = ceil(log2(max(FB')-min(FB')));
    bits = sum(max(bits,0))*size(FB,2);    
    FQ = full(qq_1 * sf_1 * FB);    
end
bps = bits/Nx;

fy = imdct4(FQ);
fy = winit(fy); % powtórne okienkowanie
y  = linunframe(fy,M,fpad); % sk³adanie bloków
y(1:M) = []; y(end-M+1:end) = [];



%----------------
% Funkcje pomocnicze 

function [fx,fpad] = linframe(x,fhop,flen,padtype)
% LINFRAME Dzieli wektor na bloki z zak³adk¹
% (c) Marios Athineos, marios@ee.columbia.edu
fpad = [0 0 0];
x = x(:);
xlen    = length(x);
fpad(3) = xlen;
fnum = fix((xlen-flen+fhop)/fhop);
frem = rem(xlen-flen+fhop,fhop);
if (frem~=0)
    fpad(2) = fhop-frem;
    fnum    = fnum+1;
    x       = [x;zeros(fpad(2),1)];
end
fx = zeros(flen,fnum);
fidx = fhop*(0:(fnum-1));
fidx = fidx(ones(flen,1),:);
sidx = (1:flen).';
sidx = sidx(:,ones(1,fnum));
fx(:) = x(fidx+sidx);
[fpad(5),fpad(6)] = size(fx);
fpad(4) = fhop;


function x = linunframe(fx,fhop,pad)
% LINUNFRAME rekonstruuje wektor z bloków z zak³adk¹
% (c) Marios Athineos, marios@ee.columbia.edu
[flen,fnum] = size(fx);
xlen = fnum*fhop + flen - fhop;
adv  = fnum*fhop;
sidx = (1:(fnum*flen)).';
fidx = adv*(0:(fnum-1));
fidx = fidx(ones(flen,1),:);
fidx = fidx(:);
lidx = sidx + fidx;
clear sidx fidx;
[i,j] = ind2sub2(xlen,lidx); 
clear lidx;
sp = sparse(i,j,fx,xlen,fnum);
x = full(sum(sp,2));
if (pad(2)<0)
    x(end-pad(2)) = 0;
elseif (pad(1)==0)
    x = x(1:end-pad(2));
else
    x = x(1+pad(1):(pad(1)+pad(3)));
end


function [i,j] = ind2sub2(siz,lidx)
%IND2SUB2 jest szybsz¹ wersj¹ matlabowskiego ind2sub dla 2 wymiarów
% (c) Marios Athineos, marios@ee.columbia.edu
zlidx = lidx-1;
clear lidx;
j = fix(zlidx./siz) + 1;
i = zlidx - siz.*(j-1) + 1; 


function y = winit(x)
% WINIT mno¿y ka¿d¹ kolumnê macierzy przez funkcjê okna
% (c) Marios Athineos, marios@ee.columbia.edu
N = size(x,1);
if (N==1)
    x = x(:);
end
w = sin(pi*((0:(N-1))+0.5)/N)';
y = diag(sparse(w)) * x;


function y = mdct4(x)
% MDCT4 oblicza zmodyfikowane przekszta³cenie kosinusowe
% (c) Marios Athineos, marios@ee.columbia.edu
[flen,fnum] = size(x);
if (flen==1)
    x = x(:);
    flen = fnum;
    fnum = 1;
end
if (rem(flen,4)~=0)
    error('MDCT4 wymaga d³ugoœci podzielnej przez 4.');
end
N     = flen; 
M     = N/2;  
N4    = N/4;  
sqrtN = sqrt(N);
rot = zeros(flen,fnum);
t = (0:(N4-1)).';
rot(t+1,:) = -x(t+3*N4+1,:);
t = (N4:(N-1)).';
rot(t+1,:) =  x(t-N4+1,:);
clear x;
t = (0:(N4-1)).';
w = diag(sparse(exp(-1i*2*pi*(t+1/8)/N)));
t = (0:(N4-1)).';
c =   (rot(2*t+1,:)-rot(N-1-2*t+1,:))...
   -1i*(rot(M+2*t+1,:)-rot(M-1-2*t+1,:));
c = 0.5*w*c;
clear rot;
c = fft(c,N4);
c = (2/sqrtN)*w*c;
t = (0:(N4-1)).';
y(2*t+1,:)     =  real(c(t+1,:));
y(M-1-2*t+1,:) = -imag(c(t+1,:));



function y = imdct4(x)
% MDCT4 oblicza odwrotne zmodyfikowane przekszta³cenie kosinusowe
% (c) Marios Athineos, marios@ee.columbia.edu
[flen,fnum] = size(x);
if (flen==1)
    x = x(:);
    flen = fnum;
    fnum = 1;
end
N     = flen;
M     = N/2;
twoN  = 2*N;
sqrtN = sqrt(twoN);
t = (0:(M-1)).';
w = diag(sparse(exp(-1i*2*pi*(t+1/8)/twoN)));
t = (0:(M-1)).';
c = x(2*t+1,:) + 1i*x(N-1-2*t+1,:);
c = (0.5*w)*c;
c = fft(c,M);
c = ((8/sqrtN)*w)*c;
rot = zeros(twoN,fnum);
t = (0:(M-1)).';
rot(2*t+1,:)   = real(c(t+1,:));
rot(N+2*t+1,:) = imag(c(t+1,:)); 
t = (1:2:(twoN-1)).';
rot(t+1,:) = -rot(twoN-1-t+1,:);
t = (0:(3*M-1)).';
y(t+1,:) =  rot(t+M+1,:);
t = (3*M:(twoN-1)).';
y(t+1,:) = -rot(t-3*M+1,:);
