close all; clear all;
I2 = ; % obraz wynikowy otrzymany z apomoca skryptu auto_tabdet.m;
% --- lub rêcznie wyciêta ramka:
% I2 = imread('tab_dop.jpg');
% figure; imshow(I2,[]); title('I2 - wyciêta ramka')


%% 5b dopasowanie obrazów
I1 = imread('tab_wz.jpg'); 
% ---- ewentualne przejœcie do skali szaroœci
% I1 =  double(rgb2gray(I));
I2 = imresize(I2,[size(I1,1) size(I1,2)]); % skalowanie (czasem wymagane
% z racji sposobu dzia³ania funkcji jointhist)
figure; imshow(I1,[]); title('I1 - wzorcowy')
I1=s256(double(I1));

% ------ ewentualne dalsze skalowanie i wstêpna filtracja 

% I2 = imresize(I2, );          % skalowanie
% H  = fspecial('average',[15 15]);                 %  projekt filtra LP (ZRÓB SAM)
% I1 = imfilter(I1, H, 'symmetric','same');         %  wstêpna filtracja dolnoprzepustowa
% I2 = imfilter(I2, H, 'symmetric','same');         %  obu obrazów (ZRÓB SAM: conv2())


Iter = 50; % liczba iteracji
[NMp, PP] = MI2(I1,I2); NMp                            %  estymacja entropii wzajemnej
PPlog = log(PP+1); PPlog = abs(PPlog-max(PPlog(:)));   % skalowanie histogramu
figure, subplot(1,3,1), imshow(I1,[]),    title('Obraz odniesienia I1')
subplot(1,3,2), imshow(I2,[]),    title('Obraz I2 przed dopasowaniem do I1')
subplot(1,3,3), imshow(PPlog,[]), title('Histogram wzajemny przed dopasowaniem')

bx=1;  by=1;  bxy=0;  th=0;  tx=0;  ty=0;              % startowe wartoœci parametrów
dbx=0.1; dby=0.1; dbxy=0.05; dth=0.3; dtx=1; dty=1;    % transformacji afinicznej
par = [bx by bxy th tx ty];                            % wartoœci
dpar = [dbx dby dbxy dth dtx dty];                     % przyrosty

% G³ówna pêtla - dopasowywanie wartoœci parametrów transformacji afinicznej
MM = MI2(I1,I2);                      % informacja wzajemna
poprawa = 0;
for k = 1:Iter;                       % kolejna iteracja
    poprawa = poprawa+1;
    for m = 1:6;
        % wartoœci parametrów rosn¹
        par1 = par;
        par1(m) = par(m)+dpar(m);     % przyrost wartoœci parametrów
        Itemp = affine_tz(I2,par1);   % kolejna transformacja afiniczna
        MMt = MI2(I1,Itemp);          % kolejna wartoœæ informacji wzajemnej
        if(MMt>MM)
            MM = MMt;
            par = par1;                % zapamiêtaj jeœli lepiej
            poprawa = 0;
        end
        % wartoœci parametrów malej¹
        par1 = par;
        par1(m) = par(m)-dpar(m);     % zmniejszenie wartoœci parametrów
        Itemp = affine_tz(I2,par1);   % kolejna transformacja afiniczna
        MMt = MI2(I1,Itemp);          % kolejna wartoœæ informacji wzajemnej
        if(MMt>MM)
            MM = MMt;
            par = par1;                % zapamiêtaj jeœli lepiej
            poprawa = 0;
        end
    end
    if poprawa>1, dpar=dpar/2; dpar(5)=1; dpar(6)=1; poprawa=0; end
    if dpar(1)<1e-5, disp('Koniec'), break, end       % czy koniec?
    [k, MM, poprawa]
end
par'                                                  % pokaz „dopasowane” parametry

I20 = affine_tz(I2,par);                              % dopasuj obraz I2 do obrazu I1

[NMp, PP] = MI2(I1,I20); NMp                          % informacja wzajemna pomiêdzy  I1, I20
PPlog = log(PP+1); PPlog = abs(PPlog-max(PPlog(:)));  % histogram wzajemny w skali log
% Rysunki
figure, subplot(1,3,1), imshow(I1,[]),    title('Obraz odniesienia I1')
subplot(1,3,2), imshow(I20,[]),   title('Obraz I2 po dopasowaniu do I1')
subplot(1,3,3), imshow(PPlog,[]), title('Histogram wzajemny po dopasowaniu')
figure, subplot(1,2,1), imshow(abs(I1-I2),[]),  title('Ró¿nica I1-I2 pocz¹tkowa')
subplot(1,2,2), imshow(abs(I1-I20),[]), title('Ró¿nica I1-I20 koñcowa')
