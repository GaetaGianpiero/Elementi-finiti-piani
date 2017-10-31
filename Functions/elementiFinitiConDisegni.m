% ELEMENTIFINITICONDISEGNI Questa funzione permette di calcolare gli
% spostamenti di una struttura costituita da:
% -travi
% -bielle
% -elementi finiti triangolari
% -elementi finiti rettangolari
% sottoposta a forze nodali, forze di volume, di superficie e dilatazioni
% termiche, utilizzando il metodo degli elementi finiti piani.
%
% 
% Autori: Fuso Andrea, Gaeta Gianpiero
% Versione: 1.0


global B
%Input iniziale
prompt = {'Numero di travi presenti:','Numero di bielle presenti:','Numero di triangoli presenti:','Numero di rettangoli presenti:'};
dlg_title = 'Inseririmento valori'; 
def = {'0','0','0','0'};
options.Interpreter = 'latex';
options.Resize = 'on';
lunghezzeInput = max([strlength(prompt{1})+1 strlength(prompt{2})+1 strlength(prompt{3})+1 strlength(prompt{4})+1]);
answer = inputdlg(prompt,dlg_title,[1 lunghezzeInput],def, options);
numeroTravi = str2num(answer{1});
numeroBielle = str2num(answer{2});
numeroTriangoli = str2num(answer{3});
numeroRettangoli = str2num(answer{4});

%Creazione strutture dati
Trave.area = [];            %Scalare [mm^2]
Trave.moduloYoung = [];     %Scalare [MPa]
Trave.inerzia = [];         %Scalare [mm^4]
Trave.lunghezza = [];       %Scalare [mm]
Trave.spostamentiA = [];    %Vettore [uA vA phiA]
Trave.spostamentiB = [];    %Vettore [uB vB phiB]
Trave.K = [];               %Matrice di rigidezza (6x6)
Trave.forze = [];           %Vettore (6x1)
Trave.coordinate = [];      %Matrice [xA yA; xB yB]
Trave.nomePunti = [];       %Cella ['NomeA' 'NomeB']

Biella.area = [];           %Scalare [mm^2]
Biella.moduloYoung = [];    %Scalare [MPa]
Biella.lunghezza = [];      %Scalare [mm]
Biella.angolo = [];         %Scalare [rad]
Biella.spostamentiA = [];   %Vettore [uA vA]
Biella.spostamentiB = [];   %Vettore [uB vB]
Biella.K = [];              %Matrice di rigidezza (4x4)
Biella.forze = [];          %Vettore 6x1
Biella.coordinate = [];     %Matrice [xA yA; xB yB]
Biella.nomePunti = [];      %Cella ['NomeA' 'NomeB']

Triangolo.spessore = [];                %Scalare [mm]
Triangolo.moduloYoung = [];             %Scalare [MPa]
Triangolo.moduloPoisson = [];           %Scalare [adimensionale]
Triangolo.coordinateA = [];             %Vettore [xA yA]
Triangolo.coordinateB = [];             %Vettore [xB yB]
Triangolo.coordinateC = [];             %Vettore [xC yC]
Triangolo.latoAB = [];                  %Scalare [mm]
Triangolo.latoBC = [];                  %Scalare [mm]
Triangolo.latoAC = [];                  %Scalare [mm]
Triangolo.area = [];                    %Scalare [mm^2]
Triangolo.spostamentiOrizzontali = [];  %Vettore [uA uB uC]
Triangolo.spostamentiVerticali = [];    %Vettore [vA vB vC]
Triangolo.K = [];                       %Matrice di rigidezza
Triangolo.forze = [];                   %Vettore (6x1)
Triangolo.forzeSuperficie = [];         %Vettore (6x1)
Triangolo.forzeVolume = [];             %Vettore (6x1)
Triangolo.coordinate = [];              %Matrice [xA yA; xB yB; xC yC]
Triangolo.nomePunti = [];               %Cella ['NomeA' 'NomeB' 'NomeC']
Triangolo.matriceComp = [];


