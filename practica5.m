clc
clear all
close all
warning off all

a =imread('imagen1.jpg');
originalA = rgb2gray(a);
a = rgb2gray(a);
b=imread('imagen2.jpg');
matEcu = ecu(a,1);
tam = size(a);
tam2 = size(matEcu);
xdd = zeros(tam,'uint8');
for i = 1:tam(1)
   for j = 1:tam(2)
        index = find(matEcu(1,:) == originalA(i,j));
        xdd(i,j) = matEcu(3,index);
   end
end
%for i = 1:tam2(2)
 %   a(a==matEcu(1,i))=uint8(matEcu(3,i));
%end

figure(1)
subplot(1,2,1)
imshow(originalA)
title('Imagen original')
subplot(1,2,2)
imshow(xdd)
title('Imagen ecualizada')


function ecualizacion = ecu(imagen,color)
    unicos = sort(unique(reshape(imagen(:,:,color).',1,[])));
    matrizPlana = reshape(imagen(:,:,color).',1,[]);
    tam = size(unicos);
    totalPixeles = length(matrizPlana);
    matEcualizacion = zeros(3,tam(2),'uint8');
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