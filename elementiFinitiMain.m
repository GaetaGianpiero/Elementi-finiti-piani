

% ELEMENTIFINITIMAIN Questa funzione permette di calcolare gli
% spostamenti di una struttura costituita da:
% -travi
% -bielle
% -elementi finiti triangolari
% -elementi finiti rettangolari
% sottoposta a forze nodali, forze di volume, di superficie e dilatazioni
% termiche, utilizzando il metodo degli elementi finiti piani.
% 
% Il programma crea automaticamente una cartella denominata "Studio", nella
% stessa directory di lavoro, in cui è possibile trovare:
% -immagine del sistema (.png e .fig)
% -file .txt contenente i risultati di tutti i passaggi del procedimento
%  (matrici di rigidezza, matrici di compatibilità, vettore delle forze e
%  spostamenti richiesti)
% -file .mat contente tutte le variabili del workspace
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0

clc
clear all
close all

percorso = cd();                            %Identifico il percorso attuale
nuovoPercorso = [percorso '/Functions'];
addpath(nuovoPercorso);

%Creazione nuova cartella per i dati:
numeroCartella = 1;
while exist(['Studio' num2str(numeroCartella)]) ~= 0
    numeroCartella = numeroCartella+1;
end
mkdir(['Studio' num2str(numeroCartella)]);            %Creo una nuova cartella
nomeCartella = ['Studio' num2str(numeroCartella)];    



%Faccio partire il programma:
elementiFinitiConDisegni;

%Salvo la figura:
saveas(gcf,'DisegnoStruttura.png');
savefig(gcf,'FiguraStruttura.fig');

%Sposto la figura:
movefile('DisegnoStruttura.png',[percorso '/Studio' num2str(numeroCartella)]);
movefile('FiguraStruttura.fig',[percorso '/Studio' num2str(numeroCartella)]);

%File di testo
fileTesto = fopen('Risultati.txt','w');     %Creo il file testo per i risultati
if numeroTravi ~= 0
    fprintf(fileTesto, '\n\nELEMENTI FINITI DI TRAVE \n\n');
    for numTrave = 1:numeroTravi
        esponente = raccogliMatrice(Trave(numTrave).K);
        vecchiaMatrice = Trave(numTrave).K;
        nuovaMatrice = vecchiaMatrice./(10^esponente);
        fprintf(fileTesto,'\n\nLa matrice di rigidezza della trave %d risulta: \n\n', numTrave);
        fprintf(fileTesto,'1.0*10^%d \n\n', esponente);
        scriviMatrice(fileTesto,nuovaMatrice);
        fprintf(fileTesto, '\nTabella delle incidenze trave %d:\n', numTrave);
        fprintf(fileTesto, 'Estremo 1: %d %d %d \n', [Trave(numTrave).spostamentiA]);
        fprintf(fileTesto, 'Estremo 2: %d %d %d \n', [Trave(numTrave).spostamentiB]);
    end
end
if numeroBielle ~= 0
    fprintf(fileTesto, '\n\nELEMENTI FINITI DI BIELLA \n\n');
    for numBiella = 1:numeroBielle
        esponente = raccogliMatrice(Biella(numBiella).K);
        vecchiaMatrice = Biella(numBiella).K;
        nuovaMatrice = vecchiaMatrice./(10^esponente);
        fprintf(fileTesto,'\n\nLa matrice di rigidezza della biella %d risulta: \n\n', numBiella);
        fprintf(fileTesto,'1.0*10^%d \n\n', esponente);
        scriviMatrice(fileTesto,nuovaMatrice);
        fprintf(fileTesto, '\nTabella delle incidenze biella %d:\n', numBiella);
        fprintf(fileTesto, 'Estremo 1: %d %d \n', [Biella(numBiella).spostamentiA]);
        fprintf(fileTesto, 'Estremo 2: %d %d \n', [Biella(numBiella).spostamentiB]);
    end
