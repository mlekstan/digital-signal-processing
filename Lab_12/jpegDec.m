function img = jpegDec(bits)
    % Odczyt współczynnika kompresji (zakodowanego na 16 bitach)
    q = bin2dec(char(bits(1:16) + '0'));
    bits = bits(17:end);  % Usuń bity współczynnika kwantyzacji ze strumienia bitów
    
    % Odczyt szerokości obrazka (zakodowanej na 16 bitach)
    bx = bin2dec(char(bits(1:16) + '0'));
    bits = bits(17:end);  % Usuń bity szerokości ze strumienia bitów
    
    % Odczyt wysokości obrazka (zakodowanej na 16 bitach)
    by = bin2dec(char(bits(1:16) + '0'));
    bits = bits(17:end);  % Usuń bity wysokości ze strumienia bitów
    
    % Przygotowanie pustego obrazka o odpowiednich rozmiarach
    img = zeros(bx, by);  % bx i by są w jednostkach bloków 8x8
    
    DC = 0;
    
    bitIndex = 1;
    for x = 1:8:bx
        for y = 1:8:by
            % Odczyt wartości DC
            [DCnew, bitIndex] = decodeDC(bits, bitIndex);
            DC = DC + DCnew;
            
            % Odczyt wartości AC (par RLE)
            [pairs, bitIndex] = decodeAC(bits, bitIndex);
            
            % Odtworzenie wektora z blokiem wartości skwantowanych współczynników DCT
            zblok = inverseRLE(DC, pairs);
            
            % Odtworzenie bloku 8x8
            qblok = inverseZigZag(zblok);
            
            % Dekwantyzacja
            dblok = qblok * q;
            
            % Odwrotna dyskretna transformacja kosinusowa
            blok = iDCT8x8(dblok);
            
            % Umieszczenie bloku w obrazie
            img((x-1)*8+1:x*8, (y-1)*8+1:y*8) = blok;
        end
    end
    
    img = uint8(img);
end

function blok = iDCT8x8(x)
    blok = idct2(x);
end

function y = inverseZigZag(x)
    % Odwrócenie algorytmu Zig-Zag do formatu 8x8
    y = zeros(8, 8);
    
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
    
    for i = 1:64
        [row, col] = find(indexOrder == i);
        y(row, col) = x(i);
    end
end

function [DC, bitIndex] = decodeDC(bits, bitIndex)
    blb = bin2dec(char(bits(bitIndex:bitIndex+3) + '0'));
    bitIndex = bitIndex + 4;
    
    if blb == 0
        DC = 0;
    else
        b = bits(bitIndex:bitIndex+blb-1);
        bitIndex = bitIndex + blb;
        DC = bin2dec(char(b + '0'));
        if bits(bitIndex) == 0
            DC = -DC;
        end
        bitIndex = bitIndex + 1;
    end
end

function [pairs, bitIndex] = decodeAC(bits, bitIndex)
    pairs = [];
    while true
        ilezer = bin2dec(char(bits(bitIndex:bitIndex+3) + '0'));
        bitIndex = bitIndex + 4;
        
        if ilezer == 0 && all(bits(bitIndex:bitIndex+3) == 0)
            bitIndex = bitIndex + 4;
            pairs = [pairs; 0 0];
            break;
        end
        
        lb = bin2dec(char(bits(bitIndex:bitIndex+3) + '0'));
        bitIndex = bitIndex + 4;
        
        b = bits(bitIndex:bitIndex+lb-1);
        bitIndex = bitIndex + lb;
        
        liczba = bin2dec(char(b + '0'));
        if bits(bitIndex) == 0
            liczba = -liczba;
        end
        bitIndex = bitIndex + 1;
        
        pairs = [pairs; ilezer liczba];
    end
end

function zblok = inverseRLE(DC, pairs)
    zblok = zeros(64, 1);
    zblok(1) = DC;
    
    index = 2;
    for i = 1:size(pairs, 1)
        ilezer = pairs(i, 1);
        liczba = pairs(i, 2);
        index = index + ilezer;
        zblok(index) = liczba;
        index = index + 1;
    end
end


