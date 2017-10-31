%FINDCOORD(str) prende come ingresso una stringa scritta nel seguente modo:
%"x y", con x e y numeri, e la trasforma in un vettore numerico con le
%corrispondenti coordinate numeriche.
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0
function [coord] = findCoord(str)
separatore = findstr(str, ' ');
if length(separatore) == 0
    coord = str2num(str);
else
for i = 1:length(separatore)+1
    if i == 1
        coord(i) = str2num(str(1:separatore(i)-1));
    else if i == length(separatore)+1
            coord(i) = str2num(str(separatore(i-1)+1:end));
        else
                coord(i) = str2num(str(separatore(i-1)+1:separatore(i)-1));
    end
    end
end
end