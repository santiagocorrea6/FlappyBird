%--------------------------------------------------------------------------
%------- FLAPPYBIRD -------------------------------------------------------
%------- Por: Santiago Correa Puerta    santiago.correa6@udea.edu.co ------
%-------      Estudiante de Ingenier�a Electr�nica  -----------------------
%-------      CC 1128461842, Tel 2861059,  Wpp 3182068572 -----------------
%------- Por: Julian Alejandro Bravo    alejandro.bravo@udea.edu.co -------
%-------      Estudiante de Ingenier�a Electr�nica  -----------------------
%-------      CC xxxxxxxxxx, Tel xxxxxxx,  Wpp 3162064562 -----------------
%------- Curso de Procesamiento Digital de Im�genes -----------------------
%------- Universidad de Antioquia, 2020 -----------------------------------
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%-- 1. Inicializar el sistema ---------------------------------------------
%--------------------------------------------------------------------------

clear all % Libera la memoria del sistema
close all % Cierra todas las ventanas, archivos y procesos abiertos
clc       % Limpia la ventana de comandos

%--------------------------------------------------------------------------
%-- 2. Configuraci�n inicial de la c�mara ---------------------------------
%--------------------------------------------------------------------------

cam = webcam;      % Abre la c�mara
cam = fliplr(cam); % C�mara en modo espejo
%preview(cam)     % Previsualizaci�n de la c�mara

%--------------------------------------------------------------------------
%-- 3. Configuraci�n inicial del juego ------------------------------------
%--------------------------------------------------------------------------

% ---- Posiciones iniciales de la base y tubos ----------------------------

score = 0;                  % Inicializa el puntaje
posBase = 0;                % Indica la pocici�n de la base
posxTubo1 = 290;            % Posici�n en 'x' del tubo 1
posxTubo2 = 440;            % Posici�n en 'x' del tubo 2
posxTubo3 = 590;            % Posici�n en 'x' del tubo 3
posicion = [120, 220];      % Posici�n inicial del p�jaro
posyTubo1 = [300, -80];     % Posici�n en 'y' del tubo 1
posyTubo2 = [220, -160];    % Posici�n en 'y' del tubo 2
posyTubo3 = [350, -30];     % Posici�n en 'y' del tubo 3

% ---- Carga imagenes y sonidos del juego ---------------------------------

tubo = imread('img/tubo.png');                % Carga imagen del tubo
base = imread('img/base.png');                % Carga imagen de la base
tubo2 = imrotate(tubo,-180);              % Rota 180� la imagen del tubo
fondo = imread('img/background-day.png');     % Carga imagen de fondo
bird1 = imread('img/bluebird-downflap.png');  % Carga imagen p�jaro down
bird2 = imread('img/bluebird-upflap.png');    % Carga imagen p�jaro up
[point, fs] = audioread('sound/sfx_point.wav'); % Carga sonido de puntuaci�n
[wing, fs2] = audioread('sound/sfx_wing.wav');  % Carga sonido de vuelo

% ---- Carga imagen de fondo y pausa para iniciar -------------------------

font = imread('img/start.png'); % Carga imagen de Start
figure(1), imshow(font)     % Imprime start en nueva figura
pause                       % Pausa para iniciar el jugo  

%--------------------------------------------------------------------------
%-- 4. Cuerpo del juego ---------------------------------------------------
%--------------------------------------------------------------------------