Rettangolo.spessore = [];               %Scalare [mm]
Retttangolo.moduloYoung = [];           %Scalare [MPa]
Rettangolo.moduloPoisson = [];          %Scalare [adimensionale]
Rettangolo.coordinateA = [];            %Vettore [xA yA]
Rettangolo.coordinateB = [];            %Vettore [xB yB]
Rettangolo.coordinateC = [];            %Vettore [xC yC]
Rettangolo.coordinateD = [];            %Vettore [xD yD]
Rettangolo.latoAB = [];                 %Scalare [mm]
Rettangolo.latoBC = [];                 %Scalare [mm]
Rettangolo.latoCD = [];                 %Scalare [mm]
Rettangolo.latoDA = [];                 %Scalare [mm]
Rettangolo.area = [];                   %Scalare [mm^2]
Rettangolo.spostamentiOrizzontali = []; %Vettore [uA uB uC uD]
Rettangolo.spostamentiVerticali = [];   %Vettore [vA vB vC vD]
Rettangolo.K = [];                      %Matrice di rigidezza
Rettangolo.forzeSuperficie = [];        %Vettore (6x1)
Rettangolo.coordinate = [];             %Matrice [xA yA; xB yB; xC yC; xD yD]
Rettangolo.nomePunti = [];              %Cella ['NomeA' 'NomeB' 'NomeC' 'NomeD']

%Input caratteristiche degli elementi finiti
prevArea = 0;
grandezza = 200;
axis(gca, 'equal');
if numeroTravi ~= 0
    prevYoung = 206000;
    prevInerzia = 0;
    for i = 1:numeroTravi
        prompt = {'Area trave $A_{t}$ $\left[mm^{2}\right]$:','Modulo di Young $E$ $\left[\textnormal{MPa}\right]$:',...
            'Inerzia $I$ $\left[mm^{4}\right]$:','Lettera primo punto:','Coordinate del primo punto $x_{1}\;y_{1}\;[mm]$ :',...
            'Lettera secondo punto:','Coordinate del secondo punto $x_{2}\;y_{2}\;[mm]$ :'};
        dlg_title = ['Trave ',num2str(i)]; 
        def = {num2str(prevArea),num2str(prevYoung),num2str(prevInerzia),'Lettera','0 0','Lettera','0 0'};
        options.Interpreter = 'latex';
        options.Resize = 'on';
        lunghezzeInput = max([strlength(prompt{1})+1 strlength(prompt{2})+1 strlength(prompt{3})+1 strlength(prompt{4})+1 ...
            strlength(prompt{5})+1 strlength(prompt{6})+1 strlength(prompt{7})+1]);
        answer = inputdlg(prompt,dlg_title,[1 lunghezzeInput],def, options);
        Trave(i).area = str2num(answer{1});
        Trave(i).moduloYoung = str2num(answer{2});
        Trave(i).inerzia = str2num(answer{3});
        Trave(i).nomePunti{1} = answer{4};
        Trave(i).coordinate = [findCoord(answer{5}); findCoord(answer{7})];
        Trave(i).nomePunti{2} = answer{6};
        Trave(i).lunghezza = sqrt((Trave(i).coordinate(1,2)-Trave(i).coordinate(1,1))^2+(Trave(i).coordinate(2,2)-Trave(i).coordinate(2,1))^2);
        prevArea = Trave(i).area;
        prevYoung = Trave(i).moduloYoung;
        prevInerzia = Trave(i).inerzia;
        prevLunghezza = Trave(i).lunghezza;
        disegnoTrave(Trave(i).coordinate,Trave(i).nomePunti{1},Trave(i).nomePunti{2},grandezza);
    end
end

