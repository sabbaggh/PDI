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


function imagen_dilatada = dilatacionOR(imagen, elemento_estructurante)
    [altura, ancho] = size(imagen);
    [ee_altura, ee_ancho] = size(elemento_estructurante);
    ee_centro = floor((size(elemento_estructurante) + 1) / 2);

    % Inicializar la imagen dilatada con la imagen original
    imagen_dilatada = imagen;

    for i = 1 + ee_centro(1):altura - ee_centro(1)
        for j = 1 + ee_centro(2):ancho - ee_centro(2)
            for k = 1:ee_altura
                for l = 1:ee_ancho
                    i_imagen = i + (k - ee_centro(1));
                    j_imagen = j + (l - ee_centro(2));
                    if imagen(i_imagen, j_imagen) == 1 || elemento_estructurante(k, l) == 1
                        imagen_dilatada(i, j) = 1;
                        break; % Se activó un píxel, no es necesario seguir verificando
                    end
                end
            end
        end
    end
end
function imagen_erosionada = erosionExacta(imagen, elemento_estructurante)
    [altura, ancho] = size(imagen);
    [ee_altura, ee_ancho] = size(elemento_estructurante);
    ee_centro = floor((size(elemento_estructurante) + 1) / 2);

    % Inicializar la imagen erosionada con ceros
    imagen_erosionada = zeros(altura, ancho);

    for i = 1 + ee_centro(1):altura - ee_centro(1)
        for j = 1 + ee_centro(2):ancho - ee_centro(2)
            coincidencia = true;
            for k = 1:ee_altura
                for l = 1:ee_ancho
                    i_imagen = i + (k - ee_centro(1));
                    j_imagen = j + (l - ee_centro(2));
                    if imagen(i_imagen, j_imagen) ~= elemento_estructurante(k, l)
                        coincidencia = false;
                        break;
                    end
                end
                if ~coincidencia
                    break;
                end
            end
            if coincidencia
                imagen_erosionada(i, j) = 1;
            end
        end
    end
end

function bordes = encontrarBordes(imagen,estructura)
    erosion = erosionExacta(imagen,estructura);
    apertura = dilatacionOR(erosion,estructura);
    bordes = apertura-erosion;
end