for i=1:inf
    
    % ---- Captura de imagen ----------------------------------------------
    
    img = snapshot(cam);   % Capturar imagen RGB de la c�mara
    
    % ---- Procesado de color ---------------------------------------------
    
    b = rgb2lab(img);      % Convierte de RGB a lab    
    b = b(:,:,3);          % Extrae la capa 3
    b = normaliza(b);      % Normaliza b
    
    % ---- Binarizar la imagen --------------------------------------------
   
    b(b<100) = 0;          % Valores menores que 100 igual a   0 
    b(b>0) = 255;          % Valores mayores que   0 igual a 255
    
    % ---- Tratamiento con elemento estructurante -------------------------
    
    se = strel('disk',7);  % Elemento estructurante disco
    b = imopen(b,se);      % Erosi�n - Dilataci�n
    b = imadjust(b);       % Ajuste de intensidad
    
    % ---- Cambia imagen de fondo -----------------------------------------
    
    figure(1), imshow(fondo) % Imprime imagen de fondo
    hold on                  % Conserva la imagen cargada
    
    % ---- Hallar diametro y centroide del objeto -------------------------
    
    bw = bwlabel(b, 8);       % Etiquetar los objetos en imagen binaria
    stats = regionprops('table',bw,'Centroid','MajorAxisLength','MinorAxisLength');
    centro = stats.Centroid;  % Captura la posici�n del centroide
    diametro = mean([stats.MajorAxisLength stats.MinorAxisLength],2); 
    
    % ---- Descartar objetos parasitos ------------------------------------
    
    if diametro > 80               % Cuando el diametro sea mayor a 80
        posicion = round(centro);  % Capture la posici�n del p�jaro
        
        % ---- Condiciones para imprimir el p�jaro ------------------------
        
        if (mod(i,2)==0)           % Alas hacia abajo
          image('XData',120,'YData',centro(2),'CData',bird1) %Imp p�jaro
        else                       % Alas hacia arriba
          image('XData',120,'YData',centro(2),'CData',bird2) %Imp p�jaro
          soundsc(wing, fs);       % Reproduce sonido de vuelo
        end                        % Fin del condicional 2
        
    end                            % Fin del condicional 1
    
    % ---- Movimiento en 'x' de los tubos ---------------------------------
    
    posxTubo1 = posxTubo1 - 5; % Mueve el tubo 1, 5 pixeles a la izq
    posxTubo2 = posxTubo2 - 5; % Mueve el tubo 2, 5 pixeles a la izq
    posxTubo3 = posxTubo3 - 5; % Mueve el tubo 3, 5 pixeles a la izq
    
    % ---- Imprime los 3 pares de tubos -----------------------------------
    
    image('XData',posxTubo1,'YData',posyTubo1(1),'CData',tubo)  % Imp t1 up
    image('XData',posxTubo1,'YData',posyTubo1(2),'CData',tubo2) % Imp t1 down
    
    image('XData',posxTubo2,'YData',posyTubo2(1),'CData',tubo)  % Imp t2 up
    image('XData',posxTubo2,'YData',posyTubo2(2),'CData',tubo2) % Imp t2 down
    
    image('XData',posxTubo3,'YData',posyTubo3(1),'CData',tubo)  % Imp t3 up
    image('XData',posxTubo3,'YData',posyTubo3(2),'CData',tubo2) % Imp t3 down
 
    % ---- Actualizar posici�n de los tubos -------------------------------
    
    if posxTubo1 < -150                             % Pocisi�n en 'x'
        posxTubo1 = 290;                            % Actualizar pos 'x'
        posyTubo1(1) = round((380-110)*rand+110);   % Pos aleatoria t1 up
        posyTubo1(2) = posyTubo1(1) - 380;          % Pos aleatoria t1 down
    end                                             % Fin del condicional 1
    
    if posxTubo2 < -150                             % Pocisi�n en 'x'
        posxTubo2 = 290;                            % Actualizar pos 'x'
        posyTubo2(1) = round((380-110)*rand+110);   % Pos aleatoria t2 up
        posyTubo2(2) = posyTubo2(1) - 380;          % Pos aleatoria t2 down
    end                                             % Fin del condicional 2
    
    if posxTubo3 < -150                             % Pocisi�n en 'x'
        posxTubo3 = 290;                            % Actualizar pos 'x'
        posyTubo3(1) = round((380-110)*rand+110);   % Pos aleatoria t3 up
        posyTubo3(2) = posyTubo3(1) - 380;          % Pos aleatoria t3 down
    end                                             % Fin del condicional 3

    % ---- Movimiento de la base ------------------------------------------
    
    posBase = posBase - 2;  % Mueve la base, 2 pixeles a la izq
    
    if posBase < -45        % Cuando la posici�n en 'x' de la base = -45
        posBase = 0;        % Actualizar posici�n de la base
    end                     % Fin del condicional
    
    image('XData',posBase,'YData',430,'CData',base) % Imprime la base
    
    % ---- Colisi�n con la base -------------------------------------------
    
    if posicion(2) > 430  % Si la posici�n en 'y' del p�jaro mayor a 430
       gameover();        % Fin del juego
    end                   % Fin del condicional
    
    % ---- Colisi�n con el tubo 1 -----------------------------------------
    
    if posxTubo1 > 75 && posxTubo1 < 140  % Posici�n en 'x' del tubo 1
        if posicion(2) > posyTubo1(1) || posicion(2) < (posyTubo1(1)-60) 
            gameover();                   % Fin del juego
            %break
        end                               % Fin del condicional 2
    end                                   % Fin del condicional 1
    
   if posxTubo1 == 90                     % Cuando posici�n t1 = 90
        score = score + 1;                % Sume un punto
        soundsc(point, fs);               % Reproducir sonido puntuaci�n
   end                                    % Fin del condicional
    
    % ---- Colisi�n con el tubo 2 -----------------------------------------   
    
    if posxTubo2 > 75 && posxTubo2 < 140 % Posici�n en 'x' del tubo 2
        if posicion(2) > posyTubo2(1) || posicion(2) < (posyTubo2(1)-60) 
            gameover();                  % Fin del juego
            %break
        end                              % Fin del condicional 2
    end                                  % Fin del condicional 1
    
    if posxTubo2 == 90                   % Cuando posici�n t2 = 90
        score = score + 1;               % Sume un punto
        soundsc(point, fs);              % Reproducir sonido puntuaci�n
    end                                  % Fin del condicional

    % ---- Colisi�n con el tubo 3 -----------------------------------------   
    
    if posxTubo3 > 75 && posxTubo3 < 140 % Posici�n en 'x' del tubo 3
        if posicion(2) > posyTubo3(1) || posicion(2) < (posyTubo3(1)-60) 
            gameover();                  % Fin del juego
            %break
        end                              % Fin del condicional 2
    end                                  % Fin del condicional 1
    
    if posxTubo3 == 90                   % Cuando posici�n t2 = 90
        score = score + 1;               % Sume un punto
        soundsc(point, fs);              % Reproducir sonido puntuaci�n
    end                                  % Fin del condicional
    
    % ---- Imprimir score -------------------------------------------------
    
    str = {num2str(score)};  % Convierte score a string
    text(119,100,str, 'FontName', 'Arial', 'FontSize', 32, 'Color', [0/255 228/255 232/255])
    text(120,100,str, 'FontName', 'Arial', 'FontSize', 30, 'Color', 'white')
    
end % --- Fin del juego ---------------------------------------------------

%--------------------------------------------------------------------------
%---------------------------  FIN DEL PROGRAMA ----------------------------
%--------------------------------------------------------------------------