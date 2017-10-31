% SCRIVIMATRICE(fileTesto,A) permette di scrivere una matrice in un file di
% testo.
% 
% -fileTesto [.txt] = file di testo su cui si vuole trascrivere la matrice.
% -A = matrice generica da trascrivere.
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0
function [] = scriviMatrice(fileTesto,A)
dimensione = size(A);
for riga = 1:dimensione(1)
    fprintf(fileTesto, '| ');
    for colonna = 1:dimensione(2)
        fprintf(fileTesto, '%+.4f  ', A(riga,colonna));
    end
    fprintf(fileTesto, '|\n');
end
end
