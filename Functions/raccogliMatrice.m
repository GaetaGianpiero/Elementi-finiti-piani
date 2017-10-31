% RACCOGLIMATRICE(A) restituisce la potenza di 10 per cui bisogna dividere
% gli elementi della matrice A per avere tutti numeri con una sola cifra
% prima della virgola.
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0
function [espo] = raccogliMatrice(A)
massimo = max(max(abs(A)));
espo = 0;
while massimo >= 10
    massimo = massimo/10;
    espo = espo + 1;
end
end