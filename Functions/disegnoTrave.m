%DISEGNOTRAVE(P,s,d,grandezza) disegna un elemento finito di trave:
% -P = matrice che raccoglie le coordinate dei due punti estremanti, 
%  [x1 y1;x2 y2]
% -s = lettera identificante il primo estremo
% -d = lettera identificante il secondo estremo
% -grandezza = spessore della linea
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0
function[]=disegnoTrave(P,s,d,grandezza)
% P=posizione dei due punti -> Matrice [xa,ya;xb,yb]
% s=lettera a sinistra
% d= lettera a destra
line([P(1,1) P(2,1)],[P(1,2) P(2,2)],[0,0],'Color','k','LineWidth',4);
viscircles([P(1,1) P(1,2)], 30, 'Color','k');
viscircles([P(2,1) P(2,2)], 30, 'Color','k');
text(P(1,1)+grandezza,P(1,2)+grandezza,s);
text(P(2,1)+grandezza,P(2,2)+grandezza,d);
%hold on;
end 