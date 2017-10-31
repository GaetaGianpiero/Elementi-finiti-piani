%KBIELLA(c,s,E,Ab,lbiella) restituisce la matrice di rigidezza di una biella
% inclinata di un angolo alpha, preso a partire dall'asse delle x, positivo
% in senso antiorario.
% 
% -c = cos(alpha)
% -s = sin(alpha)
% -E [MPa] = modulo di Young della biella.
% -Ab [mm^2] = area biella.
% -lbiella [mm] = lunghezza della biella.
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0
function[k_biella]=kBiella(c,s,E,Ab,lbiella)
k_biella = ((E*Ab)/lbiella)*([c^2, c*s, -(c)^2, -c*s; c*s, ...
        (s)^2, -c*s, -s^2; -(c)^2, -c*s, c^2, ...
        c*s; -c*s, -(s)^2, c*s, (s)^2]);
end
