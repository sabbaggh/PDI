clc
clear all
close all
warning off all

%leyendo el histograma de una imagen
h = imread('peppers.png');
figure()
imhist(h)



disp('fin de proceso...')