end
if numeroTriangoli ~= 0
    fprintf(fileTesto, '\n\nELEMENTI FINITI TRIANGOLARI \n\n');
    for numTriangolo = 1:numeroTriangoli
        esponente = raccogliMatrice(Triangolo(numTriangolo).K);
        vecchiaMatrice = Triangolo(numTriangolo).K;
        nuovaMatrice = vecchiaMatrice./(10^esponente);
        fprintf(fileTesto,'\n\nLa matrice di rigidezza del triangolo %d risulta: \n\n', numTriangolo);
        fprintf(fileTesto,'1.0*10^%d \n\n', esponente);
        scriviMatrice(fileTesto,nuovaMatrice);
        fprintf(fileTesto, '\nTabella delle incidenze triangolo %d:\n', numTriangolo);
        fprintf(fileTesto, 'Spostamenti orizzontali: %d %d %d \n', [Triangolo(numTriangolo).spostamentiOrizzontali]);
        fprintf(fileTesto, 'Spostamenti verticali: %d %d %d \n', [Triangolo(numTriangolo).spostamentiVerticali]);
        fprintf(fileTesto, '\n\nLa matrice di compatibilita'' del triangolo %d risulta essere:\n\n', numTriangolo);
        vecchiaMatrice = Triangolo(numTriangolo).matriceComp;
        esponente = raccogliMatrice(Triangolo(numTriangolo).matriceComp);
        nuovaMatrice = vecchiaMatrice./(10^esponente);
        fprintf(fileTesto,'1.0*10^%d \n\n', esponente);
        scriviMatrice(fileTesto,nuovaMatrice);
    end
end
if numeroRettangoli ~= 0
    fprintf(fileTesto, '\n\nELEMENTI FINITI RETTANGOLARI \n\n');
    for numRettangolo = 1:numeroRettangoli
        esponente = raccogliMatrice(Rettangolo(numRettangolo).K);
        vecchiaMatrice = Rettangolo(numRettangolo).K;
        nuovaMatrice = vecchiaMatrice./(10^esponente);
        fprintf(fileTesto,'\n\nLa matrice di rigidezza del rettangolo %d risulta: \n\n', numRettangolo);
        fprintf(fileTesto,'1.0*10^%d \n\n', esponente);
        scriviMatrice(fileTesto,nuovaMatrice);
        fprintf(fileTesto, '\nTabella delle incidenze rettangolo %d:\n', numRettangolo);
        fprintf(fileTesto, 'Spostamenti orizzontali: %d %d %d \n', [Rettangolo(numRettangolo).spostamentiOrizzontali]);
        fprintf(fileTesto, 'Spostamenti verticali: %d %d %d \n', [Rettangolo(numRettangolo).spostamentiVerticali]);
    end
end

fprintf(fileTesto, '\n\nMATRICE DI RIGIDEZZA DEL SISTEMA\n\n');
fprintf(fileTesto, '\n\nLa matrice di rigidezza totale risulta essere:\n\n');
esponente = raccogliMatrice(K);
vecchiaMatrice = K;
nuovaMatrice = vecchiaMatrice./(10^esponente);
fprintf(fileTesto,'1.0*10^%d \n\n', esponente);
scriviMatrice(fileTesto,nuovaMatrice);

fprintf(fileTesto, '\n\nLa matrice di rigidezza semplificata risulta essere:\n\n');
esponente = raccogliMatrice(k);
vecchiaMatrice = k;
nuovaMatrice = vecchiaMatrice./(10^esponente);
fprintf(fileTesto,'1.0*10^%d \n\n', esponente);
scriviMatrice(fileTesto,nuovaMatrice);

fprintf(fileTesto, '\n\nVETTORE DELLE FORZE DEL SISTEMA\n\n');
fprintf(fileTesto, '\n\nIl vettore delle forze totali risulta essere:\n\n');
esponente = raccogliMatrice(Ftot);
vecchiaMatrice = Ftot;
nuovaMatrice = vecchiaMatrice./(10^esponente);
fprintf(fileTesto,'1.0*10^%d \n\n', esponente);
scriviMatrice(fileTesto,nuovaMatrice);

fprintf(fileTesto, '\n\nIl vettore delle forze totali semplificato risulta essere:\n\n');
esponente = raccogliMatrice(ftot);
vecchiaMatrice = ftot;
nuovaMatrice = vecchiaMatrice./(10^esponente);
fprintf(fileTesto,'1.0*10^%d \n\n', esponente);
scriviMatrice(fileTesto,nuovaMatrice);

fprintf(fileTesto, '\n\nSPOSTAMENTI\n\n');
fprintf(fileTesto, '\n\nGli spostamenti dei nodi risultano:\n\n');
for i = 1:length(elementi)
    fprintf(fileTesto, '\nLo spostamento %d risulta pari a: %+f \n', elementi(i), spostamenti(i));
end
fclose(fileTesto);

%Sposto il file dei risultati nella cartella:
movefile('Risultati.txt',[percorso '/Studio' num2str(numeroCartella)]);  

%Salvo il workspace
save('variabiliSistema.mat');
movefile('variabiliSistema.mat',[percorso '/Studio' num2str(numeroCartella)]);

