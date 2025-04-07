close all; clear all;
I2 = ; % obraz wynikowy otrzymany z apomoca skryptu auto_tabdet.m;
% --- lub r�cznie wyci�ta ramka:
% I2 = imread('tab_dop.jpg');
% figure; imshow(I2,[]); title('I2 - wyci�ta ramka')


%% 5b dopasowanie obraz�w
I1 = imread('tab_wz.jpg'); 
% ---- ewentualne przej�cie do skali szaro�ci
% I1 =  double(rgb2gray(I));
I2 = imresize(I2,[size(I1,1) size(I1,2)]); % skalowanie (czasem wymagane
% z racji sposobu dzia�ania funkcji jointhist)
figure; imshow(I1,[]); title('I1 - wzorcowy')
I1=s256(double(I1));

% ------ ewentualne dalsze skalowanie i wst�pna filtracja 

% I2 = imresize(I2, );          % skalowanie
% H  = fspecial('average',[15 15]);                 %  projekt filtra LP (ZR�B SAM)
% I1 = imfilter(I1, H, 'symmetric','same');         %  wst�pna filtracja dolnoprzepustowa
% I2 = imfilter(I2, H, 'symmetric','same');         %  obu obraz�w (ZR�B SAM: conv2())


Iter = 50; % liczba iteracji
[NMp, PP] = MI2(I1,I2); NMp                            %  estymacja entropii wzajemnej
PPlog = log(PP+1); PPlog = abs(PPlog-max(PPlog(:)));   % skalowanie histogramu
figure, subplot(1,3,1), imshow(I1,[]),    title('Obraz odniesienia I1')
subplot(1,3,2), imshow(I2,[]),    title('Obraz I2 przed dopasowaniem do I1')
subplot(1,3,3), imshow(PPlog,[]), title('Histogram wzajemny przed dopasowaniem')

bx=1;  by=1;  bxy=0;  th=0;  tx=0;  ty=0;              % startowe warto�ci parametr�w
dbx=0.1; dby=0.1; dbxy=0.05; dth=0.3; dtx=1; dty=1;    % transformacji afinicznej
par = [bx by bxy th tx ty];                            % warto�ci
dpar = [dbx dby dbxy dth dtx dty];                     % przyrosty

% G��wna p�tla - dopasowywanie warto�ci parametr�w transformacji afinicznej
MM = MI2(I1,I2);                      % informacja wzajemna
poprawa = 0;
for k = 1:Iter;                       % kolejna iteracja
    poprawa = poprawa+1;
    for m = 1:6;
        % warto�ci parametr�w rosn�
        par1 = par;
        par1(m) = par(m)+dpar(m);     % przyrost warto�ci parametr�w
        Itemp = affine_tz(I2,par1);   % kolejna transformacja afiniczna
        MMt = MI2(I1,Itemp);          % kolejna warto�� informacji wzajemnej
        if(MMt>MM)
            MM = MMt;
            par = par1;                % zapami�taj je�li lepiej
            poprawa = 0;
        end
        % warto�ci parametr�w malej�
        par1 = par;
        par1(m) = par(m)-dpar(m);     % zmniejszenie warto�ci parametr�w
        Itemp = affine_tz(I2,par1);   % kolejna transformacja afiniczna
        MMt = MI2(I1,Itemp);          % kolejna warto�� informacji wzajemnej
        if(MMt>MM)
            MM = MMt;
            par = par1;                % zapami�taj je�li lepiej
            poprawa = 0;
        end
    end
    if poprawa>1, dpar=dpar/2; dpar(5)=1; dpar(6)=1; poprawa=0; end
    if dpar(1)<1e-5, disp('Koniec'), break, end       % czy koniec?
    [k, MM, poprawa]
end
par'                                                  % pokaz �dopasowane� parametry

I20 = affine_tz(I2,par);                              % dopasuj obraz I2 do obrazu I1

[NMp, PP] = MI2(I1,I20); NMp                          % informacja wzajemna pomi�dzy  I1, I20
PPlog = log(PP+1); PPlog = abs(PPlog-max(PPlog(:)));  % histogram wzajemny w skali log
% Rysunki
figure, subplot(1,3,1), imshow(I1,[]),    title('Obraz odniesienia I1')
subplot(1,3,2), imshow(I20,[]),   title('Obraz I2 po dopasowaniu do I1')
subplot(1,3,3), imshow(PPlog,[]), title('Histogram wzajemny po dopasowaniu')
figure, subplot(1,2,1), imshow(abs(I1-I2),[]),  title('R�nica I1-I2 pocz�tkowa')
subplot(1,2,2), imshow(abs(I1-I20),[]), title('R�nica I1-I20 ko�cowa')
