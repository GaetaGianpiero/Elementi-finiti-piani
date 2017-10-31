% FORZESUTRAVEGEN(vettQ,vettP,m,l,i,f) restituisce il vettore contenente le
% forze agenti sull'elemento finito di trave.
% -vettQ = vettore contentente i coefficienti della distribuzione
%  trasversale: q(z) = az^2 + bz + c -> vettQ = [a b c].
% -vettP = vettore contentente i coefficienti della distribuzione 
%  assiale: p(z) = az^2 + bz + c -> vettP = [a b c].
% -m [Nm] = carico del momento flettente.
% -l [mm] = lunghezza della trave.
% -i [mm] = estremo inferiore di integrazione della distribuzione.
% -f [mm] = estremo superiore di integrazione della distribuzione.
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0
function [fTrave] = forzeSuTraveGen(vettQ,vettP,m,l,i,f)
a = vettQ(1);
b = vettQ(2);
c = vettQ(3);
d = vettP(1);
e = vettP(2);
g = vettP(3);
fTrave = [- (d*f^4)/(4*l) + (d/3 - e/(3*l))*f^3 + (e/2 - g/(2*l))*f^2 + g*f + (d*i^4)/(4*l) + (e/(3*l) - d/3)*i^3 + (g/(2*l) - e/2)*i^2 - g*i;...
     c*f - c*i + f^3*(a/3 - c/l^2 + (2*m)/l^3) - i^3*(a/3 - c/l^2 + (2*m)/l^3) - f^5*((3*a)/(5*l^2) - (2*b)/(5*l^3)) - f^4*((3*b)/(4*l^2) - c/(2*l^3)) + i^5*((3*a)/(5*l^2) - (2*b)/(5*l^3)) + i^4*((3*b)/(4*l^2) - c/(2*l^3)) + f^2*(b/2 - (3*m)/l^2) - i^2*(b/2 - (3*m)/l^2) + (a*f^6)/(3*l^3) - (a*i^6)/(3*l^3);...
      f*m - i*m + f^4*(a/4 - b/(2*l) + c/(4*l^2)) - i^4*(a/4 - b/(2*l) + c/(4*l^2)) + f^3*(b/3 - (2*c)/(3*l) + m/l^2) - i^3*(b/3 - (2*c)/(3*l) + m/l^2) - f^5*((2*a)/(5*l) - b/(5*l^2)) + i^5*((2*a)/(5*l) - b/(5*l^2)) + f^2*(c/2 - (2*m)/l) - i^2*(c/2 - (2*m)/l) + (a*f^6)/(6*l^2) - (a*i^6)/(6*l^2);...
      (3*d*f^4 + 4*e*f^3 + 6*g*f^2 - 3*d*i^4 - 4*e*i^3 - 6*g*i^2)/(12*l);...
      f^5*((3*a)/(5*l^2) - (2*b)/(5*l^3)) + f^4*((3*b)/(4*l^2) - c/(2*l^3)) - i^5*((3*a)/(5*l^2) - (2*b)/(5*l^3)) - i^4*((3*b)/(4*l^2) - c/(2*l^3)) + f^3*(c/l^2 - (2*m)/l^3) - i^3*(c/l^2 - (2*m)/l^3) - (a*f^6)/(3*l^3) + (a*i^6)/(3*l^3) + (3*f^2*m)/l^2 - (3*i^2*m)/l^2;...
      i^5*(a/(5*l) - b/(5*l^2)) - f^4*(b/(4*l) - c/(4*l^2)) - f^5*(a/(5*l) - b/(5*l^2)) + i^4*(b/(4*l) - c/(4*l^2)) - f^3*(c/(3*l) - m/l^2) + i^3*(c/(3*l) - m/l^2) + (a*f^6)/(6*l^2) - (a*i^6)/(6*l^2) - (f^2*m)/l + (i^2*m)/l];
end
