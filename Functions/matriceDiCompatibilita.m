%MATRICEDICOMPATIBILITA(vc) trova la matrice di compatibilità di un
% elemento finito triangolare.
% 
% -vc = matrice delle coordinate dei vertici del triangolo organizzata 
%  come segue: vc = [xA yA; xB yB; xC yC].
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0
function[B]=matriceDiCompatibilita(vc)

DDa=vc(1,1)*(vc(2,2)-vc(3,2))-vc(1,2)*(vc(2,1)-vc(3,1))-vc(3,1)*vc(2,2)+vc(3,2)*vc(2,1);
Dax=(vc(2,2)-vc(3,2))/DDa;
Day=(vc(3,1)-vc(2,1))/DDa;

DDb=vc(2,1)*(vc(1,2)-vc(3,2))-vc(2,2)*(vc(1,1)-vc(3,1))-vc(3,1)*vc(1,2)+vc(3,2)*vc(1,1);
Dbx=(vc(1,2)-vc(3,2))/DDb;
Dby=(-vc(1,1)+vc(3,1))/DDb;

DDc=vc(3,1)*(vc(1,2)-vc(2,2))-vc(3,2)*(vc(1,1)-vc(2,1))-vc(2,1)*vc(1,2)+vc(2,2)*vc(1,1);
Dcx=(vc(1,2)-vc(2,2))/DDc;
Dcy=(-vc(1,1)+vc(2,1))/DDc;

B=[Dax Dbx Dcx 0 0 0; 0 0 0 Day Dby Dcy;Day Dby Dcy Dax Dbx Dcx];
end 