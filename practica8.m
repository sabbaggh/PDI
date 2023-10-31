clc
clear all
close all
warning off all

a = imread("peppers.png");
a = rgb2gray(a);
[alto,ancho] = size(a);
imagenDCT = a;
imagenDCT = dct2(imagenDCT);
numBloquesFil = floor(alto/8)
numBloquesCol = floor(ancho/8)
figure(1)
imshow(imagenDCT)
title('Imagen con transformada de coseno discreto')
tamBloque = 8;

matrizOriginal = zeros(numBloquesFil,numBloquesCol);

for i = 1:numBloquesFil
    for j =1:numBloquesCol
        bloque = imagenDCT((i-1)*tamBloque+1:(i)*tamBloque, (j-1)*tamBloque+1:(j)*tamBloque);
        matrizOriginal(i,j) = bloque(1,1);
    end
end

%nim = hacerimagenDCT(a);
matrizPrediccion = zeros(numBloquesFil, numBloquesCol);
matrizPrediccion(1:end,1) = matrizOriginal(1:end,1);
matrizPrediccion(1,1:end) = matrizOriginal(1,1:end);
figure(2)
subplot(2,2,1)
imshow(matrizOriginal)
subplot(2,2,2)
imshow(bloque)
subplot(2,2,3)
imshow(matrizPrediccion)



function imagenDCT = hacerimagenDCT(imagen)
    [alto,ancho] = size(imagen);
    alto2 = (floor(alto/8))*8;
    ancho2 = (floor(ancho/8))*8;
    imagenDCT = zeros(alto2,ancho2);
    for i = 1:8:alto
        fila = zeros(8,ancho2);
        for j = 1:8:ancho
            if i + 8<=alto && j+8<=ancho
            aux = [imagen(i,j),imagen(i,j+1),imagen(i,j+2),imagen(i,j+3),imagen(i,j+4),imagen(i,j+5),imagen(i,j+6),imagen(i,j+7);
                imagen(i+1,j),imagen(i+1,j+1),imagen(i+1,j+2),imagen(i+1,j+3),imagen(i+1,j+4),imagen(i+1,j+5),imagen(i+1,j+6),imagen(i+1,j+7);
                imagen(i+2,j),imagen(i+2,j+1),imagen(i+2,j+2),imagen(i+2,j+3),imagen(i+2,j+4),imagen(i+2,j+5),imagen(i+2,j+6),imagen(i+2,j+7);
                imagen(i+3,j),imagen(i+3,j+1),imagen(i+3,j+2),imagen(i+3,j+3),imagen(i+3,j+4),imagen(i+3,j+5),imagen(i+3,j+6),imagen(i+3,j+7);
                imagen(i+4,j),imagen(i+4,j+1),imagen(i+4,j+2),imagen(i+4,j+3),imagen(i+4,j+4),imagen(i+4,j+5),imagen(i+4,j+6),imagen(i+4,j+7);
                imagen(i+5,j),imagen(i+5,j+1),imagen(i+5,j+2),imagen(i+5,j+3),imagen(i+5,j+4),imagen(i+5,j+5),imagen(i+5,j+6),imagen(i+5,j+7);
                imagen(i+6,j),imagen(i+6,j+1),imagen(i+6,j+2),imagen(i+6,j+3),imagen(i+6,j+4),imagen(i+6,j+5),imagen(i+6,j+6),imagen(i+6,j+7);
                imagen(i+7,j),imagen(i+7,j+1),imagen(i+7,j+2),imagen(i+7,j+3),imagen(i+7,j+4),imagen(i+7,j+5),imagen(i+7,j+6),imagen(i+7,j+7)];
            end
            fila(:,j:j+7) = aux;
        end
        imagenDCT(i:i+7,:) = fila;
    end
end