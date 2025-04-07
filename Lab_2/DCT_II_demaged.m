function [macierz_DCT] = DCT_II(liczba_probek)

    for k = 0:liczba_probek-1
        for n = 0:liczba_probek-1
            if k ~= 0
                sk = sqrt(2/liczba_probek);
            else
                sk = sqrt(1/liczba_probek);
            end
            
            macierz_DCT(k+1,n+1) = sk*cos(pi*(k+0.25)/liczba_probek*(n+0.5));
    
        end
    end
end

