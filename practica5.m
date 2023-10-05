clc
clear all
close all
warning off all

a =imread('peppers.png');
originalA = rgb2gray(a);
a = rgb2gray(a);
b=imread('imagen2.jpg');
matEcu = ecu(a,1);
tam = size(matEcu);
for i = 1:tam(2)
    a(a==uint8(matEcu(1,i))) = uint8(matEcu(3,i));
end
figure(1)
subplot(1,2,1)
imshow(originalA)
title('Imagen original')
subplot(1,2,2)
imshow(a)
title('Imagen ecualizada')


function ecualizacion = ecu(imagen,color)
    unicos = sort(unique(reshape(imagen(:,:,color).',1,[])));
    matrizPlana = reshape(imagen(:,:,color).',1,[]);
    tam = size(unicos);
    totalPixeles = length(matrizPlana);
    matEcualizacion = zeros(3,tam(2));
    matEcualizacion(1,:) = unicos;
    recuentosUnicos = zeros(size(unicos));
    minI = double(min(min(imagen(:,:,color))));
    maxI = double(max(max(imagen(:,:,color))));
    % Itera a través de los valores únicos y cuenta sus ocurrencias en A
    for i = 1:length(unicos)
        recuentosUnicos(i) = sum(matrizPlana == unicos(i));
    end 
    matEcualizacion(2,:) = recuentosUnicos;
    %frecuencias
    frecuencias = zeros(size(unicos));
    for i = 1:length(unicos)
        frecuencias(i) = double(recuentosUnicos(i)/totalPixeles);
    end 
    %frecuencias acumuladas
    frecAcum = zeros(size(unicos));
    for i = 1:length(unicos)
        if i == 1
            frecAcum(i) = double(frecuencias(i));
        else
            frecAcum(i) = double(frecuencias(i)+frecAcum(i-1));
        end
    end 
    %FG
    fg = zeros(size(unicos));
    for i = 1:length(unicos)
        fg(i) = round(((maxI-minI)*frecAcum(i))+minI); 
    end
    matEcualizacion(3,:) = fg;
    ecualizacion = matEcualizacion;
end