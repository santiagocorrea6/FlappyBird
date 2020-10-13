%--------------------------------------------------------------------------
%------- FLAPPYBIRD: Fin del juego ----------------------------------------
%--------------------------------------------------------------------------

% ---- Cargar y reproducir sonido de colisión -----------------------------

[y, fs] = audioread('sound/sfx_hit.wav'); % Carga audio de colisión
soundsc(y, fs);                     % Reproduce sonido de colición
pause(2)                            % Pausa la ejecucion

% ---- Cargar y reproducir sonido fin del juego ---------------------------

[y, fs] = audioread('sound/die.wav'); % Carga audio de fin del juego
soundsc(y, fs);                 % Reproduce sonido de fin del juego

% ---- Cargar e imprimir imagen fin del juego -----------------------------

base = imread('img/game_over.png');         % Carga imagen fin del juego
image('XData',0,'YData',0,'CData',base) % Imprime imagen fin del juego

% ---- Imprimir puntaje ---------------------------------------------------

str = {num2str(score)}; % Convierte el puntaje a string

if score >= 10 % Si el puntaje es de una sola cifra
    text(120,280,str, 'FontName', 'Arial', 'FontSize', 35, 'Color', [0/255 228/255 232/255])
    text(120,280,str, 'FontName', 'Arial', 'FontSize', 30, 'Color', [255/255 170/255 0/255])
else           % Si el puntaje es de dos cifras
    text(128,280,str, 'FontName', 'Arial', 'FontSize', 35, 'Color', [0/255 228/255 232/255])
    text(130,280,str, 'FontName', 'Arial', 'FontSize', 30, 'Color', [255/255 170/255 0/255])
end            % Fin del condicional

% ---- Liberar memoria y cerrar ventanas ----------------------------------

pause(2)       % Pausa para reiniciar el juego
clear all      % Libera la memoria del sistema
close all      % Cierra todas las ventanas, archivos y procesos abiertos
clc            % Limpia la ventana de comandos

% ---- Reiniciar juego ----------------------------------------------------

flappybird     % Reiniciar juego

%--------------------------------------------------------------------------
%------- Final de la función ----------------------------------------------
%--------------------------------------------------------------------------

