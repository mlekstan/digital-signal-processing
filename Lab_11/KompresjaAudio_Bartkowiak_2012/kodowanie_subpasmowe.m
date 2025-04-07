function [y,bps] = kodowanie_subpasmowe(x,ch,q,sf)
% KODOWANIE_SUBPASMOWE jest uproszczon� implementacj� techniki kompresji
%   wykorzystuj�cej kwantowanie sygna�u w subpasmach. Sygna� jest
%   analizowany w zespole filtr�w QMF. Pr�bki w subpasmach s� skalowane
%   i kwantowane skalarnym kwantyzatorem r�wnomiernym.
%
%   Uwaga: z�o�ono�� obliczeniowa maleje z liczb� subpasm.
%                 
%   [y,bps] = kodowanie_subpasmowe(x,n_ch,q,sf)
%   
%   x:     wektor pr�bek sygna�u wej�ciowego
%   n_ch:  liczba subpasm
%   q:     liczba bit�w na pr�bk� w ka�dym pa�mie (sta�a warto�� lub
%          wektor o d�ugo�ci <= n_ch)
%   sf:    wsp�czynniki skaluj�ce dla ka�dego subpasma; pomini�cie tego
%          parametru spowoduje automatyczn� normalizacj� w subpasmie,
%          warto�� skalarna a = skalowanie wsp�czynnikiem a^m
%   y:     wektor pr�bek zrekonstrukowanego sygna�u
%   bps:   szacowana �rednia liczba bit�w na pr�bk�

Nx=length(x);
x=x(:)';
if nargin<4 
    sf = [];
end


% Rozk�ad subpasmowy, (c) T.Zieli�ski
%------------------------------
% Parametry wej�ciowe
  M=ch;     % liczba kana��w kosinusowych
  L=16*M;    % d�ugo�� filtra prototypowego
  MM=2*M;   % liczba kana��w zespolonych, rz�d decymacji
  Lp=L/MM;  % d�ugo�� sk�adowych polifazowych = 8
  
  M2=2*M; M3=3*M; M4=4*M;
  j = 0 : Lp-1;

% Odpowied� impulsowa p(n) filtru prototypowego (niestandardowa)
  p = prototyp(L); p = sqrt(M)*p; 
  for n = 1 : 2 : Lp-1
     p( n*MM+1 : n*MM+MM ) = -p( n*MM+1 : n*MM+MM );
  end

 ap = reshape(p,2*M,Lp);
 ap=ap';
 ap=[ap(1:Lp,1:M); ap(1:Lp,M+1:M2)];
  
%  Polifazowe macierze transformacji: analizy A i syntezy B
  m=0:M2-1;
  for k=0:M-1
     A(k+1,1:M2) = 2*cos((pi/M)*(k+0.5).*(m-M/2));  % analysis matrix
     B(k+1,1:M2) = 2*cos((pi/M)*(k+0.5).*(m+M/2));  % synthesis matrix
  end

% Analiza subpasmowa
K = floor(Nx/M); bx = zeros(1,L); bv=zeros(1,2*L); y=[]; 
for k = 1 : K
    k/K
    % za�adowanie M nowych pr�bek do bufora
    bx = [ x(k*M:-1:(k-1)*M+1) bx(1:L-M) ];
    % analiza
    pbx=p.*bx;
    a=reshape(pbx,M2,Lp); % filtracja polifazowa
    u=sum(a');
    sb(:,k) = A*u';       % modulacja kosinusowa
end

%------------------------------
% Skalowanie + kwantyzacja, (c) M.Bartkowiak

if isempty(sf)
    sf = 1./max(abs(sb'));
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
    sbq = fix(q * sf * sb);
    bits = ceil(log2(max(sbq')-min(sbq')));
    bits = sum(max(bits,0))*size(sbq,2);    
    sbq = full(sf_1 * sbq / q);
else
    q = 2.^q(:);
    if length(q) < M
        q(end+1:M) = q(end);
    elseif length(qq) > M
        q = q(1:M);
    end
    qq = diag(sparse(q));
    qq_1 = diag(sparse(1./q));
    sbq = fix(qq * sf * sb);
    bits = ceil(log2(max(sbq')-min(sbq')));
    bits = sum(max(bits,0))*size(sbq,2);    
    sbq = full(qq_1 * sf_1 * sbq);    
end
bps = bits/Nx;


%------------------------------
% Synteza subpasmowa, (c) T.Zieli�ski 
K = floor(Nx/M); bx = zeros(1,L); bv=zeros(1,2*L); y=[];
for k = 1 : K
    1-k/K
    v = B'*sbq(:,k);                            % demodulacja kosinusowa
    bv = [ v' bv(1:2*L-MM) ];                   % wstawienie do bufora
    abv = reshape(bv,M4,Lp);
    abv = abv';
    abv = [abv(:,1:M); abv(:,M3+1:M4)];
    ys = sum(ap.*abv);
    y = [ y ys ];
end
%y=y(121:end);

y = y(:);
y(length(x)) = 0;
y(length(x)+1:end) = [];



%------------------------------
%  Approksymacja filtru prototypowego MPEG,  (c) T.Zieli�ski 
function p = prototyp(L)
a0=1; a(1)=-0.99998229; a(2)=0.99692250;
a(4)=1/sqrt(2); a(6)=sqrt(1-a(2)^2); a(7)=-sqrt(1-a(1)^2);
A=-( a0/2+a(1)+a(2)+a(3)+a(4)+a(6)+a(7) );
a(3)=A/2-sqrt(0.5-A^2/4); a(5)=-sqrt(1-a(3)^2);
n = 0:L-1; p = a0*ones(1,L);
for(k=1:7) p = p + 2*a(k)*cos(2*pi*k*n/L); end
p = p/L; p(1)=0;
   
   