if numeroBielle ~= 0
    prevYoung = 206000;
    prevLunghezza = 0;
    for i = 1:numeroBielle
        prompt = {'Area biella $A_{b}$ $\left[mm^{2}\right]$:','Modulo di Young $E$ $\left[\textnormal{MPa}\right]$:',...
            'Lettera primo punto:','Coordinate del primo punto $x_{1}\;y_{1}\;[mm]$ :',...
            'Lettera secondo punto:','Coordinate del secondo punto $x_{2}\;y_{2}\;[mm]$ :'};
        dlg_title = ['Biella ',num2str(i)]; 
        def = {num2str(prevArea),num2str(prevYoung),'Lettera','0 0','Lettera','0 0'};
        options.Interpreter = 'latex';
        options.Resize = 'on';
        lunghezzeInput = max([strlength(prompt{1})+1 strlength(prompt{2})+1 strlength(prompt{3})+1 strlength(prompt{4})+1 ...
            strlength(prompt{4})+1 strlength(prompt{4})+1]);
        answer = inputdlg(prompt,dlg_title,[1 lunghezzeInput],def, options);
        Biella(i).area = str2num(answer{1});
        Biella(i).moduloYoung = str2num(answer{2});
        Biella(i).nomePunti{1} = answer{3};
        Biella(i).coordinate = [findCoord(answer{4}); findCoord(answer{6})];
        Biella(i).nomePunti{2} = answer{5};
        Biella(i).lunghezza = sqrt((Biella(i).coordinate(2,1)-Biella(i).coordinate(1,1))^2+(Biella(i).coordinate(2,2)-Biella(i).coordinate(1,2))^2);
        Biella(i).angolo = asin((Biella(i).coordinate(2,2)-Biella(i).coordinate(1,2))/Biella(i).lunghezza);
        prevArea = Biella(i).area;
        prevYoung = Biella(i).moduloYoung;
        prevLunghezza = Biella(i).lunghezza;
        disegnoBiella(Biella(i).coordinate,Biella(i).nomePunti{1},Biella(i).nomePunti{2},grandezza);
    end
end
if numeroTriangoli ~= 0
    prevSpessore = 0;
    prevYoung = 206000;
    prevPoisson = 0.3;
    for i = 1:numeroTriangoli
        prompt = {'Spessore triangolo $t$ $\left[mm\right]$:','Modulo di Young $E$ $\left[\textnormal{MPa}\right]$:',...
            'Modulo di Poisson $\nu$:','Lettera primo punto:','Coordinate primo punto $x_{1}\;y_{1}\;[mm]$:','Lettera secondo punto:',...
            'Coordinate secondo punto $x_{2}\;y_{2}\;[mm]$:','Lettera terzo punto:','Coordinate terzo punto $x_{3}\;y_{3}\;[mm]$:'};
        dlg_title = ['Triangolo ',num2str(i)]; 
        def = {num2str(prevSpessore),num2str(prevYoung),num2str(prevPoisson),'Lettera','0 0','Lettera','0 0','Lettera','0 0'};
        options.Interpreter = 'latex';
        options.Resize = 'on';
        lunghezzeInput = max([strlength(prompt{1})+1 strlength(prompt{2})+1 strlength(prompt{3})+1 strlength(prompt{4})+1 ...
            strlength(prompt{5})+1 strlength(prompt{6})+1 strlength(prompt{7})+1 strlength(prompt{8})+1 strlength(prompt{9})+1]);
        answer = inputdlg(prompt,dlg_title,[1 lunghezzeInput],def, options);
        Triangolo(i).spessore = str2num(answer{1});
        Triangolo(i).moduloYoung = str2num(answer{2});
        Triangolo(i).moduloPoisson = str2num(answer{3});
        Triangolo(i).nomePunti{1} = answer{4};
        Triangolo(i).coordinateA = findCoord(answer{5});
        Triangolo(i).nomePunti{2} = answer{6};
        Triangolo(i).coordinateB = findCoord(answer{7});
        Triangolo(i).nomePunti{3} = answer{8};
        Triangolo(i).coordinateC = findCoord(answer{9});
        Triangolo(i).coordinate = [Triangolo(i).coordinateA; Triangolo(i).coordinateB; Triangolo(i).coordinateC];
        Triangolo(i).area = abs((1/2)*det([Triangolo(i).coordinateA 1;Triangolo(i).coordinateB 1;Triangolo(i).coordinateC 1]));
        Triangolo(i).latoAB = sqrt(sum((Triangolo(i).coordinateB-Triangolo(i).coordinateA).^2));
        Triangolo(i).latoBC = sqrt(sum((Triangolo(i).coordinateC-Triangolo(i).coordinateB).^2));
        Triangolo(i).latoAC = sqrt(sum((Triangolo(i).coordinateC-Triangolo(i).coordinateA).^2));
        prevSpessore = Triangolo(i).spessore;
        prevYoung = Triangolo(i).moduloYoung;
        prevPoisson =Triangolo(i).moduloPoisson;
        disegnoTriangolo(Triangolo(i).coordinate,Triangolo(i).nomePunti{1},Triangolo(i).nomePunti{2},Triangolo(i).nomePunti{3},...
        grandezza);
    end
