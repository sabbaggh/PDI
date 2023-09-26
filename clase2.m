clc
close all
clear all
warning off all

a=imread('peppers.png');
%grises rojo
roja=a;
roja(:,:,1);
subplot(2,3,1)
imshow(roja(:,:,1));
title('Grises rojo')
%Grises verde
verde = a;
verde(:,:,2);
subplot(2,3,2)
imshow(verde(:,:,2))
title('Grises verde')
%Grises azul
azul = a;
azul(:,:,3);
subplot(2,3,3)
imshow(azul(:,:,3))
title('Grises azul')
%gris normal
grises = rgb2gray(a);
subplot(2,3,5)
imshow(grises)
title('Escala de grises normal')



disp('Fin del proceso')
