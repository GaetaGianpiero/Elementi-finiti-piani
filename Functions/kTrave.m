%KTRAVE(E,A,l,I) restituisce la matrice di rigidezza di un elemento finito 
% di trave.
% -E [MPa] = modulo di Young dell'elemento finito.
% -A [mm^2] = area dell'elemento finito di trave.
% -l [mm] = lunghezza della trave.
% -I [mm^4] = momento di inerzia della trave.
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0
function[k_trave]=kTrave(E,A,l,I)
k_trave=[ ((E*A)/l), 0, 0, (-(E*A)/l), 0, 0; ...
    0, 12*(E*I)/(l^3), 6*(E*I)/(l^2), 0, -12*(E*I)/(l^3), 6*(E*I)/(l^2); ...
    0, 6*(E*I)/(l^2), 4*(E*I)/l, 0, -6*(E*I)/(l^2), 2*(E*I)/l; ...
    -(E*A)/l, 0, 0, (E*A)/l, 0, 0; ...
    0, -12*(E*I)/(l^3), -6*(E*I)/(l^2), 0, 12*(E*I)/(l^3),-6*(E*I)/(l^2); ...
    0, 6*(E*I)/(l^2), 2*(E*I)/l, 0, -6*(E*I)/(l^2), 4*(E*I)/l];