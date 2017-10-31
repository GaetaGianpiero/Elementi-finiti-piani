% VERSTR(str) verifica che la stringa inserita contenga solo numeri o uno
% spazio come caratteri.
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0
function [risultato] = verStr(str)
risultato = 1;
cont = 0;
numeri = ['0' '1' '2' '3' '4' '5' '6' '7' '8' '9' ' '];
for i = 1:length(numeri)
    if sum(str == numeri(i)) ~= 0
        cont = cont + 1;
    end
end
if cont == length(str)
    risultato = 0;
end
end