function[forzeDiSuperficie,forzeDiVolume]=forzeSuTriangolo(AreaTriangolo,lato1,lato2,lato3,t,fl1,fl2,fl3,FVolume,caricoTrasversale)
%FORZESUTRIANGOLO(AreaTriangolo,lato1,lato2,lato3,t,fl1,fl2,fl3,...
% ...FVolume,caricoTrasversale)
% data la geometria del triangolo e le forze agenti su di
% esso restituisce il vettore dei carichi nodali.
% 
% -AreaTriangolo [mm^2] = area dell'elemento finito triangolare.
% -lato1 [mm] = lunghezza del primo lato del triangolo (lato AB).
% -lato2 [mm] = lunghezza del secondo lato del triangolo (lato BC).
% -lato3 [mm] = lunghezza del terzo lato del trianfolo (lato CA).
% -t [mm] = spessore triangolo.
% -fl1 [N] = forza di superficie agente sul lato1 (vettore con componenti
%  [x y]).
% -fl2 [N] = forza di superficie agente sul lato2 (vettore con componenti
%  [x y]).
% -fl3 [N] = forza di superficie agente sul lato3 (vettore con componenti
%  [x y]).
% -FVolume [N] = forza di volume agente sul triangolo (vet con componenti
%  [x y]).
% -caricoTrasversale = variabile di controllo, è uguale a 1 se si tratta di 
%  un carico trasversale, altrimenti è pari a zero.
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0

intPhib=((AreaTriangolo*t)/3)*[1 0;1 0;1 0;0 1;0 1;0 1];
forzeDiVolume=intPhib*FVolume';
if caricoTrasversale == 0
    forzeDiSuperficie = (t/2)*([lato3*fl3(1)+lato1*fl1(1); lato1*fl1(1)+lato2*fl2(1); ...
    lato2*fl2(1)+lato3*fl3(1);lato3*fl3(2)+lato1*fl1(2); lato1*fl1(2)+ ...
    lato2*fl2(2);lato2*fl2(2)+lato3*fl3(2)]);
end
if caricoTrasversale == 1
    forzeDiSuperficie = (1/2)*([lato3*fl3(1)+lato1*fl1(1); lato1*fl1(1)+lato2*fl2(1); ...
    lato2*fl2(1)+lato3*fl3(1);lato3*fl3(2)+lato1*fl1(2); lato1*fl1(2)+ ...
    lato2*fl2(2);lato2*fl2(2)+lato3*fl3(2)]);
    end
Ftot=forzeDiVolume+forzeDiSuperficie;
end