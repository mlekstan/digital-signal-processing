function bits = jpegCode( img, q )

    bits = [];
    [ xi, yi ] = size( img );
    DC = 0;
    for x = 1:8:xi
        for y = 1:8:yi
            blok = img( x:x+7, y:y+7 );
            dblok = DCT8x8( blok );         % realizacja dyskretnej transformaty kosinusowej
            qblok = kwant( dblok, q );      % kwantyzacja wspolczynnikow transformaty DCT
            zblok = ZigZag( qblok );        % rozwijanie bloku 8x8 do wektora 64x1 algorytmem Zig-Zag
            [DCnew, pair] = RLE( zblok );   % tworzenie ,,par'' lgorytmem RLE
            bDC = VLCDC( DC-DCnew );        % kodowanie DC do bitow algorytmem VLC
            DC=DCnew;
            bblok = VLC( pair );            % kodowanie par do bitow algorytmem VLC
            bits = [ bits; bDC; bblok ];    % formowanie strumienia bitowego
        end
    end
    bq = double( dec2bin( q, 16 ) ) - 48;   % zakoduj wspolczynnik kompresji na16 bitach
    [x,y] = size( img );                    % oblicz rozmiar obrazka
    bx = double( dec2bin( floor(x/8)*8, 16 ) ) - 48; % zakoduj szerokosc obrazka na 16 bitach
    by = double( dec2bin( floor(y/8)*8, 16 ) ) - 48; % zakoduj wysokosc obrazka na 16 bitach
    bits = [ bq'; bx'; by'; bits ];         % dolaczenie na poczatku strumienia dodatkowe dane niezbedne dla dekodera
end

function y = DCT8x8( x )
    y = dct2(x);
end


function y = kwant( x, q )
    % x: blok 8x8 wspolczynnikow transformaty DCT
    % q: wspolczynnik kwantyzacji
    % y: skwantowane wspolczynniki x

    y = floor(x/q + 0.5);
end


function y = ZigZag( x )
    % x: blok 8x8 skwantowanych wspolczynnikow DCT
    % y: przeksztalcenie x do wektora 64x1 algorytem ZigZag

    % Sprawdzamy, czy wejściowy blok ma wymiary 8x8
    if size(x, 1) ~= 8 || size(x, 2) ~= 8
        error('Input block must be 8x8');
    end

    % Inicjalizujemy tablicę do przechowywania wyników
    y = zeros(64, 1);
    
    % Tablica indeksów dla skanowania zygzakowatego
    indexOrder = [
         1  2  6  7 15 16 28 29
         3  5  8 14 17 27 30 43
         4  9 13 18 26 31 42 44
        10 12 19 25 32 41 45 54
        11 20 24 33 40 46 53 55
        21 23 34 39 47 52 56 61
        22 35 38 48 51 57 60 62
        36 37 49 50 58 59 63 64
    ];

    % Przenosimy wartości z bloku 8x8 do tablicy wyjściowej zgodnie z kolejnością zygzakowatą
    for i = 1:64
        [row, col] = find(indexOrder == i);
        y(i) = x(row, col);
    end
end


function [ DC, y ] = RLE( x )
    % x: skwantowane wspolczynniki w formacie wektora o wymiarach 64x1
    % DC: wyliczona wartosc DC z biezacej ramki
    % y: wyznaczone ,,pary'' w formacie Nx2 gdzie N oznacza ilosc par (kazdy wiersz to jedna para)
    %      ilosc par w konkretnym bloku 8x8 zalezy od danych danych wejsciowych

    y = [];
    DC = x(1);
    
    koniec = 64;
    while x( koniec ) == 0
        koniec = koniec - 1;
    end
    
    i=2;
    while i<=koniec
        if x(i)~=0
            ilezer=0;
            liczba=x(i);
            i=i+1;
        else
            ilezer=0;
            while( x(i)==0 && ilezer<15 )
                i=i+1;
                ilezer=ilezer+1;
            end
            liczba=x(i);
            i=i+1;
        end
        y =[ y; [ilezer,liczba] ];
    end
    
    if( x(64) == 0 )
        y = [ y ;[0,0] ];
    end
end


function y = VLCDC( x )
    % x: wspolczynnik DC
    % y: strumien bitowy wyznaczony dla wartosci DC
    %     strumien bitowy ma byc w formacie wektora Nx1 gdzie N oznacza liczbe
    %     bitow, kazdy element wektora moze przyjmowac wartosc ,,0'' lub ,,1'',
    %     wektor moze byc typu ,,double''
    
    if( x == 0 )
        y = [ 0, 0, 0, 0 ]';
    else
        b = double( dec2bin( abs(x) ) ) - 48;
        lb = length( b );
        if x<0
            b = 1 - b;
        end
        blb = double( dec2bin( lb,4) ) - 48;
        y = [ blb, b ]';
    end
end

function y = VLC( x )
    % x: wektor ,,par'' o wymiarach Nx2 (kazdy wiersz to jedna para)
    % y: strumien bitowy wyznaczony dla wszystkich ,,par'',
    %     strumien bitowy ma byc w formacie wektora Nx1 gdzie N oznacza ilosc
    %     bitow, kazdy element wektora moze przyjmowac wartosc ,,0'' lub ,,1'',
    %     wektor moze byc typu ,,double''
    
    y = [];
    [ xx, ~ ] = size( x );
    
    for i=1:xx
        pair = x( i, : );
        
        xxxx = double( dec2bin( pair(1), 4 ) ) - 48;
        
        b = double( dec2bin( abs(pair(2)) ) ) - 48;
        lb = length( b );
        if pair(2)<0
            b = 1 - b;
        end
        blb = double( dec2bin( lb,4 ) ) - 48;
        if( pair(2) == 0 )
            tmp = [ xxxx, [ 0, 0, 0, 0 ] ]';
        else
            tmp = [ xxxx, blb, b ]';
        end
        y = [y; tmp];
    end
end
