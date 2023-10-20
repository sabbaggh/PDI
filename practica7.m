clc
clear all
close all
warning off all
a = imread('peppers.png');
a = rgb2gray(a);
[alto, ancho] = size(a);
conBordes = zeros(alto+2,ancho+2,"uint8");
conBordes(2:end-1,2:end-1) = a;
imshow(conBordes)



function porMedia = calcMedia(imagenR,alto,ancho)
    
    [alto2, ancho2] = size(imagenR)
    porMedia = zeros(alto2,ancho2,"uint8");
    for i =2:alto2
        for j=2:ancho2
            porMedia(i,j)=round((double(imagenR(i,j)+double(imagenR(i+1,j+1))))
        end
    end

end