end
if numeroRettangoli ~= 0
    prevSpessore = 0;
    prevYoung = 206000;
    prevPoisson = 0.3;
    for i = 1:numeroRettangoli
        prompt = {'Spessore rettangolo $t$ $\left[mm\right]$:','Modulo di Young $E$ $\left[\textnormal{MPa}\right]$:',...
            'Modulo di Poisson $\nu$:','Lettera primo punto:','Coordinate primo punto $x_{1}\;y_{1}\;[mm]$:','Lettera secondo punto:',...
            'Coordinate secondo punto $x_{2}\;y_{2}\;[mm]$:','Lettera terzo punto:','Coordinate terzo punto $x_{3}\;y_{3}\;[mm]$:',...
            'Lettera quarto punto:','Coordinate quarto punto $x_{4}\;y_{4}\;[mm]$:'};
        dlg_title = ['Rettangolo ',num2str(i)]; 
        def = {num2str(prevSpessore),num2str(prevYoung),num2str(prevPoisson),'Lettera','0 0','Lettera','0 0','Lettera',...
            '0 0','Lettera','0 0'};
        options.Interpreter = 'latex';
        options.Resize = 'on';
        lunghezzeInput = max([strlength(prompt{1})+1 strlength(prompt{2})+1 strlength(prompt{3})+1 strlength(prompt{4})+1 strlength(prompt{5})+1]);
        answer = inputdlg(prompt,dlg_title,[1 lunghezzeInput],def, options);
        Rettangolo(i).spessore = str2num(answer{1});
        Rettangolo(i).moduloYoung = str2num(answer{2});
        Rettangolo(i).moduloPoisson = str2num(answer{3});
        Rettangolo(i).nomePunti{1} = answer{4};
        Rettangolo(i).coordinateA = findCoord(answer{5});
        Rettangolo(i).nomePunti{2} = answer{6};
        Rettangolo(i).coordinateB = findCoord(answer{7});
        Rettangolo(i).nomePunti{3} = answer{8};
        Rettangolo(i).coordinateC = findCoord(answer{9});
        Rettangolo(i).nomePunti{4} = answer{10};
        Rettangolo(i).coordinateD = findCoord(answer{11});
        Rettangolo(i).coordinate = [Rettangolo(i).coordinateA; Rettangolo(i).coordinateB; Rettangolo(i).coordinateC;Rettangolo(i).coordinateD];
        Rettangolo(i).latoAB = abs(Rettangolo(i).coordinateB(1)-Rettangolo(i).coordinateA(1));
        Rettangolo(i).latoBC = abs(Rettangolo(i).coordinateC(2)-Rettangolo(i).coordinateB(2));
        Rettangolo(i).latoCD = abs(Rettangolo(i).coordinateD(1)-Rettangolo(i).coordinateC(1));
        Rettangolo(i).latoDA = abs(Rettangolo(i).coordinateD(2)-Rettangolo(i).coordinateA(2));
        Rettangolo(i).area = (Rettangolo(i).latoAB)*(Rettangolo(i).latoDA);
        prevSpessore = Rettangolo(i).spessore;
        prevYoung = Rettangolo(i).moduloYoung;
        prevPoisson =Rettangolo(i).moduloPoisson;
        disegnoRettangolo(Rettangolo(i).coordinate,Rettangolo(i).nomePunti{1},Rettangolo(i).nomePunti{2},Rettangolo(i).nomePunti{3},...
        Rettangolo(i).nomePunti{4},grandezza);
    end
end
fig = getframe();

%% 

