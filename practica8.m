clc
clear all
close all
warning off all

a = imread("lalo2.jpg");
tam = size(a);
a = rgb2gray(a);

nim = hacerimagenDCT(a);

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