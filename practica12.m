clc
clear all
close all
warning off all
clear variables

a = imread('pears.png');
imagenBN = im2bw(a);
%Se definen las estrucuturas a usar
discoRadio3 = [
    0 1 0; 
    1 1 1; 
    0 1 0
];
discoRadio7 = [
    0 0 0 1 0 0 0;
    0 0 1 1 1 0 0;
    0 1 1 1 1 1 0;
    1 1 1 1 1 1 1;
    0 1 1 1 1 1 0;
    0 0 1 1 1 0 0;
    0 0 0 1 0 0 0
];
estructuraT = [
    1 1 1;
    0 1 0;
    0 1 0
];

imagenBordes1 = encontrarBordes(imagenBN,discoRadio3);
imagenBordes2 = encontrarBordes(imagenBN,discoRadio7);
imagenBordes3 = encontrarBordes(imagenBN,estructuraT);


subplot(2,3,1)
imshow(a)
title('Imagen original')

subplot(2,3,2)
imshow(imagenBN)
title('Imagen ByN')

subplot(2,3,3)
imshow(imagenBordes1)
title('Bordes con estructura 1')

subplot(2,3,4)
imshow(imagenBordes2)
title('Bordes con estructura 2')

subplot(2,3,5)
imshow(imagenBordes3)
title('Bordes con estructura 3')


function imagen_dilatada = dilatarImagen(imagen, elemento_estructurante)
    [altura, ancho] = size(imagen);
    [ee_altura, ee_ancho] = size(elemento_estructurante);
    ee_centro = floor((size(elemento_estructurante) + 1) / 2);

    % Inicializar la imagen dilatada con ceros
    imagen_dilatada = zeros(altura, ancho);

    for i = 1:altura
        for j = 1:ancho
            if imagen(i, j) == 1
                for k = 1:ee_altura
                    for l = 1:ee_ancho
                        % Calcular las coordenadas del elemento estructurante en la imagen
                        i_ee = i + (k - ee_centro(1));
                        j_ee = j + (l - ee_centro(2));

                        % Verificar límites de la imagen
                        if i_ee >= 1 && i_ee <= altura && j_ee >= 1 && j_ee <= ancho
                            % Aplicar la dilatación
                            imagen_dilatada(i_ee, j_ee) = max(imagen_dilatada(i_ee, j_ee), elemento_estructurante(k, l));
                        end
                    end
                end
            end
        end
    end
end

function imagen_erosionada = erosionarImagen(imagen, elemento_estructurante)
    [altura, ancho] = size(imagen);
    [ee_altura, ee_ancho] = size(elemento_estructurante);
    ee_centro = floor((size(elemento_estructurante) + 1) / 2);

    % Inicializar la imagen erosionada con unos
    imagen_erosionada = ones(altura, ancho);

    for i = 1:altura
        for j = 1:ancho
            if imagen(i, j) == 0
                for k = 1:ee_altura
                    for l = 1:ee_ancho
                        % Calcular las coordenadas del elemento estructurante en la imagen
                        i_ee = i + (k - ee_centro(1));
                        j_ee = j + (l - ee_centro(2));

                        % Verificar límites de la imagen
                        if i_ee >= 1 && i_ee <= altura && j_ee >= 1 && j_ee <= ancho
                            % Aplicar la erosión
                            imagen_erosionada(i_ee, j_ee) = min(imagen_erosionada(i_ee, j_ee), elemento_estructurante(k, l));
                        else
                            % Si el elemento estructurante se sale de los límites de la imagen, se marca como 0
                            imagen_erosionada(i, j) = 0;
                        end
                    end
                end
            end
        end
    end
end

function bordes = encontrarBordes(imagen,estructura)
    erosion = erosionarImagen(imagen,estructura);
    apertura = dilatarImagen(erosion,estructura);
    bordes = apertura-erosion;
end