%Tabelle delle incidenze
if numeroTravi ~=0 
    for i = 1:numeroTravi
        prompt = {'Spostamenti estremo 1 $u_{1}\;v_{1}\;\varphi_{1}$:','Spostamenti estremo 2 $u_{2}\;v_{2}\;\varphi_{2}$:'};
        dlg_title = ['Tabella trave ',num2str(i)]; 
        def = {'0 0 0','0 0 0'};
        options.Interpreter = 'latex';
        options.Resize = 'on';
        lunghezzeInput = max([strlength(prompt{1})+1 strlength(prompt{2})+1]);
        answer = inputdlg(prompt,dlg_title,[1 lunghezzeInput],def, options);
        Trave(i).spostamentiA = findCoord(answer{1});
        Trave(i).spostamentiB = findCoord(answer{2}); 
    end
end
if numeroBielle ~= 0
    for i = 1:numeroBielle
        prompt = {'Spostamenti estremo 1 $u_{1}\;v_{1}$:','Spostamenti estremo 2 $u_{2}\;v_{2}$:'};
        dlg_title = ['Tabella biella ',num2str(i)]; 
        def = {'0 0','0 0'};
        options.Interpreter = 'latex';
        options.Resize = 'on';
        lunghezzeInput = max([strlength(prompt{1})+1 strlength(prompt{2})+1]);
        answer = inputdlg(prompt,dlg_title,[1 lunghezzeInput],def, options);
        Biella(i).spostamentiA = findCoord(answer{1});
        Biella(i).spostamentiB = findCoord(answer{2}); 
    end
end
if numeroTriangoli ~= 0
    for i = 1:numeroTriangoli
        prompt = {'Spostamenti orizzontali $u_{1}\;u_{2}\;u_{3}$:','Spostamenti verticali $v_{1}\;v_{2}\;v_{3}$:'};
        dlg_title = ['Tabella triangolo ',num2str(i)]; 
        def = {'0 0 0','0 0 0'};
        options.Interpreter = 'latex';
        options.Resize = 'on';
        lunghezzeInput = max([strlength(prompt{1})+1 strlength(prompt{2})+1]);
        answer = inputdlg(prompt,dlg_title,[1 lunghezzeInput],def, options);
        Triangolo(i).spostamentiOrizzontali = findCoord(answer{1});
        Triangolo(i).spostamentiVerticali = findCoord(answer{2}); 
    end
end
if numeroRettangoli ~= 0
    for i=1:numeroRettangoli
        prompt = {'Spostamenti orizzontali $u_{1}\;u_{2}\;u_{3}\;u_{4}$:','Spostamenti verticali $v_{1}\;v_{2}\;v_{3}\;v_{4}$:'};
        dlg_title = ['Tabella rettangolo ',num2str(i)]; 
        def = {'0 0 0 0','0 0 0 0'};
        options.Interpreter = 'latex';
        options.Resize = 'on';
        lunghezzeInput = max([strlength(prompt{1})+1 strlength(prompt{2})+1]);
        answer = inputdlg(prompt,dlg_title,[1 lunghezzeInput],def, options);
        Rettangolo(i).spostamentiOrizzontali = findCoord(answer{1});
        Rettangolo(i).spostamentiVerticali = findCoord(answer{2}); 
    end
end

%Calcolo le matrici di rigidezza
maxTrave = 0;                       %maxTrave, maxBiella, maxTriangolo, maxRettangolo, utilizzati per determinare le dimensioni di K
if numeroTravi ~= 0 
    for i = 1:numeroTravi
        Trave(i).K = kTrave(Trave(i).moduloYoung,Trave(i).area,Trave(i).lunghezza,Trave(i).inerzia);
        maxTrave = max(max([Trave(i).spostamentiA,Trave(i).spostamentiB]),maxTrave);
    end
end
maxBiella = 0;
if numeroBielle ~= 0
    for i = 1:numeroBielle
        Biella(i).K = kBiella(cos(Biella(i).angolo),sin(Biella(i).angolo),Biella(i).moduloYoung,...
            Biella(i).area,Biella(i).lunghezza);
        maxBiella = max(max([Biella(i).spostamentiA,Biella(i).spostamentiB]),maxBiella);
    end
