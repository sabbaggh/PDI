clc
clear all
close all
warning off all

a = imread("cameraman.tif");
%a=rgb2gray(a);
subplot(1,2,1)
imshow(a)
title('Original')

ruidosa = imnoise(a,"salt & pepper",0.04);
subplot(1,2,2)
imshow(ruidosa)
title('Ruidosa')