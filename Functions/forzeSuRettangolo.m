% FORZESURETTANGOLO(spessore,AB,BC,CD,DA,fAB,fBC,fCD,fDA) restituisce il
% vettore contenente le forze di superficie che agiscono su un elemento
% finito rettangolare.
%  -spessore [mm] = rappresenta lo spessore dell'elemento finito.
%  -AB,BC,... [mm] = sono le lunghezze dei lati dell'elemento finito.
%  -fAB,fBC,... [N] = sono le forze agenti sui singoli lati dell'elemento
%   finito
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0
function [forzeSuperficie] = forzeSuRettangolo (spessore,AB,BC,CD,DA,fAB,fBC,fCD,fDA)
t = spessore;
%fAB = [fABx fABy]; fBC = [fBCx fBCy] ecc.

forzeSuperficie = (t/2)*[DA*fDA(1)+AB*fAB(1); AB*fAB(1)+BC*fBC(1); BC*fBC(1)+CD*fCD(1); CD*fCD(1)+DA*fDA(1);...
    DA*fDA(2)+AB*fAB(2); AB*fAB(2)+BC*fBC(2); BC*fBC(2)+CD*fCD(2); CD*fCD(2)+DA*fDA(2)];

end