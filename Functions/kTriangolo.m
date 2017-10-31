%KTRIANGOLO(baseTriangolo,altezzaTriangolo,vc,E,v,t,A) restituisce la  
% la matrice di rigidezza di un elemento finito triangolare.
% 
% -baseTriangolo [mm] = base del triangolo.
% -altezzaTriangolo [mm] = altezza del triangolo.
% -vc = matrice delle coordinate dei vertici del triangolo organizzata 
%  come segue: vc = [xA yA; xB yB; xC yC]
% -E [mm] = modulo di Young.
% -v = modulo di Poisson.
% -t [mm] = spessore dell'elemento triangolare.
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0
function[k_triangolo]=kTriangolo(baseTriangolo,altezzaTriangolo,vc ,E, v,t, A)
if baseTriangolo == 0 
    AreaTriangolo = A;
else
AreaTriangolo=(baseTriangolo*altezzaTriangolo)/2;
end
global B
B = matriceDiCompatibilita(vc);
MatE=(E/(1-v^2)).*[1 v 0;v 1 0;0 0 (1-v)/2];
k_triangolo=t*AreaTriangolo*(B')*MatE*B;
end