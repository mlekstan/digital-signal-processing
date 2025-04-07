close all; clear all;

x1 = [ 0, 1, 2, 3, 3, 2, 1, 0 ];
x2 = [ 0, 7, 0, 2, 0, 2, 0, 7, 4, 2 ];
x3 = [ 0, 0, 0, 0, 0, 0, 0, 15 ];

H = minNumberOfBitsPerSymbol(x1)


function itemsToNumOfAppearancesMap = countAppearances(array)
   itemsToNumOfAppearancesMap = containers.Map('KeyType','int32','ValueType','int8');

   for i = 1:length(array)
       item = array(i);
       if (isKey(itemsToNumOfAppearancesMap,item))
           itemsToNumOfAppearancesMap(item) = itemsToNumOfAppearancesMap(item) + 1;
       else
           itemsToNumOfAppearancesMap(item) = 1;
       end
   end
end


function H = minNumberOfBitsPerSymbol(x)    
    map = countAppearances(x);

    xd = cell2mat(values(map));

    signsProbabilities = double(cell2mat(values(map)))/length(x);
    
    sum = 0;
    for i = 1:length(signsProbabilities);
        if (signsProbabilities(i) > 0)
            sum = signsProbabilities(i) * log2(signsProbabilities(i)) + sum;
        end
    end

    H = -sum;
end