end
maxTriangolo = 0;
if numeroTriangoli ~= 0
    for i = 1:numeroTriangoli
        matCoordTri = [Triangolo(i).coordinateA; Triangolo(i).coordinateB; Triangolo(i).coordinateC];
        Triangolo(i).K = kTriangolo(0,0, matCoordTri,Triangolo(i).moduloYoung, Triangolo(i).moduloPoisson,...
            Triangolo(i).spessore, Triangolo(i).area);
                Triangolo(i).matriceComp = B;
        maxTriangolo = max(max([Triangolo(i).spostamentiOrizzontali, Triangolo(i).spostamentiVerticali]),maxTriangolo);
    end
end
maxRettangolo = 0;
if numeroRettangoli ~= 0
    for i = 1:numeroRettangoli
        Rettangolo(i).K = kRettangolo(Rettangolo(i).moduloYoung,Rettangolo(i).spessore,Rettangolo(i).moduloPoisson,...
            Rettangolo(i).latoBC,Rettangolo(i).latoAB);
        maxRettangolo = max(max([Rettangolo(i).spostamentiOrizzontali, Rettangolo(i).spostamentiVerticali]),maxRettangolo);
    end
end

%Calcolo matrice di rigidezza del sistema
dimensione = max([maxTrave maxBiella maxTriangolo maxRettangolo]);      %Dimensione matrice di rigidezza del sistema
K = zeros(dimensione,dimensione);
if numeroTravi ~= 0
    for i = 1:numeroTravi
        M = zeros(dimensione,dimensione);
        M([Trave(i).spostamentiA Trave(i).spostamentiB],[Trave(i).spostamentiA Trave(i).spostamentiB] ) = Trave(i).K;
        K = K + M;
    end
end
if numeroBielle ~= 0
    for i = 1:numeroBielle
        M = zeros(dimensione,dimensione);
        M([Biella(i).spostamentiA Biella(i).spostamentiB],[Biella(i).spostamentiA Biella(i).spostamentiB] ) = Biella(i).K;
        K = K + M;
    end
end
if numeroTriangoli ~= 0
    for i = 1:numeroTriangoli
        M = zeros(dimensione,dimensione);
        M([Triangolo(i).spostamentiOrizzontali Triangolo(i).spostamentiVerticali],...
            [Triangolo(i).spostamentiOrizzontali Triangolo(i).spostamentiVerticali] ) = Triangolo(i).K;
        K = K + M;
    end
end
if numeroRettangoli ~= 0
    for i = 1:numeroRettangoli
        M = zeros(dimensione,dimensione);
        M([Rettangolo(i).spostamentiOrizzontali Rettangolo(i).spostamentiVerticali],...
            [Rettangolo(i).spostamentiOrizzontali Rettangolo(i).spostamentiVerticali]) = Rettangolo(i).K;
        K = K + M;
    end
end

