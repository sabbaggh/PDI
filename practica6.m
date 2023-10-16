clc
clear all
close all
warning off all

a = imread('imagen5.jpg');
a = rgb2gray(a);
[alto, ancho] = size(a);


matA = a;
matA(2:alto,2:ancho) = 0;


imnueva = prediccion(matA,ancho,alto);
imshow(imnueva)


function matPrediccion = prediccion(matPrediccion,ancho,alto)
    for i = 2:2:700
        for j=2:2:500
            b1 = round((double(matPrediccion(i-1,j-1))+double(matPrediccion(i,j-1))+double(matPrediccion(i+1,j-1))+double(matPrediccion(i-1,j))+double(matPrediccion(i-1,j+1)))/5);
            b2 = round((double(b1)+double(matPrediccion(i-1,j))+double(matPrediccion(i-1,j+1))+double(matPrediccion(i-1,j+2)))/4);
            if j > 2
                b3 = round((double(matPrediccion(i+1,j-1))+double(matPrediccion(i,j-1))+double(b1)+double(b2))/4);
            else
                b3 = round((double(matPrediccion(i+2,j-1))+double(matPrediccion(i+1,j-1))+double(matPrediccion(i,j-1))+double(b1)+double(b2))/5);
            end
            b4 = round((double(b1)+double(b2)+double(b3))/3);
            matPrediccion(i,j) = b1;
            matPrediccion(i,j+1) = b2;
            matPrediccion(i+1,j) = b3;
            matPrediccion(i+1,j+1) = b4;
        end
    end

end














