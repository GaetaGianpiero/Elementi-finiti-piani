function [ordineGrandezza] = findOrdineGrandezza(lati)
numero = mean(lati);
cont = 0;
ver = 0;
while ver == 0
    stringa = num2str(numero);
    if length(stringa)== 1 | strcmp(stringa(2),'.') == 1
        ordineGrandezza = cont;
        ver = 1;
    else
        numero = numero/10;
        cont = cont + 1;
    end
end
end