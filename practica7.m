clc
clear all
close all
warning off all
a = imread('peppers.png');
a = rgb2gray(a);
[alto, ancho] = size(a);
conBordes = zeros(alto+2,ancho+2,"uint8");
ruidosa = imnoise(a,"salt & pepper",0.04);
conBordes(2:end-1,2:end-1) = ruidosa;

matrizRuido = detectPRuidoso(conBordes,alto,ancho);
subplot(1,2,1)
imshow(a)
title('Original')
subplot(1,2,2)
imshow(conBordes)
title('Noise')

function porCentral = quitarRuidoPorCentral(matrizRuido)
end

function porMedia = calcMedia(imagenR,alto,ancho)
    [alto2, ancho2] = size(imagenR);
    porMedia = zeros(alto2,ancho2,"uint8");
    for i =2:alto2
        for j=2:ancho2
            porMedia(i,j)=round((double(imagenR(i,j))+double(imagenR(i+1,j+1))+double(imagenR(i-1,j-1))+double(imagenR(i-1,j))+double(imagenR(i-1,j+1))+double(imagenR(i,j-1))+double(imagenR(i+1,j-1))+double(imagenR(i+1,j))+double(imagenR(i,j+1)))/9);
        end
    end
end
function valorCentral = calcCentral(array)
    B = sort(array);
    valorCentral = B(5);

end

function matrizRuidosos = detectPRuidoso(imagenR,alto,ancho)
    matrizRuidosos = zeros(2,1);
    for i =2:alto
        for j=2:ancho
            media=round((double(imagenR(i,j))+double(imagenR(i+1,j+1))+double(imagenR(i-1,j-1))+double(imagenR(i-1,j))+double(imagenR(i-1,j+1))+double(imagenR(i,j-1))+double(imagenR(i+1,j-1))+double(imagenR(i+1,j))+double(imagenR(i,j+1)))/9);
            if imagenR(i,j) > media+50 || imagenR(i,j) <media-50
                matrizRuidosos = [matrizRuidosos [i;j]];
            end
        end
    end
end