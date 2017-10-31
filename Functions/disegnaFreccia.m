% DISEGNAFRECCIA(lunghezza,origine,angolo) disegna una freccia nel piano
% cartesiano:
% -lunghezza = lunghezza della freccia
% -origine = vettore [x y] delle coordinate del punto di partenza
% -angolo = angolo di inclinazione della freccia [rad]
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0
function [] = disegnaFreccia(lunghezza,origine,angolo)
%lunghezza = lunghezza della freccia
%origine = coordinate punto di partenza [x0 y0]
%fine = [origine(1) origine(2)+lunghezza];
alpha = pi/6;
fine = [origine(1)+cos(angolo)*lunghezza origine(2)+sin(angolo)*lunghezza];
axis(gca, 'equal');
line([origine(1) origine(1)+cos(angolo)*lunghezza],[origine(2) origine(2)+sin(angolo)*lunghezza],[0 0],'Color','r','LineWidth',2);
lunghezzaOb = 0.1*lunghezza;
line([fine(1) fine(1)-sin(pi/2-(angolo+alpha))*lunghezzaOb],[fine(2) fine(2)-cos(pi/2-(angolo+alpha))*lunghezzaOb],[0 0],'Color','r','LineWidth',2);
line([fine(1) fine(1)-cos(angolo-alpha)*lunghezzaOb],[fine(2) fine(2)-sin(angolo-alpha)*lunghezzaOb],[0 0],'Color','r','LineWidth',2);
end