%Scelta degli spostamenti
prompt = {'Spostamenti di interesse:'};
dlg_title = 'Scelta spostamenti'; 
def = {'0 0'};
options.Interpreter = 'latex';
options.Resize = 'on';
lunghezzeInput = strlength(prompt{1})+1;
answer = inputdlg(prompt,dlg_title,[1 lunghezzeInput],def, options);
elementi = findCoord(answer{1});
elementi = sort(elementi);
if sum(elementi<0) ~= 0                 %Se lo spostamento è negativo si cambia segno (per evitare problemi con gli indici
    segno = elementi<0;                 %delle matrici, ma si tiene conto del segno per poterlo cambiare alla fine.
    elementi(find(elementi<0)) = elementi(find(elementi<0))*(-1);
else 
    segno = zeros(1,length(elementi));
end   
k = K([elementi],[elementi]);

%Calcolo delle forze
%Forze sulle travi
Ftot = zeros(dimensione,1);
if numeroTravi ~= 0
    for i = 1:numeroTravi
        prompt = {'Carico trasversale $q\left(z\right)=q_{2}z^{2}+q_{1}z+q_{0}\;\;\left[N/mm\right]$:','Carico assiale $p\left(z\right)=p_{2}z^{2}+p_{1}z+p_{0}$:','Carico momento $m\left(z\right)=m_{0}$:',...
            'Estremo inferiore di integrazione $[mm]$:', 'Estremo superiore di integrazione $[mm]$:'};
        dlg_title = ['Carichi sulla trave',num2str(i)]; 
        def = {'0 0 0','0 0 0','0','0','0'};
        options.Interpreter = 'latex';
        options.Resize = 'on';
        lunghezzeInput = max([strlength(prompt{1})+1 strlength(prompt{2})+1 strlength(prompt{3})+1]);
        answer = inputdlg(prompt,dlg_title,[1 lunghezzeInput],def, options);
        q = findCoord(answer{1});
        p = findCoord(answer{2});
        m = str2num(answer{3});
        inizio = str2num(answer{4});
        fine = str2num(answer{5});
        Trave(i).forze = forzeSuTraveGen(q,p,m,Trave(i).lunghezza,inizio,fine);
        FtotTrave = zeros(dimensione,1);
        FtotTrave([Trave(i).spostamentiA Trave(i).spostamentiB],1) = Trave(i).forze;
        Ftot = Ftot + FtotTrave;
    end
end
%Forze sulle bielle (dilatazioni termiche)
if numeroBielle ~= 0
    for i = 1:numeroBielle
        prompt = {'Dilatazione termica $\varepsilon^{\Delta\:T}$:'};
        dlg_title = ['Dilatazione sulla biella',num2str(i)]; 
        def = {'0'};
        options.Interpreter = 'latex';
        options.Resize = 'on';
        lunghezzeInput = [strlength(prompt{1})+1];
        answer = inputdlg(prompt,dlg_title,[1 lunghezzeInput],def, options);
        Biella(i).forze = dilaBiella(str2num(answer{1}),Biella(i).moduloYoung,Biella(i).area,Biella(i).angolo);
        FtotBiella = zeros(dimensione,1);
        FtotBiella([Biella(i).spostamentiA Biella(i).spostamentiB],1) = Biella(i).forze;
        Ftot = Ftot + FtotBiella;
        end
end
%Forze sui triangoli
if numeroTriangoli ~= 0
    for i = 1:numeroTriangoli
        prompt = {'Forze di volume $f^{vol}_x\;f^{vol}_{y}\;\;\left[N/mm^{3}\right]$:',...
            'Forze di superficie sul lato $\overline{AB}\;f^{AB}_{x}\;f^{AB}_{y}\;\;\left[N/mm^{2}\right]$:',...
            'Forze di superficie sul lato $\overline{BC}\;f^{BC}_{x}\;f^{BC}_{y}\;\;\left[N/mm^{2}\right]$:',...
            'Forze di superficie sul lato $\overline{AC}\;f^{AC}_{x}\;f^{AC}_{y}\;\;\left[N/mm^{2}\right]$:',...
            'Carico trasversale sul lato $\overline{AB}\;\;q_{x}^{AB}\;q_{y}^{AB}\;\;\left[N/mm\right]$:',...
            'Carico trasversale sul lato $\overline{BC}\;\;q_{x}^{BC}\;q_{y}^{BC}\;\;\left[N/mm\right]$:',...
            'Carico trasversale sul lato $\overline{AC}\;\;q_{x}^{AC}\;q_{y}^{AC}\;\;\left[N/mm\right]$:'};
        dlg_title = ['Forze sul triangolo',num2str(i)]; 
        def = {'0 0','0 0','0 0','0 0','0 0','0 0','0 0'};
        options.Interpreter = 'latex';
        options.Resize = 'on';
        lunghezzeInput = max([strlength(prompt{1})+1 strlength(prompt{2})+1 strlength(prompt{3})+1 strlength(prompt{4})+1 ...
            strlength(prompt{5})+1 strlength(prompt{6})+1 strlength(prompt{7})+1]);
        answer = inputdlg(prompt,dlg_title,[1 lunghezzeInput],def, options);
        fVol = findCoord(answer{1});
        fSupAB = findCoord(answer{2});
        fSupBC = findCoord(answer{3});
        fSupAC = findCoord(answer{4});
        qTrasvAB = findCoord(answer{5});
        qTrasvBC = findCoord(answer{6});
        qTrasvAC = findCoord(answer{7});
        [Triangolo(i).forzeSuperficie,Triangolo(i).forzeVolume] = forzeSuTriangolo(Triangolo(i).area,Triangolo(i).latoAB,Triangolo(i).latoBC,...
            Triangolo(i).latoAC,Triangolo(i).spessore,fSupAB,fSupBC,fSupAC,fVol,0);
        [qTrasv, qVol] = forzeSuTriangolo(Triangolo(i).area,Triangolo(i).latoAB,Triangolo(i).latoBC,...
            Triangolo(i).latoAC,Triangolo(i).spessore,qTrasvAB,qTrasvBC,qTrasvAC,[0 0],1);
        Triangolo(i).forzeSuperficie = Triangolo(i).forzeSuperficie + qTrasv;
        FtotTriang = zeros(dimensione,1);
        FtotTriang([Triangolo(i).spostamentiOrizzontali Triangolo(i).spostamentiVerticali],1) = Triangolo(i).forzeSuperficie+Triangolo(i).forzeVolume;
        Ftot = Ftot + FtotTriang;
    end
end
%Forze sui rettangoli
if numeroRettangoli ~= 0
    for i = 1:numeroRettangoli
        prompt = {'Forze di superficie sul lato $\overline{AB}\;f^{AB}_{x}\;f^{AB}_{y}\;\;\left[N/mm^{2}\right]$:',...
            'Forze di superficie sul lato $\overline{BC}\;f^{BC}_{x}\;f^{BC}_{y}\;\;\left[N/mm^{2}\right]$:',...
            'Forze di superficie sul lato $\overline{CD}\;f^{CD}_{x}\;f^{CD}_{y}\;\;\left[N/mm^{2}\right]$:',...
            'Forze di superficie sul lato $\overline{DA}\;f^{DA}_{x}\;f^{DA}_{y}\;\;\left[N/mm^{2}\right]$:'};
        dlg_title = ['Forze sul rettangolo',num2str(i)]; 
        def = {'0 0','0 0','0 0','0 0'};
        options.Interpreter = 'latex';
        options.Resize = 'on';
        lunghezzeInput = max([strlength(prompt{1})+1 strlength(prompt{2})+1 strlength(prompt{3})+1 strlength(prompt{4})+1]);
        answer = inputdlg(prompt,dlg_title,[1 lunghezzeInput],def, options);
        fAB = findCoord(answer{1});
        fBC = findCoord(answer{2});
        fCD = findCoord(answer{3});
        fDA = findCoord(answer{4});
        Rettangolo(i).forzeSuperficie = forzeSuRettangolo(Rettangolo(i).spessore,Rettangolo(i).latoAB,Rettangolo(i).latoBC,Rettangolo(i).latoCD,...
            Rettangolo(i).latoDA,fAB,fBC,fCD,fDA);
        FtotRettangolo = zeros(dimensione,1);
        FtotRettangolo([Rettangolo(i).spostamentiOrizzontali Rettangolo(i).spostamentiVerticali],1) = Rettangolo(i).forzeSuperficie;
        Ftot = Ftot + FtotRettangolo;
    end
end

%Forze nodali
prompt = {'Nodi sui quali sono presenti forze nodali:','Carichi nodali [N]:'};
dlg_title = 'Forze nodali'; 
def = {'1 2','0 0'};
options.Interpreter = 'latex';
options.Resize = 'on';
lunghezzeInput = max([strlength(prompt{1})+1 strlength(prompt{2})+1]);
answer = inputdlg(prompt,dlg_title,[1 lunghezzeInput],def, options);
nodi = findCoord(answer{1});
fNod = findCoord(answer{2});
fNodali = zeros(dimensione,1);
fNodali([nodi],1) = fNod;


%Forza totale
Ftot = Ftot+fNodali;
ftot = Ftot([elementi],1);

%Spostamenti
spostamenti = inv(k)*ftot;
spostamenti(find(segno==1)) = spostamenti(find(segno==1))*(-1);
for i = 1:length(elementi)
    fprintf('\nLo spostamento %d è pari a %f \n', elementi(i), spostamenti(i));
end
fprintf('\nFine programma\n');
