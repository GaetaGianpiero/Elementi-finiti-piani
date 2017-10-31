% DISEGNOTRIANGOLO(P,a,b,c,grandezza) disegna un elemento finito
% triangolare:
% -P = matrice che raccoglie le coordinate dei tre punti estremanti, 
%  [x1 y1;x2 y2;x3 y3]
% -a = lettera identificante il primo punto
% -b = lettera identificante il secondo punto
% -c = lettere identificante il terzo punto
% -grandezza = spessore della linea
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0
function[]=disegnoTriangolo(P, a, b, c, grandezza)
% P=posizione dei due punti 
% Matrice [xa,ya;xb,yb;xc,yc]
hold on;
%% coloro il triangolo
fill(P(:,1),P(:,2),[0.6 0.6 0.6]);
%% disegno le linee
line([P(1,1) P(2,1)],[P(1,2) P(2,2)],[0,0],'Color','k','LineWidth',2);
line([P(1,1) P(3,1)],[P(1,2) P(3,2)],[0,0],'Color','k','LineWidth',2);
line([P(3,1) P(2,1)],[P(3,2) P(2,2)],[0,0],'Color','k','LineWidth',2);

%% disegno le cerniere
viscircles([P(1,1) P(1,2)], 30, 'Color','k');
viscircles([P(2,1) P(2,2)], 30, 'Color','k');
viscircles([P(3,1) P(3,2)], 30, 'Color','k');
%% disegno le lettere
text(P(1,1)+grandezza,P(1,2)+grandezza,a);
text(P(2,1)+grandezza,P(2,2)+grandezza,b);
text(P(3,1)+grandezza,P(3,2)+grandezza,c);
hold on;
end 