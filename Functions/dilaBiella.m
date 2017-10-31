%DILABIELLA(epsilon,E,A,alpha) calcola le forze di dilatazione termiche
% sulla biella restituendole nel vettore f.
% La funzione richiede come parametri:
% -epsilon = coefficiente di dilatazione termica
% -E = modulo di Young [MPa]
% -A = sezione della biella [mm^2]
% -alpha = angolo di inclinazione della biella [rad]
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0
function [f] = dilaBiella(epsilon,E,A,alpha)
%epsilon = dilatazione termica
%E = Modulo di Young
%A = Area sezione biella
%f = vettore forza 4x1
f = [-E*A*epsilon*abs(cos(alpha)); -E*A*epsilon*abs(sin(alpha)); E*A*epsilon*abs(cos(alpha)); E*A*epsilon*abs(sin(alpha))];

end